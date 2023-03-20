import 'package:flutter/material.dart';

class CatWidget extends StatelessWidget {
  const CatWidget(
      {super.key,
      required this.catName,
      required this.leftTileNumber,
      required this.rightTileNumber,
      required this.width,
      required this.height});

  final String catName;
  final int leftTileNumber;
  final int rightTileNumber;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var tileTop = height * 0.53;
    var tileWidth = width * 0.38;
    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              width: width,
              "assets/images/${catName.toLowerCase()}.png",
            ),
            Positioned(
                top: tileTop,
                left: width * 0.11,
                width: tileWidth,
                child: Image.asset(
                  "assets/images/tile$leftTileNumber.png",
                )),
            Positioned(
                top: tileTop,
                left: width * 0.51,
                width: tileWidth,
                child: Image.asset(
                  "assets/images/tile$rightTileNumber.png",
                ))
          ],
        )
      // body: Column(
      //     children: [
      //   Image.asset(
      //     width: size.width,
      //     "assets/images/orig/${catName.toLowerCase()}.png",
      //   ),
      //   FractionalTranslation(
      //       translation: const Offset(0, -0.3),
      //       child: Row(
      //         children: [
      //           const Spacer(flex: 40),
      //           Expanded(
      //               flex: 113,
      //               child: Image.asset(
      //                 "assets/images/tile$leftTileNumber.png",
      //               )),
      //           const Spacer(flex: 15),
      //           Expanded(
      //               flex: 113,
      //               child: Image.asset(
      //                 "assets/images/tile$rightTileNumber.png",
      //               )),
      //           const Spacer(flex: 40)
      //         ],
      //       ))
      // ]),
    );
  }
}
