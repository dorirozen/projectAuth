import 'package:eduction_app/core/extensions/context_extensions.dart';
import 'package:eduction_app/core/resources/media_res.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            context.theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

/*
import 'package:eduction_app/core/resources/media_res.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              MediaRes.image2,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(child: Lottie.asset(MediaRes.animationLottie1)),
        ),
      ),
    );
  }
}

 */
