// ignore_for_file: must_be_immutable, avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:audioplayers/audioplayers.dart';
import 'package:azwords/Function/database.dart';
import 'package:azwords/Function/word.dart';
import 'package:azwords/Function/worddata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class WordScreen extends StatefulWidget {
  WordScreen(
      {Key? key,
      required this.word,
      required this.wordindex,
      required this.update})
      : super(key: key);

  Word word;
  int wordindex;
  Function update;
  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  List<String> meaning = [];

  late AudioPlayer audioPlayer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = AudioPlayer();
    meaning = widget.word.meaning.split(' ');
  }

  void play() async {
    var url =
        'https://api.dictionaryapi.dev/media/pronunciations/en/${widget.word.word}-us.mp3';
    print(url);
    int result = await audioPlayer.play(url);
    print(result);
    if (result == 1) {
      // success
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<WordData>(builder: (context, WordData, child) {
      widget.wordindex = WordData.isFav2(widget.word);

      return Stack(
        children: [
          // const Positioned(
          //   top: 20,
          //   left: 20,
          //   child: Card(
          //     shadowColor: Colors.grey,
          //     elevation: 3,
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(10))),
          //     child: Padding(
          //       padding: EdgeInsets.all(10),
          //       child: Icon(Icons.arrow_back_sharp),
          //     ),
          //   ),
          // ),
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                widget.word = Word(widget.word.word, widget.word.meaning,
                    widget.word.date, !widget.word.fav);
                WordsDatabase.instance.updateFav(widget.word);
                widget.update();
                setState(() {});
              },
              child: Card(
                shadowColor: Colors.grey,
                elevation: 3,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: AnimatedScale(
                    scale: widget.word.fav ? 1.1 : 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutBack,
                    child: Icon(
                        widget.word.fav
                            ? Icons.favorite
                            : Icons.favorite_border_sharp,
                        color: widget.word.fav ? Colors.blue : Colors.black),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.045,
            left: size.width * 0.10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.word.word,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 28,
                      fontFamily: 'LuckiestGuy',
                      letterSpacing: 0.5),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    play();
                  },
                  child: Icon(
                    Icons.volume_up_rounded,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.09,
            left: size.width * 0.10,
            child: Text(
              'Time added: ${DateFormat('EEE dd-MM-yyyy,').add_jm().format(widget.word.date)}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Positioned(
            left: size.width * 0.10,
            top: size.height * 0.14,
            child: const Text(
              'Meanings :',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
              top: size.height * 0.17,
              left: 0,
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: ListView.builder(
                  itemCount: meaning.length,
                  padding: EdgeInsets.only(left: size.width * 0.10),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${index + 1}-${meaning[index]}'),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ))
        ],
      );
    });
  }
}
