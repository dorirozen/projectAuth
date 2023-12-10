import 'package:eduction_app/core/extensions/context_extensions.dart';
import 'package:eduction_app/core/resources/fonts.dart';
import 'package:eduction_app/src/on_boarding/domain/entites/content_page.dart';
import 'package:eduction_app/src/on_boarding/presention/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/colors.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, Key? key}) : super(key: key);
  final ContentPage pageContent;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          pageContent.image,
          height: context.height * .4,
        ),
        SizedBox(
          height: context.height * .03,
        ),
        Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
          child: Column(
            children: [
              Text(
                pageContent.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: Fonts.beautiful_people,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.height * .02),
              Text(
                pageContent.des,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(height: context.height * .05),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 17),
                  backgroundColor: MyColors.schemeColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.read<OnBoardingCubit>().cacheFirstTimer();
                },
                child: const Text(
                  'Get started',
                  style: TextStyle(
                      fontFamily: Fonts.agbalumo, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
