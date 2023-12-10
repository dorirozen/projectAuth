import 'package:flutter/material.dart';

class GradientBackGround extends StatelessWidget {
  const GradientBackGround({Key? key, required this.child, required this.image})
      : super(key: key);
  final Widget child;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Center(child: child),
      ),
    );
  }
}
