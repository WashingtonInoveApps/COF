import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/src/app_interface.dart';
import 'package:bsu_control/src/firebase_repository.dart';
import 'package:bsu_control/src/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDct_YQLCO4CME1hoesCp8wQojR-kDk-cE",
          appId: "1:126364231099:web:9b081f4c1e497e6d1f509e",
          messagingSenderId: "126364231099",
          projectId: "cof-bsu",
          storageBucket: "cof-bsu.appspot.com"),
    );
  } else {
    await Firebase.initializeApp();
  }

  final repository = FireRepository();
  GetIt.I.registerSingleton<IAppRepository>(repository);
  GetIt.I
      .registerSingleton<AppController>(AppController(repository: repository));

  setPathUrlStrategy();
  runApp(const AppWidget());
}

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final controller = GetIt.I.get<AppController>();

  late StreamSubscription carDispose;
  late StreamSubscription checklistDispose;
  late StreamSubscription usersDispose;
  late ReactionDisposer rec;

  @override
  void initState() {
    super.initState();
    rec = autorun((_) {
      if (controller.isLogged) {
        carDispose = controller.listenCar.listen((result) {
          controller.setCars(result);
        });

        checklistDispose = controller.listenChecklist.listen((result) {
          controller.setCheckList(result);
        });

        usersDispose = controller.listenUsers.listen((result) {
          controller.setUsers(result);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    carDispose.cancel();
    checklistDispose.cancel();
    usersDispose.cancel();
    rec.reaction.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COF - Controle Operacional de Frota',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('pt'),
      ],
      theme: ThemeData(
          colorScheme: const ColorScheme.light(primary: Colors.green),
          dividerTheme: DividerThemeData(
            color: Colors.grey.shade300,
          ),
          dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
          cardTheme: CardTheme(
              surfaceTintColor: Colors.white,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )),
          datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          )),
          primaryColor: Colors.green,
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: const Color.fromRGBO(251, 251, 251, 1)),
      home: const LoginPage(),
    );
  }
}
