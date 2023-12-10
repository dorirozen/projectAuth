import 'package:eduction_app/core/resources/media_res.dart';
import 'package:flutter/material.dart';

import '../widgets/gradient_background.dart';

class PageUnImplemented extends StatelessWidget {
  const PageUnImplemented({Key? key, this.txt}) : super(key: key);
  final String? txt;
  static const routeName = 'problem';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackGround(
        image: MediaRes.image1,
        child: Center(
          child: _buildStack(''),
        ),
      ),
    );
  }
}

_buildStack(String? txt) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Image.asset(MediaRes.vector3, width: 300, height: 300),
      Positioned(
        bottom: 156, // Adjust the position as needed
        child: Text(
          txt == '' ? 'Page Not Implemented Yet' : '$txt Not Implemented Yet',
          style: const TextStyle(
            color: Colors.white, // Set the text color
            fontSize: 12, // Set the font size
            fontWeight: FontWeight.bold, // Set the font weight
          ),
        ),
      ),
    ],
  );
}
