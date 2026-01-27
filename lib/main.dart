import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  GetIt.I.registerSingleton<AppController>(
      AppController(appID: 'VBJM7eAETNS2pYWpfKLY', endpoint: '', test: true));

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
      ],
      supportedLocales: const [
        Locale('pt'),
      ],
      theme: ThemeData(
          // scaffoldBackgroundColor: Core.primary,
          primaryColor: Colors.green.shade800,
          dialogTheme: DialogThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          popupMenuTheme: const PopupMenuThemeData(
              shadowColor: Colors.white,
              color: Colors.white,
              surfaceTintColor: Colors.transparent),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40))),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: Core.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
          ),
          bottomSheetTheme: BottomSheetThemeData(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          checkboxTheme: CheckboxThemeData(
            fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.black;
              }
              return Colors.white;
            }),
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          primarySwatch: Colors.grey,
          cardColor: Colors.white),
      home: const LoginPage(),
    );
  }
}
