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

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child:
            BackgraundPage(childLeft: Text(controller.cars.length.toString())));
  }
}
