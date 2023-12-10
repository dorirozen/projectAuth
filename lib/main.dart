import 'package:eduction_app/core/common/app/providers/user_provider.dart';
import 'package:eduction_app/core/resources/colors.dart';
import 'package:eduction_app/core/resources/fonts.dart';
import 'package:eduction_app/core/services/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/services/injection_container.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // because we wait for future in the main we need to make sure that
  // all binding initialized , with "WidgetsFlutterBinding.ensureInitialized();"
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            fontFamily: Fonts.agbalumo,
            useMaterial3: true,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme:
                ColorScheme.fromSwatch(accentColor: MyColors.schemeColor),
            appBarTheme: const AppBarTheme(color: Colors.transparent)),
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
