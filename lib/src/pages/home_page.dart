import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/checklist/check_list_details_page.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/car_card.dart';
import 'package:bsu_control/src/widgets/check_list_card.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

class HomePage extends StatefulWidget {
  final bool home;
  const HomePage({Key? key, this.home = false}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = GetIt.I.get<AppController>();

  late ReactionDisposer rec;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    rec = autorun((_) {
      if (widget.home) {
        for (var car in controller.cars) {
          if ((car.km > car.oil) && car.oil > 0) {
            Future.delayed(Duration.zero, () {
              CherryToast.warning(
                title: "${car.prefix} - Verifique troca de óleo",
                titleStyle: title,
                toastDuration: const Duration(seconds: 2),
                animationDuration: const Duration(milliseconds: 500),
              ).show(context);
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    rec.reaction.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: const AppBarCustom(
          page: 0,
        ),
        body: SingleChildScrollView(
          child: LayoutBuilder(builder: (context, constrains) {
            double width = constrains.maxWidth > 500 ? 500.0 : constrains.maxWidth;
            double width1 = constrains.maxWidth > 500 ? constrains.maxWidth * 0.5 : constrains.maxWidth;

            return Center(
              child: Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: width1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "OPERACIONAIS",
                              style: titleHint,
                            )),
                            Expanded(
                              child: Observer(builder: (_) {
                                return TextButton(
                                    style: TextButton.styleFrom(side: BorderSide(color: Theme.of(context).primaryColor)),
                                    onPressed: () async {
                                      showDatePicker(
                                              context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2050))
                                          .then((value) {
                                        if (value != null) controller.setReferenceDate(value);
                                      });
                                    },
                                    child: Text(
                                      formatDate(controller.date, outher: true),
                                      style: title.copyWith(color: Theme.of(context).primaryColor),
                                    ));
                              }),
                            ),
                          ],
                        ),
                        const Divider(),
                        Center(
                          child: SizedBox(
                            width: width,
                            child: Observer(builder: (_) {
                              return controller.checkLists.isEmpty
                                  ? Center(
                                      child: Text(
                                        "Ops ! Nenhum registro encontrado.",
                                        style: title,
                                      ),
                                    )
                                  : Column(
                                      children: List.generate(
                                          controller.checkLists.length,
                                          (index) => CheckListCard(
                                                checkList: controller.checkLists[index],
                                                onTap: () {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => CheckListDetailsPage(checkListId: controller.checkLists[index].id!)));
                                                },
                                              )),
                                    );
                            }),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: width1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          "ADMINISTRATIVO",
                          style: titleHint,
                        ),
                        const Divider(),
                        Center(
                          child: SizedBox(
                            width: width,
                            child: Observer(builder: (_) {
                              return controller.carsADM.isEmpty
                                  ? Center(
                                      child: Text(
                                        "Ops ! Nenhum registro encontrado.",
                                        style: title,
                                      ),
                                    )
                                  : Column(
                                      children: List.generate(
                                          controller.carsADM.length,
                                          (index) => CarCard(
                                                car: controller.carsADM[index],
                                                onTap: () {},
                                              )),
                                    );
                            }),
                          ),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
