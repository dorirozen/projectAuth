import 'package:eduction_app/core/common/app/providers/user_provider.dart';
import 'package:eduction_app/core/extensions/context_extensions.dart';
import 'package:eduction_app/src/auth/data/models/user_model.dart';
import 'package:eduction_app/src/auth/presention/views/sign_in_screen.dart';
import 'package:eduction_app/src/auth/presention/views/sign_up_screen.dart';
import 'package:eduction_app/src/dashboard/presention/views/dashboard.dart';
import 'package:eduction_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../src/auth/presention/bloc/auth_bloc.dart';
import '../../src/on_boarding/presention/cubit/on_boarding_cubit.dart';
import '../../src/on_boarding/presention/screens/on_boarding_screen.dart';
import '../common/views/page_un_implemented.dart';
import 'injection_container.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final pref = sl<SharedPreferences>();
      return _pageBuilder(
        (context) {
          if (pref.getBool(kFirstTimerKey) ?? true) {
            return BlocProvider(
              create: (_) => sl<OnBoardingCubit>(),
              child: const OnBoardingScreen(),
            );
          } else if (sl<FirebaseAuth>().currentUser != null) {
            // pushing the user into the dashboard and we need his info
            final user = sl<FirebaseAuth>().currentUser!;
            final localUser = LocalUserModel(
                // טעות לדעתי זה אמור להיות רגיל
                uid: user.uid,
                email: user.email ?? '',
                points: 0,
                fullName: user.displayName ?? '');
            context.userProvider.initUser(localUser);
            return const DashBoardScreen(t: 'else if ');
          }
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const SignInScreen(),
          );
        },
        settings: settings,
      );

    case SignInScreen.routeName:
      return _pageBuilder(
          (_) => BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const SignInScreen(),
              ),
          settings: settings);
    case SignUpScreen.routeName:
      return _pageBuilder(
          (_) => BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const SignUpScreen(),
              ),
          settings: settings);
    case DashBoardScreen.routeName:
      return _pageBuilder((_) => const DashBoardScreen(t: ''),
          settings: settings);

    case PageUnImplemented.routeName:
      return _pageBuilder(
        (_) => const PageUnImplemented(),
        settings: settings,
      );
    //normal approach
    /*
    case "OnBoardingScreen.routeName":
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<OnBoardingCubit>(),
          child: const OnBoardingScreen(),
        ),
      );
     */
    default:
      return _pageBuilder(
        (_) => const PageUnImplemented(txt: 'Default Page'),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
    Widget Function(BuildContext context) page,
    {required RouteSettings settings}) {
  return PageRouteBuilder(
      settings: settings,
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
      pageBuilder: (context, _, __) => page(context));
}
