import 'package:eduction_app/core/common/views/page_un_implemented.dart';
import 'package:eduction_app/core/common/widgets/gradient_background.dart';
import 'package:eduction_app/core/resources/media_res.dart';
import 'package:eduction_app/src/on_boarding/presention/cubit/on_boarding_cubit.dart';
import 'package:eduction_app/src/on_boarding/presention/cubit/on_boarding_cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/views/loading_page.dart';
import '../../domain/entites/content_page.dart';
import '../widgets/on_boarding_body.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();
  @override
  void initState() {
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserFirstTimer();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GradientBackGround(
        image: MediaRes.image2,
        child: BlocConsumer<OnBoardingCubit, OnBoardingCubitState>(
          listener: (context, state) {
            if (state is OnBoardingStatusState && !state.isFirstTimer) {
              Navigator.pushReplacementNamed(context, '/home');
            }
            if (state is UserCachedState) {
              // TODO: push to the appropriate screen
              // if the user was signed in , we will need to check he was a admin or user !
              Navigator.pushReplacementNamed(context, '/');
            }
          },
          builder: (context, state) {
            if (state is CheckingIfUserIsFirstTimerState ||
                state is CachingFirstTimerState) {
              return const LoadingView();
            }
            return Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: const [
                    OnBoardingBody(pageContent: ContentPage.first()),
                    OnBoardingBody(pageContent: ContentPage.second()),
                    OnBoardingBody(pageContent: ContentPage.third()),
                  ],
                ),
                Align(
                  alignment: const Alignment(0, -.14),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    axisDirection: Axis.horizontal,
                    onDotClicked: (index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 40,
                      activeDotColor: Colors.purpleAccent,
                      dotColor: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
