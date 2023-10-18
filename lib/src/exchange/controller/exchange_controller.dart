import 'dart:io';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/model/exchange_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/exchange/repository/exchange_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:dio/dio.dart';
part 'exchange_controller.g.dart';

// ignore: library_private_types_in_public_api
class ExchangeController = _ExchangeControllerBase with _$ExchangeController;

abstract class _ExchangeControllerBase with Store {
  final IExchangeRepository repository;
  final AppController app;

  _ExchangeControllerBase({required this.repository, required this.app});

  @observable
  bool loading = false;

  @observable
  bool checkConfirm = false;

  @observable
  UserModel? requested;

  @observable
  String unidad = "";

  @observable
  String function = "";

  @observable
  String type = "";

  @observable
  ObservableList<ExchangeModel> exchanges = <ExchangeModel>[].asObservable();

  @observable
  ObservableList<UserModel> usersExchange = <UserModel>[].asObservable();

  // @observable
  // DateTime referenceDate = DateTime.now();

  @observable
  DateTime firstDateFirst = DateTime.now();

  @observable
  DateTime lastDateFirst = DateTime.now().add(const Duration(days: 1));

  @observable
  DateTime firstDateLast = DateTime.now();

  @observable
  DateTime lastDateLast = DateTime.now().add(const Duration(days: 1));

  @observable
  bool isSimple = true;

  @observable
  bool isSamu = true;

  @observable
  ExchangeModel? exchangeVerify;

  // Stream<List<ExchangeModel>> get listenExchanges =>
  //     repository.listenExchange(referenceDate: referenceDate);

  @computed
  List<ExchangeModel> get exhangesSort => app.user.admin
      ? exchanges
      : exchanges
          .where((e) =>
              e.requesterID == app.user.id || e.requestedID == app.user.id)
          .toList();

  @action
  setExchanges(List<ExchangeModel> value) {
    exchanges
      ..clear()
      ..addAll(value);

    exchanges.sort((a, b) => a.date.compareTo(b.date));
  }

  @action
  setUnidad(String? value) => unidad = value ?? unidad;

  @action
  setFunction(String? value) => function = value ?? function;

  @action
  setType(String? value) {
    type = value ?? type;
  }

  @action
  setRequested(UserModel? value) => requested = value;

  // @action
  // setReferenceDate(DateTime value) => referenceDate = value;

  @action
  setCheckConfirm(bool? value) => checkConfirm = value ?? checkConfirm;

  @action
  setSimple(bool value) => isSimple = value;

  @action
  setSamu(bool value) {
    isSamu = value;

    if (value) {
      setSimple(true);
      setType('SIMPLES');

      final users = app.users.where((e) => e.samu).toList();
      usersExchange
        ..clear()
        ..addAll(users);
    } else {
      final users = app.users.where((e) => e.obm == app.user.obm).toList();
      usersExchange
        ..clear()
        ..addAll(users);
    }

    requested = usersExchange.first;
  }

  @action
  setExchangeVerify(ExchangeModel? value) => exchangeVerify = value;

  @action
  setFirstDateFirst(DateTime value) => firstDateFirst = value;

  @action
  setLastDateFirst(DateTime value) => lastDateFirst = value;

  @action
  setFirstDateLast(DateTime value) => firstDateLast = value;

  @action
  setLastDateLast(DateTime value) => lastDateLast = value;

  @action
  Future<bool> onDownload({required ExchangeModel exchange}) async {
    try {
      loading = true;
      final dio = Dio(BaseOptions(responseType: ResponseType.bytes));

      final response = await dio.post(
          'https://us-central1-bsucos-function.cloudfunctions.net/app/exchange',
          data: exchange.toJson());

      final filename = '${exchange.date.microsecondsSinceEpoch.toString()}.pdf';

      if (response.statusCode == 200) {
        final bytes = Uint8List.fromList(response.data);

        if (kIsWeb) {
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url);
          anchor.download = filename;
          anchor.click();
        } else {
          final appDocDir = await getApplicationDocumentsDirectory();
          String destFile = appDocDir.path;
          final path = '$destFile/$filename';

          final file = File(path);

          if (!file.existsSync()) {
            file.writeAsBytesSync(bytes);
          }

          await OpenAppFile.open(path);
        }
      }
      loading = false;
      return true;
    } catch (e) {
      loading = false;
      return false;
    }
  }

  DateTime processDate({required DateTime date, required TimeOfDay hour}) {
    return DateTime(date.year, date.month, date.day, hour.hour, hour.minute, 0);
  }
}
