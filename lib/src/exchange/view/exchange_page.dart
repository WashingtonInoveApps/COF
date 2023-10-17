// import 'dart:async';

// import 'package:bsu_control/app_controller.dart';
// import 'package:bsu_control/src/exchange/controller/exchange_controller.dart';
// import 'package:bsu_control/src/exchange/repository/exchange_repository.dart';
// import 'package:bsu_control/src/exchange/view/exchange_register_page.dart';
// import 'package:bsu_control/src/widgets/alert_message.dart';
// import 'package:bsu_control/src/widgets/app_bar_widget.dart';
// import 'package:bsu_control/src/widgets/exchange_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:get_it/get_it.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';

// import '../../../core/constants.dart';

// class ExchangePage extends StatefulWidget {
//   const ExchangePage({Key? key}) : super(key: key);

//   @override
//   State createState() => _ExchangePageState();
// }

// class _ExchangePageState extends State<ExchangePage> {
//   final controllerCOD = TextEditingController();
//   final app = GetIt.I.get<AppController>();
//   final keyForm = GlobalKey<FormState>();

//   late ExchangeController controller;
//   late StreamSubscription exchangeDispose;

//   @override
//   void initState() {
//     super.initState();
//     controller = ExchangeController(app: app, repository: ExchangeRepository());

//     exchangeDispose = controller.listenExchanges.listen((result) {
//       controller.setExchanges(result);
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     exchangeDispose.cancel();
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
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         SizedBox(
//                           height: 45.0,
//                           child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) =>
//                                         const ExchangeRegisterPage()));
//                               },
//                               child: Text(
//                                 "REALIZAR PERMUTA",
//                                 style: titleButton,
//                               )),
//                         ),
//                         const Spacer(),
//                         Observer(builder: (_) {
//                           return SizedBox(
//                             height: 40,
//                             child: TextButton(
//                                 style: TextButton.styleFrom(
//                                     side: BorderSide(
//                                         color: Theme.of(context).primaryColor)),
//                                 onPressed: () async {
//                                   showMonthPicker(
//                                           context: context,
//                                           initialDate: DateTime.now(),
//                                           firstDate: DateTime(2021),
//                                           lastDate: DateTime(2050))
//                                       .then((value) {
//                                     if (value != null) {
//                                       controller.setReferenceDate(value);
//                                     }
//                                   });
//                                 },
//                                 child: Text(
//                                   formatDate(controller.referenceDate,
//                                       referenceDate: true),
//                                   style: title.copyWith(
//                                       color: Theme.of(context).primaryColor),
//                                 )),
//                           );
//                         }),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 5.0,
//                     ),
//                     const Divider(),
//                     Text(
//                       'MINHAS PERMUTAS',
//                       style: subtitleHint,
//                     ),
//                     const SizedBox(
//                       height: 20.0,
//                     ),
//                     Observer(
//                         builder: (context) => controller.exhangesSort.isEmpty
//                             ? Center(
//                                 child: Text(
//                                   'Nenhuma permuta sua solicitada foi localizada.',
//                                   style: title,
//                                 ),
//                               )
//                             : Column(
//                                 children: List.generate(
//                                     controller.exhangesSort.length, (index) {
//                                   final exchange =
//                                       controller.exhangesSort[index];
//                                   return ExchangeCard(
//                                       onDownload: () async {
//                                         await controller.onDownload(
//                                             id: exchange.id!);
//                                       },
//                                       onAuthorized: () async {
//                                         final result = await showDialog(
//                                             context: context,
//                                             builder: (context) => AlertMessage(
//                                                   title: '',
//                                                   message:
//                                                       'Deseja autorizar a solicitação de permuta ?',
//                                                   cancel: true,
//                                                   onPressedOK: () =>
//                                                       Navigator.of(context)
//                                                           .pop(true),
//                                                   onPressedCancel: () =>
//                                                       Navigator.of(context)
//                                                           .pop(false),
//                                                 ));

//                                         if (result) {
//                                           await controller.update(
//                                               exchange: exchange.copyWith(
//                                                   authorizerID: app.user.id,
//                                                   authorizedDate:
//                                                       DateTime.now(),
//                                                   authorizer: app.user));
//                                         }
//                                       },
//                                       onConfirmRequested: () async {
//                                         final result = await showDialog(
//                                             context: context,
//                                             builder: (context) => AlertMessage(
//                                                   title: '',
//                                                   message:
//                                                       'O militar fica responsável para executar o respesctivo serviço estando sujeito a inteira responsábilidade inerente a sua execução. CONFIRMO E AUTORIZO A PERMUTA.',
//                                                   cancel: true,
//                                                   onPressedOK: () =>
//                                                       Navigator.of(context)
//                                                           .pop(true),
//                                                   onPressedCancel: () =>
//                                                       Navigator.of(context)
//                                                           .pop(false),
//                                                 ));

//                                         if (result) {
//                                           await controller.update(
//                                               exchange: exchange.copyWith(
//                                                   requestedAuthorizedDate:
//                                                       DateTime.now()));
//                                         }
//                                       },
//                                       user: app.user,
//                                       exchange: exchange);
//                                 }),
//                               )),
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
