import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = GetIt.I.get<AppController>();

  late StreamSubscription carDispose;
  late StreamSubscription checklistDispose;
  late StreamSubscription usersDispose;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    super.dispose();
    carDispose.cancel();
    checklistDispose.cancel();
    usersDispose.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: BackgraundPage(
            menu: true, childLeft: Text(controller.cars.length.toString())));
  }
}
