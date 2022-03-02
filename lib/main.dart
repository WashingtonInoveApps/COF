import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/src/app_interface.dart';
import 'package:bsu_control/src/firebase_repository.dart';
import 'package:bsu_control/src/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  final repository = FireRepository();
  GetIt.I.registerSingleton<IAppRepository>(repository);
  GetIt.I.registerSingleton<AppController>(AppController(repository: repository));

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
  late StreamSubscription checkListDispose;
  late ReactionDisposer rec;

  @override
  void initState() {
    super.initState();

    rec = autorun((_) {
      if (controller.isLogged) {
        carDispose = controller.listenCar().listen((result) {
          controller.setCars(result);
        });

        checkListDispose = controller.listenCheckList.listen((result) {
          controller.setCheckList(result);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    carDispose.cancel();
    checkListDispose.cancel();
    rec.reaction.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COF',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'),
      ],
      theme: ThemeData(primarySwatch: Colors.red, scaffoldBackgroundColor: const Color.fromRGBO(251, 251, 251, 1)),
      builder: (context, widget) => ResponsiveWrapper.builder(widget,
          maxWidth: 1000,
          minWidth: 480,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: 'MOBILE'),
            ResponsiveBreakpoint.resize(500, name: 'TABLET'),
          ],
          background: Container(color: const Color(0xFFF5F5F5))),
      initialRoute: "/",
      home: const LoginPage(),
    );
  }
}
