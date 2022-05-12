// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names, must_be_immutable

import 'package:azwords/Function/worddata.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: const Color(0xFF132C33),
      height: 60,
      width: size.width,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, 60),
            painter: size.width < size.height
                ? CPainter(c: Theme.of(context).backgroundColor)
                : CPainter2(c: Theme.of(context).backgroundColor),
          )
        ],
      ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, WordData, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => WordData.setBarButton(1),
            child: Column(
              children: [
                ButtonIcon(
                  image: 'Assets/Images/home.png',
                  index: 1,
                ),
                const SizedBox(
                  height: 3,
                ),
                SelectedbarButton(index: 1),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              WordData.setBarButton(2);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonIcon(image: 'Assets/Images/test.png', index: 2),
                const SizedBox(
                  height: 3,
                ),
                SelectedbarButton(
                  index: 2,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonIcon extends StatelessWidget {
  ButtonIcon({Key? key, required this.image, required this.index})
      : super(key: key);
  String image;
  int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, WordData, child) => AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: WordData.barButtonSelected == index ? 1 : 0.9,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Image.asset(image, color: Colors.white),
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}

class SelectedbarButton extends StatelessWidget {
  SelectedbarButton({Key? key, required this.index}) : super(key: key);
  int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<WordData>(
      builder: (context, WordData, child) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: WordData.barButtonSelected == index ? 15 : 3,
        height: 3,
        decoration: BoxDecoration(
          color:
              WordData.barButtonSelected == index ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(35),
        ),
      ),
    );
  }
}

class CPainter extends CustomPainter {
  CPainter({required this.c});
  final Color c;

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
    super.addListener(listener);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = c
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(40, 50);

    path.quadraticBezierTo(40, 20, 70, 20);
    path.lineTo(size.width * 0.35, 20);
    path.quadraticBezierTo(size.width * 0.419, 20, size.width * 0.419, 35);
    path.quadraticBezierTo(size.width * 0.425, 65, size.width * 0.50, 67);
    path.quadraticBezierTo(size.width * 0.575, 65, size.width * 0.581, 35);
    path.quadraticBezierTo(size.width * 0.581, 20, size.width * 0.64, 20);

    path.lineTo(size.width - 70, 20);
    path.quadraticBezierTo(size.width - 40, 20, size.width - 40, 50);
    path.quadraticBezierTo(size.width - 40, 80, size.width - 70, 80);
    path.lineTo(size.width, 80);
    path.lineTo(70, 80);
    path.quadraticBezierTo(40, 80, 40, 50);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CPainter2 extends CustomPainter {
  CPainter2({required this.c});
  final Color c;

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
    super.addListener(listener);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = c
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(40, 50);

    path.quadraticBezierTo(40, 20, 70, 20);
    path.lineTo(size.width * 0.38, 20);
    path.quadraticBezierTo(size.width * 0.449, 20, size.width * 0.449, 35);
    path.quadraticBezierTo(size.width * 0.455, 65, size.width * 0.50, 67);
    path.quadraticBezierTo(size.width * 0.545, 65, size.width * 0.551, 35);
    path.quadraticBezierTo(size.width * 0.551, 20, size.width * 0.61, 20);

    path.lineTo(size.width - 70, 20);
    path.quadraticBezierTo(size.width - 40, 20, size.width - 40, 50);
    path.quadraticBezierTo(size.width - 40, 80, size.width - 70, 80);
    path.lineTo(size.width, 80);
    path.lineTo(70, 80);
    path.quadraticBezierTo(40, 80, 40, 50);
    path.close();
    canvas.drawPath(path, paint);
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


//  } else {
      