// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';

class FadeNavigator extends PageRouteBuilder {
  final page;
  FadeNavigator({this.page})
      : super(
            pageBuilder: (context, animation, animationtwo) => page,
            transitionsBuilder: (context, animation, animationtwo, child) {
              var begin = 0.0;
              var end = 1.0;
              var tween = Tween(begin: begin, end: end);

              var offsetanimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.ease,
                  reverseCurve: Curves.easeOut);

              return FadeTransition(
                opacity: tween.animate(offsetanimation),
                child: child,
              );
            });
}
