// ignore_for_file: must_be_immutable, avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:azwords/Function/worddata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddingMeaningSection extends StatefulWidget {
  AddingMeaningSection(
      {Key? key,
      required this.first,
      required this.second,
      required this.fn2,
      required this.tce2,
      required this.meaningwriting,
      required this.explinationBoxShowed,
      required this.explinationDone,
      required this.load})
      : super(key: key);

  bool first;
  bool second;
  TextEditingController tce2;
  FocusNode fn2;
  Function meaningwriting;
  Function load;
  final bool explinationBoxShowed;
  final bool explinationDone;
  @override
  State<AddingMeaningSection> createState() => _AddingMeaningSectionState();
}

class _AddingMeaningSectionState extends State<AddingMeaningSection> {
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

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
            onChanged: (value) {
              widget.meaningwriting(value);
            },
            focusNode: widget.fn2,
            cursorHeight: 20,
            onTap: () async {
              if (!widget.explinationDone) {
                widget.fn2.unfocus();
                sharedPreferences.setBool('explinationBoxShowed', true);
                widget.load();
                // WordData.setShowed(true);
                await Future.delayed(
                    const Duration(milliseconds: 250),
                    () => sharedPreferences.setBool(
                        'explinationContentShowed', true));
                widget.load();
              }
              setState(() {
                widget.first = false;
                widget.second = true;
              });
            },
            controller: widget.tce2,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Write the meaning',
              labelStyle: TextStyle(
                  color: widget.second ? Colors.blue : Colors.white,
                  fontSize: 14),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
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
