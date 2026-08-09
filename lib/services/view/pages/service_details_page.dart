import 'package:bsu_control/enum/services_enum.dart';
import 'package:bsu_control/services/view/widget/card_components_widget.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/service_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../core/core.dart';
import '../../controller/service_controller.dart';
import '../widget/list_widget.dart';

class ServiceDetailsPage extends StatefulWidget {
  final List<OBMModel> obms;
  final ServiceController controller;

  const ServiceDetailsPage({
    Key? key,
    required this.controller,
    required this.obms,
  }) : super(key: key);

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  late ServiceController controller;

  final maskContact = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  List<String> teams = [];

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller
        .setOBM(widget.obms.firstWhere((e) => e.id == controller.user.obmID));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Constants.primary,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              'INFORMAÇÕES DA EQUIPE',
              style: Constants.titleButton,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Observer(builder: (_) {
            return ListWidget<UserModel>(
              value: controller.userSelect,
              list: controller.users,
              hint: 'Selecione o componente',
              searchText: (user) {
                return '${user.name} ${user.fullname} ${user.registration.replaceAll('.', '').replaceAll('-', '')}';
              },
              // onSelect: (user) {},
              onSelect: controller.setUserSelect,
              child: (user) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Core.boldFirstName(
                        name: user.name,
                        fullName: user.fullname,
                        style: Constants.title,
                      ),
                      Text(
                        user.graduation,
                        style: Constants.subtitleHint,
                      ),
                    ],
                  ),
                );
              },
            );
          }),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 40,
            child: Observer(builder: (_) {
              return ElevatedButton.icon(
                  onPressed: (controller.userSelect != null)
                      ? () {
                          final date = DateTime.now();
                          final startDate =
                              DateTime(date.year, date.month, date.day, 08, 00);
                          final endDate = DateTime(
                              date.year, date.month, date.day + 1, 08, 00);

                          controller.setComponent(ServicesComponent(
                              functions: [ServiceFunctions.operator],
                              user: controller.userSelect!,
                              startDate: startDate,
                              endDate: endDate));

                          controller.setUserSelect(null);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.second),
                  icon: const Icon(
                    Icons.person_add_alt_1,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Inserir',
                    style: Constants.titleButton,
                  ));
            }),
          ),
          const SizedBox(
            height: 10,
          ),
          Text.rich(
            TextSpan(text: "COMPONENTES ", children: [
              TextSpan(
                  text: '*', style: Constants.title.copyWith(color: Colors.red))
            ]),
            style: Constants.subtitleHint,
          ),
          const SizedBox(
            height: 5,
          ),
          Observer(builder: (context) {
            return Column(
              children: [
                Column(
                    children:
                        List.generate(controller.components.length, (index) {
                  final component = controller.components[index];

                  return CardComponentWidget(
                    component: component,
                    onChange: (value) {
                      controller.changeComponent(value, index);
                    },
                    onDelet: (controller.user != component.user)
                        ? () {
                            controller.deleteComponent(index);
                          }
                        : null,
                  );
                })),
              ],
            );
          }),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
