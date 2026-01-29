import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../checklist/view/checklist_page.dart';

class BackgraundPage extends StatefulWidget {
  final bool menu;
  final bool login;
  final Widget childLeft;
  final Widget? childRight;
  final Widget? bottom;
  final double maxWidth;
  final Function()? onBack;

  const BackgraundPage(
      {Key? key,
      required this.childLeft,
      this.childRight,
      this.maxWidth = 1000,
      this.menu = false,
      this.login = false,
      this.bottom,
      this.onBack})
      : super(key: key);

  @override
  State<BackgraundPage> createState() => _BackgraundPageState();
}

class _BackgraundPageState extends State<BackgraundPage> {
  final controller = GetIt.I.get<AppController>();

  OBMModel? userOBM;

  @override
  void initState() {
    super.initState();

    if (controller.obms.isNotEmpty) {
      userOBM =
          controller.obms.firstWhere((e) => e.id == controller.user.obmID);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget menu() => Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Controle Operacional de Frota',
              style: Constants.title
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              userOBM?.name ?? '',
              style: Constants.title,
            ),
            Text(
              controller.user.fullname,
              style: Constants.titleHint,
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: widget.menu,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChecklistPage()));
                      },
                      child: Text(
                        'Checklist',
                        style: Constants.titleButton,
                      )),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Viaturas',
                        style: Constants.titleButton,
                      )),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Usuários',
                        style: Constants.titleButton,
                      )),
                ],
              ),
            ),
          ],
        );

    return Material(
      color: Constants.primary,
      child: SafeArea(
        top: true,
        child: LayoutBuilder(builder: (context, constrained) {
          bool modeMOBILE = constrained.maxWidth < 500;
          double width = (modeMOBILE || widget.childRight == null)
              ? constrained.maxWidth
              : constrained.maxWidth * 0.48;

          return Center(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: widget.maxWidth),
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: widget.onBack,
                            child: Image.asset(
                              'assets/cbmcecabecalho2.png',
                              fit: BoxFit.fitHeight,
                              height: 70,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Visibility(
                            visible: !widget.login,
                            child: modeMOBILE ? Container() : menu(),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width,
                            child: widget.childLeft,
                          ),
                          SizedBox(
                            width: width,
                            child: widget.childRight,
                          )
                        ],
                      ),
                    ),
                  )),
                  (widget.bottom == null) ? Container() : widget.bottom!
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
