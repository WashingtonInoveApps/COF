import 'dart:async';
import 'dart:ui';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:get_it/get_it.dart';
import 'package:url_strategy/url_strategy.dart';

import 'login/view/login_page.dart';

final config = ConfigModel(
  appID: 'VBJM7eAETNS2pYWpfKLY',
  endpoint: 'https://us-central1-bsucos-function.cloudfunctions.net/app',
  test: false,
  maxWidth: 1000,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDPR6CYiWi1Yz3lTYB8KZ5Brlrh11eIzNQ",
            authDomain: "bsucos-function.firebaseapp.com",
            projectId: "bsucos-function",
            storageBucket: "bsucos-function.firebasestorage.app",
            messagingSenderId: "1031414772745",
            appId: "1:1031414772745:web:0070586726a9b01f9174d8",
            measurementId: "G-7HW3692G62"));
  } else {
    await Firebase.initializeApp();
  }

  final controller = AppController(config: config);

  GetIt.I.registerSingleton<AppController>(controller);
  await controller.initApplication();

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

  StreamSubscription? carDispose;
  StreamSubscription? checklistTodayDispose;
  StreamSubscription? usersDispose;

  @override
  void initState() {
    super.initState();

    carDispose = controller.listenCar.listen((result) {
      controller.setCars(result);
    });

    checklistTodayDispose = controller.listenChecklistToday().listen((result) {
      controller.setChecklistToday(result);
    });

    usersDispose = controller.listenUsers.listen((result) {
      controller.setUsers(result);
    });
  }

  @override
  void dispose() {
    super.dispose();

    carDispose?.cancel();
    usersDispose?.cancel();
    checklistTodayDispose?.cancel();
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
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad
        },
      ),
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color.fromARGB(255, 27, 94, 32),
          colorScheme: ColorScheme.fromSeed(seedColor: Constants.primary),
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
                backgroundColor: Constants.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
          ),
          menuTheme: MenuThemeData(
              style: MenuStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
          )),
          menuButtonTheme: MenuButtonThemeData(
              style: MenuItemButton.styleFrom(
                  // maximumSize: Size(config.maxWidth, double.infinity),
                  backgroundColor: Colors.white,
                  side: BorderSide.none)),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5)),
            ),
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
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: Constants.primary),
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
