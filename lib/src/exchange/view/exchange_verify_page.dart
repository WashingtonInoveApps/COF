// import 'package:bsu_control/app_controller.dart';
// import 'package:bsu_control/core/constants.dart';
// import 'package:bsu_control/src/exchange/controller/exchange_controller.dart';
// import 'package:bsu_control/src/exchange/repository/exchange_repository.dart';
// import 'package:bsu_control/src/widgets/alert_message.dart';
// import 'package:bsu_control/src/widgets/app_bar_widget.dart';
// import 'package:bsu_control/src/widgets/textfield_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:get_it/get_it.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// class FilesPage extends StatefulWidget {
//   const FilesPage({Key? key}) : super(key: key);

//   @override
//   State createState() => _FilesPageState();
// }

// class _FilesPageState extends State<FilesPage> {
//   final controllerCOD = TextEditingController();
//   final app = GetIt.I.get<AppController>();

//   late ExchangeController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = ExchangeController(app: app, repository: ExchangeRepository());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               const AppBarCustom(
//                 menu: false,
//               ),
//               Expanded(
//                   child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                             child: Text(
//                           'VERIFICAÇÃO DE AUTENCIDADE DE DOCUMENTO',
//                           style: subtitleHint,
//                         )),
//                         SizedBox(
//                           height: 45.0,
//                           width: 150.0,
//                           child: ElevatedButton(
//                               onPressed: () async {
//                                 if (controllerCOD.text.isNotEmpty) {
//                                   controller
//                                       .verifyFile(
//                                           token: (controllerCOD.text).replaceAll(' ', '').trim())
//                                       .then((value) {
//                                     if (value == null) {
//                                       controllerCOD.clear();
//                                       showDialog(
//                                           context: context,
//                                           builder: (context) => AlertMessage(
//                                               title: '',
//                                               message:
//                                                   'Documento com código de assinatura inválido.',
//                                               onPressedOK: () =>
//                                                   Navigator.of(context).pop()));
//                                     }
//                                   });
//                                 } else {
//                                   showDialog(
//                                       context: context,
//                                       builder: (context) => AlertMessage(
//                                           title: '',
//                                           message:
//                                               'Insira o código de assinatura para verificar o documento.',
//                                           onPressedOK: () =>
//                                               Navigator.of(context).pop()));
//                                 }
//                               },
//                               child: Text(
//                                 "VERIFICAR",
//                                 style: titleButton,
//                               )),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Observer(builder: (_) {
//                       final enable = controller.exchangeVerify != null;
//                       return Visibility(
//                         visible: enable,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(20)),
//                           child: Row(children: [
//                             Icon(
//                               enable
//                                   ? MdiIcons.checkCircle
//                                   : MdiIcons.closeCircle,
//                               size: 20,
//                               color: enable ? Colors.green : Colors.red,
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     (enable
//                                             ? 'Documento gerado digitalmente às ${formatDate(controller.exchangeVerify?.at ?? DateTime.now())}'
//                                             : 'Assinatura documento inválida.')
//                                         .toUpperCase(),
//                                     style: subtitle.copyWith(color: Colors.grey),
//                                     overflow: TextOverflow.clip,
//                                   )
//                                 ],
//                               ),
//                             )
//                           ]),
//                         ),
//                       );
//                     }),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                           onPressed: () {
//                             controllerCOD.clear();
//                             controller.setExchangeVerify(null);
//                           },
//                           child: Text(
//                             'Limpar Código',
//                             style: subtitle.copyWith(color: Colors.grey),
//                           )),
//                     ),
//                     FieldText(
//                       controller: controllerCOD,
//                       upper: false,
//                       hint: 'CÓDIGO DE ASSINATURA',
//                     ),
//                   ],
//                 ),
//               )),
//             ],
//           ),
//           Observer(builder: (_) {
//             return IgnorePointer(
//               ignoring: !controller.loading,
//               child: Container(
//                 color: controller.loading ? Colors.black54 : Colors.transparent,
//                 child: Center(
//                     child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                       controller.loading ? Colors.white : Colors.transparent),
//                 )),
//               ),
//             );
//           })
//         ],
//       ),
//     );
//   }
// }
