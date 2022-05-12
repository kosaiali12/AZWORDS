// ignore_for_file: camel_case_types, avoid_types_as_parameter_names, non_constant_identifier_names, avoid_print

import 'package:azwords/Function/database.dart';
import 'package:azwords/Function/notification_api.dart';
import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Up_Button extends StatefulWidget {
  const Up_Button({
    required this.scrollController,
    Key? key,
    required this.isScrolling,
  }) : super(key: key);

  final bool isScrolling;
  final ScrollController scrollController;

  @override
  State<Up_Button> createState() => _Up_ButtonState();
}

class _Up_ButtonState extends State<Up_Button> {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var androidinit = const AndroidInitializationSettings('ic_launcher');
    var initializationsetting = InitializationSettings(android: androidinit);
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    localNotificationsPlugin.initialize(initializationsetting);
  }

  Future showNitification(DateTime date) async {
    tz.initializeTimeZones();
    final locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));
    var androiddetail = const AndroidNotificationDetails(
        'channelID', 'localNotification',
        channelDescription: 'Description of the notification',
        importance: Importance.high);
    var generateNotificationDetails =
        NotificationDetails(android: androiddetail);
    await localNotificationsPlugin.zonedSchedule(0, 'title', 'body',
        _sechedualeDate(Time(10, 7)), generateNotificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static tz.TZDateTime _sechedualeDate(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    print(now);
    final schedualDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);
    print(schedualDate);
    return schedualDate.isBefore(now)
        ? schedualDate.add(Duration(days: 1))
        : schedualDate;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, WordData, child) => AnimatedScale(
        duration: const Duration(milliseconds: 500),
        scale: widget.isScrolling && WordData.adding ? 1 : 1,
        curve: Curves.easeInOutExpo,
        child: Container(
          height: 35,
          width: 35,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(35)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 0.5,
                spreadRadius: 0.1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: RawMaterialButton(
              onPressed: () {
                showNitification(DateTime.now().add(Duration(seconds: 10)));
                // widget.scrollController.animateTo(0,
                //     duration: const Duration(milliseconds: 1000),
                //     curve: Curves.easeInOutBack);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              child: const Icon(
                Icons.arrow_upward_sharp,
                size: 20,
                color: Colors.blue,
              )),
        ),
      ),
    );
  }
}

class Add_Button extends StatefulWidget {
  Add_Button(
      {Key? key,
      required this.isScrolling,
      required this.size,
      required this.selected_words,
      required this.words,
      required this.delete_words,
      required this.scrollController})
      : super(key: key);
  final bool isScrolling;
  final Size size;
  final List<String> selected_words;
  final ScrollController scrollController;
  List<Word> words;
  final Function delete_words;
  @override
  State<Add_Button> createState() => _Add_ButtonState();
}

class _Add_ButtonState extends State<Add_Button> {
  final MethodChannel platform = const MethodChannel('sendData');
  late bool isDone = false;

  Future<void> fun() async {
    try {
      var b = await platform.invokeMethod('fun');
      print('result :' + b.toString());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, WordData, child) => AnimatedPositioned(
        curve: Curves.easeInOutBack,
        duration: const Duration(milliseconds: 500),
        bottom: !widget.isScrolling ? 32 : 12,
        right: !widget.isScrolling
            ? widget.size.height > widget.size.width
                ? widget.size.width / 2 - widget.size.width / 14
                : widget.size.width / 2 - widget.size.width / 24
            : 20,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: WordData.adding ? 1 : 0,
          child: GestureDetector(
              onTap: () async {
                // NotificationAPI.showNotification(
                // title: 'Adding', body: 'Adding A new word');
                if (WordData.adding && !WordData.selecting) {
                  WordData.setAdd(false);
                  // WordData.sortAtoZ();
                  print(WordData.adding);
                }
                if (WordData.selecting) {
                  for (int i = 0; i < widget.selected_words.length; i++) {
                    await WordsDatabase.instance
                        .deletWord(widget.selected_words[i]);
                  }

                  // widget.words.removeRange(0, widget.words.length);
                  WordData.setselecting(false);

                  // widget.scrollController.jumpTo(1);
                  widget.selected_words
                      .removeRange(0, widget.selected_words.length);
                  widget.delete_words();
                  setState(() {});
                  await fun();
                  print(widget.words.length);
                }
              },
              child: AnimatedScale(
                duration: const Duration(milliseconds: 500),
                scale: 1,
                curve: Curves.ease,
                child: CircleAvatar(
                    maxRadius: widget.size.height > widget.size.width
                        ? widget.size.width / 14
                        : widget.size.width / 24,
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    child: Icon(!WordData.selecting
                        ? Icons.add
                        : Icons.delete_rounded)),
              )),
        ),
      ),
    );
  }
}
