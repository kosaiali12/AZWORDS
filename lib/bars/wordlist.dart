// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Widget/wordsection.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../themebuilder.dart';

class WordList extends StatefulWidget {
  const WordList(
      {Key? key,
      required this.scroller,
      required this.words,
      required this.selected_words,
      required this.update,
      required this.loaded})
      : super(key: key);
  final Function update;
  final ScrollController scroller;
  final List<Word> words;
  final List<String> selected_words;
  final bool loaded;

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  bool animate = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<WordData>(
      builder: (context, WordData, child) {
        if (widget.loaded) {
          if (widget.words.isEmpty && WordData.adding) {
            if (size.height > size.width) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage(
                      'Assets/Images/NO_WORDS.png',
                    ),
                    color: Theme.of(context).primaryColor,
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'NO WORDS\n Try to add some',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Icon(
                    Icons.arrow_downward_sharp,
                    size: 30,
                  )
                ],
              );
            }
          } else {
            return ListView.builder(
              controller: widget.scroller,
              itemCount: WordData.selected != 4
                  ? widget.words.length
                  : WordData.sorFavourite(widget.words).length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    if (WordData.selected == 1)
                      Expanded(
                        child: WordSection(
                          update: widget.update,
                          index: index,
                          word: widget.words[index].word,
                          meaning: widget.words[index].meaning,
                          date: widget.words[index].date,
                          fav: widget.words[index].fav,
                          selected_words: widget.selected_words,
                        ),
                      )
                    else if (WordData.selected == 2)
                      Expanded(
                        child: WordSection(
                          update: widget.update,
                          index: index,
                          word: WordData.sortAtoZ(widget.words)[index].word,
                          meaning:
                              WordData.sortAtoZ(widget.words)[index].meaning,
                          date: WordData.sortAtoZ(widget.words)[index].date,
                          fav: WordData.sortAtoZ(widget.words)[index].fav,
                          selected_words: widget.selected_words,
                        ),
                      )
                    else if (WordData.selected == 3)
                      Expanded(
                        child: WordSection(
                          update: widget.update,
                          index: index,
                          word: WordData.sortZtoA(widget.words)[index].word,
                          meaning:
                              WordData.sortZtoA(widget.words)[index].meaning,
                          date: WordData.sortZtoA(widget.words)[index].date,
                          fav: WordData.sortZtoA(widget.words)[index].fav,
                          selected_words: widget.selected_words,
                        ),
                      )
                    else if (WordData.selected == 4 &&
                        WordData.sorFavourite(widget.words).isNotEmpty)
                      Expanded(
                        child: WordSection(
                          update: widget.update,
                          index: index,
                          word: WordData.sorFavourite(widget.words)[index].word,
                          meaning: WordData.sorFavourite(widget.words)[index]
                              .meaning,
                          date: WordData.sorFavourite(widget.words)[index].date,
                          fav: WordData.sorFavourite(widget.words)[index].fav,
                          selected_words: widget.selected_words,
                        ),
                      ),
                  ],
                );
              },
            );
          }
        }
        return Text('');
      },
    );
  }
}
