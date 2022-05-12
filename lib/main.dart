// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, prefer_const_constructors_in_immutables, avoid_print

import 'package:azwords/Function/database.dart';
import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Widget/buttons.dart';
import 'package:azwords/Widget/sorting_type.dart';
import 'package:azwords/bars/appbar.dart';
import 'package:azwords/bars/bottombar.dart';

import 'package:azwords/bars/wordlist.dart';
import 'package:azwords/theme.dart';
import 'package:azwords/themebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => WordData(), child: const Main()),
  );
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, _thememode) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        themeMode: _thememode,
        home: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController scroller = ScrollController();
  bool isScrolling = false;
  late FocusNode searchFN;
  List<Word> words = [];
  List<String> selected_words = [];
  bool loaded = false;
  Future refresWords() async {
    this.words = await WordsDatabase.instance.readAllWords();
    if (words.length <= 4) isScrolling = false;
    print(words);
    if (!loaded) {
      await Future.delayed(Duration(seconds: 5), () => loaded = true);
    }
    setState(() {});
  }

  @override
  void initState() {
    refresWords();
    searchFN = FocusNode();

    scroller.addListener(() {
      setState(() {
        isScrolling = scroller.offset > 0;
      });
      print('is Scrolling :' + isScrolling.toString());
    });
    super.initState();
  }

  bool Adding = false;
  @override
  Widget build(BuildContext context) {
    // refresWords();
    final Size size = MediaQuery.of(context).size;
    return Consumer<WordData>(
      builder: (context, WordData, child) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GestureDetector(
            onTap: () {
              searchFN.unfocus();
            },
            child: Stack(
              children: [
                Background(size: size),
                Column(
                  children: [
                    App_Bar(
                      update: refresWords,
                      selected_words: selected_words,
                      words: words,
                      searchFN: searchFN,
                      size: size,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isScrolling || words.isEmpty ? 0 : 50,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: words.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedScale(
                                    duration: const Duration(milliseconds: 200),
                                    scale: isScrolling ||
                                            !WordData.adding ||
                                            WordData.barButtonSelected != 1
                                        ? 0
                                        : 1,
                                    child: const SortType(
                                      image: '',
                                      index: 1,
                                      text: 'normal',
                                    ),
                                  ),
                                  AnimatedScale(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      scale: isScrolling ||
                                              !WordData.adding ||
                                              WordData.barButtonSelected != 1
                                          ? 0
                                          : 1,
                                      child: const SortType(
                                          image: '', text: 'a-z', index: 2)),
                                  AnimatedScale(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      scale: isScrolling ||
                                              !WordData.adding ||
                                              WordData.barButtonSelected != 1
                                          ? 0
                                          : 1,
                                      child: const SortType(
                                          image: '', text: 'z-a', index: 3)),
                                  AnimatedScale(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      scale: isScrolling ||
                                              !WordData.adding ||
                                              WordData.barButtonSelected != 1
                                          ? 0
                                          : 1,
                                      child: const SortType(
                                          image: 'heart',
                                          text: ' favourite',
                                          index: 4))
                                ],
                              )
                            : null,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: WordData.barButtonSelected == 1
                          ? WordList(
                              update: refresWords,
                              words: words,
                              selected_words: selected_words,
                              scroller: scroller,
                              loaded: loaded,
                            )
                          : Container(),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    AnimatedPositioned(
                      curve: Curves.easeInOutBack,
                      duration: const Duration(milliseconds: 400),
                      bottom: !isScrolling && WordData.adding ? 35 : -90,
                      left: 0,
                      child: BottomBar(size: size),
                    ),
                    AnimatedPositioned(
                      curve: Curves.easeInOutBack,
                      duration: const Duration(milliseconds: 400),
                      bottom: !isScrolling && WordData.adding ? 27 : -90,
                      left: 45,
                      right: 45,
                      child: const BottomBarButton(),
                    ),
                    Add_Button(
                      words: words,
                      scrollController: scroller,
                      selected_words: selected_words,
                      isScrolling: isScrolling,
                      size: size,
                      delete_words: refresWords,
                    ),
                    Positioned(
                      bottom: (size.width / 14) * 2.7,
                      right: size.width / 14,
                      child: Up_Button(
                        isScrolling: isScrolling,
                        scrollController: scroller,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // child: Column(
          //   children: [
          //     App_Bar(size: size),
          //   ],
          // ),
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: const AssetImage('Assets/Images/background.jpg'),
            opacity: 0.1,
            fit: size.width < size.height ? BoxFit.fill : BoxFit.fitWidth),
      ),
    );
  }
}

class AddPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 22, 151, 202)
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(20, 40);
    path.quadraticBezierTo(20, 0, 60, 0);
    path.lineTo(size.width - 60, 0);
    path.quadraticBezierTo(size.width - 20, 0, size.width - 20, 40);
    path.lineTo(size.width - 20, 430);
    path.quadraticBezierTo(size.width - 20, 470, size.width - 60, 470);
    path.lineTo(size.width * 0.64, 470); //57
    path.quadraticBezierTo(size.width * 0.57, 470, size.width * 0.57, 490);
    path.quadraticBezierTo(size.width * 0.57, 515, size.width * 0.50, 518.4);
    path.quadraticBezierTo(size.width * 0.43, 515, size.width * 0.43, 490);
    path.quadraticBezierTo(size.width * 0.43, 470, size.width * 0.35, 470);
    path.lineTo(60, 470);
    path.quadraticBezierTo(20, 470, 20, 430);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
