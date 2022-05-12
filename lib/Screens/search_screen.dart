import 'package:azwords/Function/database.dart';
import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/wordscreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Widget/wordsection.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.update}) : super(key: key);
  final Function update;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late FocusNode searchFN;
  String searchingword = '';
  List<Word> searchedWords = [];
  Future refresWords() async {
    this.searchedWords = await WordsDatabase.instance.search(searchingword);
    print(searchedWords);
    setState(() {});
  }

  @override
  void initState() {
    searchFN = FocusNode();
    searchFN.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, WordData, child) => SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    RawMaterialButton(
                      constraints:
                          const BoxConstraints(minHeight: 40, minWidth: 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, size: 28),
                    ),
                    Expanded(
                      flex: 6,
                      child: TextField(
                        onChanged: ((value) async {
                          setState(() {
                            value = value.trim();
                            searchingword = value;
                          });
                          print(searchingword);
                          if (searchingword != '')
                            searchedWords = await WordsDatabase.instance
                                .search(searchingword);
                          else
                            searchedWords = [];

                          setState(() {});
                        }),
                        focusNode: searchFN,
                        cursorHeight: 24,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          hintText: 'Write the word',
                          contentPadding: EdgeInsets.only(bottom: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    searchFN.unfocus();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: searchedWords.isNotEmpty
                        ? ListView.builder(
                            itemCount: searchedWords.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return RawMaterialButton(
                                splashColor: Colors.blue,
                                constraints: BoxConstraints(minHeight: 60),
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'do you want to delete this word',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      actions: [
                                        RawMaterialButton(
                                          onPressed: () {
                                            // WordData.addSelected(Word(
                                            //     searchedWords[index].word,
                                            //     searchedWords[index].meaning,
                                            //     searchedWords[index].date,
                                            //     searchedWords[index].fav));
                                            // WordData.delete();
                                            // searchedWords.removeAt(index);
                                            WordsDatabase.instance.deletWord(
                                                searchedWords[index].word);
                                            refresWords();
                                            widget.update();
                                            Navigator.pop(context);
                                          },
                                          child: Text('yes'),
                                        ),
                                        RawMaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('no'),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                onPressed: () {
                                  searchFN.unfocus();
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
                                          update: () async {
                                            widget.update();
                                            refresWords();
                                          },
                                          word: Word(
                                              searchedWords[index].word,
                                              searchedWords[index].meaning,
                                              DateTime.now(),
                                              searchedWords[index].fav),
                                          wordindex: index),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            searchedWords[index].word,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            searchedWords[index].meaning[0],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (searchedWords[index].fav)
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.blue,
                                          size: 22,
                                        )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : searchingword != ''
                            ? Text('Word was not found')
                            : Text(''),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
