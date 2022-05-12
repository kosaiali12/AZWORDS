// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:azwords/Function/worddata.dart';
import 'package:azwords/Screens/search_screen.dart';
import 'package:azwords/animation.dart';
import 'package:azwords/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, required this.size, required this.update})
      : super(key: key);
  final Function update;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, WordData, child) => AnimatedScale(
        duration: const Duration(milliseconds: 50),
        scale: WordData.adding ? 1 : 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Container(
            height: 50,
            width: size.width - 120,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(35),
              ),
            ),
            child: RawMaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    FadeNavigator(
                        page: SearchScreen(
                      update: update,
                    )));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Search',
                      style: TextStyle(
                          color: kPimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      Icons.search,
                      color: kPimaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
