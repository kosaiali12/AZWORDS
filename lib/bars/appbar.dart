// ignore_for_file: camel_case_types, avoid_types_as_parameter_names, non_constant_identifier_names, avoid_print

import 'package:azwords/Function/database.dart';
import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Widget/adding_meaning_section.dart';
import 'package:azwords/Widget/adding_word_section.dart';
import 'package:azwords/Widget/save_button.dart';
import 'package:azwords/Widget/search_button.dart';
import 'package:azwords/Widget/tips_widgget.dart';
import 'package:azwords/constant.dart';
import 'package:azwords/themebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App_Bar extends StatefulWidget {
  const App_Bar(
      {Key? key,
      required this.size,
      required this.searchFN,
      required this.words,
      required this.selected_words,
      required this.update})
      : super(key: key);
  final FocusNode searchFN;
  final Size size;
  final List<Word> words;
  final List<String> selected_words;
  final Function update;

  @override
  State<App_Bar> createState() => _App_BarState();
}

class _App_BarState extends State<App_Bar> with TickerProviderStateMixin {
  final MethodChannel platform = const MethodChannel('sendData');
  late AnimationController animationController;
  late Animation animation;
  late Duration animateduration;
  Future<void> fun() async {
    try {
      var b = await platform.invokeMethod('fun');
      print('result :' + b.toString());
    } catch (e) {
      print(e);
    }
  }

  late SharedPreferences sharedPreferences;
  late TextEditingController tce1;
  late TextEditingController tce2;
  late TextEditingController searchTC1;
  late FocusNode fn1;
  late FocusNode fn2;
  bool explinationBoxShowed = false;
  bool explinationDone = false;
  bool explinationContentShowed = false;
  bool first = false;
  bool second = false;
  bool showed = false;
  bool animate = true;
  String w = '';
  String m = '';
  @override
  void initState() {
    super.initState();
    loadData();
    animationController = AnimationController(vsync: this);
    // delete();

    tce1 = TextEditingController();
    tce2 = TextEditingController();
    searchTC1 = TextEditingController();
    fn1 = FocusNode();
    fn2 = FocusNode();
  }

  void delete() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('explinationDone');
    sharedPreferences.remove('explinationBoxShowed');
    sharedPreferences.remove('explinationContentShowed');
  }

  void loadData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool('explinationDone') != null) {
      explinationDone = sharedPreferences.getBool('explinationDone')!;
    }
    if (explinationBoxShowed =
        sharedPreferences.getBool('explinationBoxShowed') != null) {
      explinationBoxShowed = sharedPreferences.getBool('explinationBoxShowed')!;
    }
    if (sharedPreferences.getBool('explinationContentShowed') != null) {
      explinationContentShowed =
          sharedPreferences.getBool('explinationContentShowed')!;
    }
    if (sharedPreferences.getString('themeMode') == 'dark') {
      animation = Tween(begin: 0.0, end: 1.0).animate(animationController)
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {});
      Future.delayed(Duration(seconds: 3), () {
        animationController.forward();
      });
    }
    print(explinationBoxShowed.toString() +
        ' ' +
        explinationContentShowed.toString() +
        ' ' +
        explinationDone.toString());
    setState(() {});
  }

  DateTime timeBackpressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, WordData, chile) => GestureDetector(
        onTap: () {
          fn1.unfocus();
          fn2.unfocus();
          widget.searchFN.unfocus();
          setState(() {
            first = false;
            second = false;
          });
        },
        child: WillPopScope(
          onWillPop: () async {
            if (!WordData.adding) {
              WordData.setAdd(true);
              tce1.value = TextEditingValue.empty;
              tce2.value = TextEditingValue.empty;
              fn1.unfocus();
              setState(() {
                m = '';
                w = '';
                first = false;
                second = false;
              });
              return false;
            }

            // if (WordData.selecting) WordData.removeSelectedAll();
            if (WordData.barButtonSelected == 2) {
              WordData.setBarButton(1);
              return false;
            }
            final difference = DateTime.now().difference(timeBackpressed);
            final isExitWarning =
                difference >= const Duration(milliseconds: 2000);

            timeBackpressed = DateTime.now();

            if (isExitWarning) {
              Fluttertoast.showToast(
                  gravity: ToastGravity.SNACKBAR,
                  msg: 'Press back again to exit',
                  fontSize: 16,
                  textColor: kPimaryColor,
                  backgroundColor: Colors.white);
              return false;
            } else {
              Fluttertoast.cancel();
              return true;
            }
          },
          child: AnimatedContainer(
            height: WordData.adding
                ? widget.size.height > widget.size.width
                    ? WordData.barButtonSelected != 2
                        ? widget.size.height * 0.30
                        : 0
                    : widget.size.height * 0.60
                : widget.size.height * 0.90,
            width: widget.size.width,
            alignment: Alignment.topLeft,
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.elliptical(60, 60),
                bottomLeft: Radius.elliptical(60, 60),
              ),
            ),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 500),
              scale: 1,
              child: Stack(
                children: [
                  Positioned(
                    right: 25,
                    top: 25,
                    child: GestureDetector(
                      onTap: () async {
                        ThemeBuilder.of(context)!.changeTheme();
                        if (animationController.value == 1.0) {
                          animationController.reverse();
                        } else {
                          animationController.forward();
                        }
                      },
                      child: Lottie.asset(
                        'Assets/Animation/switch button.zip',
                        controller: animationController,
                        onLoaded: (composition) {
                          setState(() {
                            animateduration = composition.duration;
                          });
                          animationController..duration = composition.duration;
                        },
                        width: 120,

                        // fit: BoxFit.fill,
                        height: 80,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 100,
                    left: 40,
                    right: 0,
                    child: Text(
                      'A-Z Words',
                      style: TextStyle(
                        fontFamily: 'LuckiestGuy',
                        fontSize: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 140,
                    left: 40,
                    child: Text(
                      !WordData.selecting
                          ? '${widget.words.length} words'
                          : '${widget.selected_words.length} selected',
                      style: TextStyle(
                        fontWeight: !WordData.selecting
                            ? FontWeight.w300
                            : FontWeight.w800,
                        color: !WordData.selecting ? Colors.white : Colors.blue,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 25,
                    left: 30,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.list, color: kPimaryColor, size: 30),
                      maxRadius: 25,
                    ),
                  ),
                  Positioned(
                    top: 200,
                    left: 0,
                    right: 0,
                    child: AddingWordSection(
                        first: first,
                        second: second,
                        fn1: fn1,
                        tce1: tce1,
                        wordWriting: (value) {
                          w = value;
                        }),
                  ),
                  Positioned(
                      top: 280,
                      left: 0,
                      right: 0,
                      child: AddingMeaningSection(
                          load: loadData,
                          explinationBoxShowed: explinationBoxShowed,
                          explinationDone: explinationDone,
                          first: first,
                          second: second,
                          fn2: fn2,
                          tce2: tce2,
                          meaningwriting: (value) => m = value)),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SaveButton(
                      saveWord: () async {
                        if (!WordData.adding) {
                          if (w != '' && m != '') {
                            w = w.trim();
                            WordData.setAdd(true);
                            tce1.value = TextEditingValue.empty;
                            tce2.value = TextEditingValue.empty;
                            fn1.unfocus();
                            searchTC1.value = TextEditingValue.empty;
                            m = m.trim();

                            await Future.delayed(
                                const Duration(milliseconds: 400),
                                () => WordData.addWord(w, m, DateTime.now()));

                            await WordsDatabase.instance
                                .create(Word(w, m, DateTime.now(), false));
                            // widget.words.add(Word(w, m, DateTime.now(), false));
                            widget.update();
                            setState(() {});
                            await fun();
                            m = '';
                            w = '';
                          }
                        }
                      },
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: SearchBar(
                        size: widget.size,
                        update: widget.update,
                      )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: explinationBoxShowed &&
                            !WordData.adding &&
                            !explinationDone
                        ? Container(
                            height: widget.size.height,
                            width: widget.size.width,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.elliptical(60, 60),
                                bottomLeft: Radius.elliptical(60, 60),
                              ),
                            ),
                          )
                        : const Text(''),
                  ),
                  Positioned(
                      top: 280,
                      left: 0,
                      right: 0,
                      child: Tips(
                        explinationBoxShowed: explinationBoxShowed,
                        explinationDone: explinationDone,
                        explinationContentShowed: explinationContentShowed,
                        load: loadData,
                        size: widget.size,
                        fn2: fn2,
                        gotit: () {
                          showed = !showed;
                        },
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
