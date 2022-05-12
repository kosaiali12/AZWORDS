// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/wordscreen.dart';
import 'package:azwords/themebuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordSection extends StatefulWidget {
  const WordSection(
      {Key? key,
      required this.word,
      required this.meaning,
      required this.index,
      required this.date,
      required this.fav,
      required this.selected_words,
      required this.update})
      : super(key: key);
  final String word;
  final String meaning;
  final int index;
  final DateTime date;
  final bool fav;
  final List<String> selected_words;
  final Function update;
  @override
  State<WordSection> createState() => _WordSectionState();
}

class _WordSectionState extends State<WordSection> {
  bool init = false;
  bool selected = false;
  @override
  void initState() {
    Future.delayed(
        const Duration(milliseconds: 50),
        () => setState(() {
              init = true;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<WordData>(
      builder: (context, WordData, child) => AnimatedScale(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCirc,
        scale: init ? 1 : 0,
        child: GestureDetector(
          onTap: () {
            if (WordData.selecting) {
              setState(() {
                selected = !selected;
              });
            } else {
              showModalBottomSheet(
                backgroundColor: const Color(0x00737373),
                context: context,
                builder: (context) => Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35))),
                  child: WordScreen(
                      update: widget.update,
                      word: Word(
                          widget.word, widget.meaning, widget.date, widget.fav),
                      wordindex: widget.index),
                ),
              );
            }
            if (selected) {
              widget.selected_words.add(widget.word);
              print(widget.selected_words);
              widget.update();
              // WordData.addSelected(
              //     Word(widget.word, widget.meaning, widget.date));
              // WordData.setselecting(true);
            }
            if (!selected) {
              // WordData.removeselected(
              // Word(widget.word, widget.meaning, widget.date));
              widget.selected_words.remove(widget.word);
              if (widget.selected_words.isEmpty) WordData.setselecting(false);
              widget.update();
            }
          },
          onLongPress: () {
            if (!WordData.selecting) {
              WordData.setselecting(true);
              widget.selected_words.add(widget.word);
              setState(() {
                selected = true;
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 100,
            margin: EdgeInsets.fromLTRB(
              widget.selected_words.contains(widget.word) ? 40 : 30,
              10,
              WordData.hasSelected(Word(
                      widget.word, widget.meaning, widget.date, widget.fav))
                  ? 40
                  : 30,
              10,
            ),
            decoration: BoxDecoration(
              color: widget.selected_words.contains(widget.word)
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                ThemeBuilder.of(context)?.themeMode == ThemeMode.light
                    ? const BoxShadow(
                        color: Color(0xFF132C33),
                        blurRadius: 10,
                        blurStyle: BlurStyle.outer,
                      )
                    : const BoxShadow(
                        color: Color(0xFF132C33),
                        blurRadius: 0,
                        blurStyle: BlurStyle.outer,
                      ),
                ThemeBuilder.of(context)?.themeMode == ThemeMode.light
                    ? const BoxShadow(
                        color: Colors.white,
                        blurRadius: 20,
                        blurStyle: BlurStyle.outer,
                      )
                    : const BoxShadow(
                        color: Color.fromARGB(255, 10, 52, 59),
                        blurRadius: 0,
                        blurStyle: BlurStyle.outer,
                      ),
                ThemeBuilder.of(context)?.themeMode == ThemeMode.light
                    ? const BoxShadow(
                        color: Colors.white,
                        blurRadius: 20,
                        blurStyle: BlurStyle.outer,
                      )
                    : const BoxShadow(
                        color: Color.fromARGB(255, 10, 52, 59),
                        blurRadius: 0,
                        spreadRadius: 0,
                        blurStyle: BlurStyle.outer,
                      ),
                ThemeBuilder.of(context)?.themeMode == ThemeMode.light
                    ? const BoxShadow(
                        color: Colors.white,
                        blurRadius: 10,
                        blurStyle: BlurStyle.outer,
                      )
                    : const BoxShadow(
                        color: Color.fromARGB(255, 10, 52, 59),
                        blurRadius: 0,
                        spreadRadius: 0,
                        blurStyle: BlurStyle.outer,
                      ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 20,
                  child: widget.fav
                      ? Container(
                          height: 35,
                          width: 30,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            color: Colors.blue,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 22,
                          ),
                        )
                      : const Text(''),
                ),
                Positioned(
                  top: 10,
                  left: 15,
                  child: Row(
                    children: [
                      Text(
                        widget.word,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 16,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
                const Positioned(
                  top: 40,
                  left: 20,
                  child: Text(
                    'Meaning: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  child: SizedBox(
                      width: size.width - 20,
                      height: 20,
                      child: Text(widget.meaning)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
