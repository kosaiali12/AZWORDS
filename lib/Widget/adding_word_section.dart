// ignore_for_file: must_be_immutable, avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:azwords/Function/worddata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddingWordSection extends StatefulWidget {
  AddingWordSection({
    Key? key,
    required this.first,
    required this.second,
    required this.fn1,
    required this.tce1,
    required this.wordWriting,
  }) : super(key: key);

  bool first;
  bool second;
  TextEditingController tce1;
  FocusNode fn1;
  Function wordWriting;
  @override
  State<AddingWordSection> createState() => _AddingWordSectionState();
}

class _AddingWordSectionState extends State<AddingWordSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, WordData, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: AnimatedOpacity(
          opacity: WordData.adding ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: TextField(
            enabled: !WordData.adding,
            onSubmitted: (value) {
              setState(() {
                widget.first = false;
                widget.second = false;
              });
            },
            controller: widget.tce1,
            focusNode: widget.fn1,
            onTap: () {
              setState(() {
                widget.first = true;
                widget.second = false;
              });
            },
            onChanged: (value) => widget.wordWriting(value),
            cursorHeight: 20,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              labelText: 'Write your word',
              labelStyle: TextStyle(
                  color: widget.first ? Colors.blue : Colors.white,
                  fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 22, 151, 202),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
