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
  DateTime referenceDate = DateTime.now();

  // @observable
  // TimeOfDay firstHourFirst = const TimeOfDay(hour: 8, minute: 0);

  // @observable
  // TimeOfDay lastHourFirst = const TimeOfDay(hour: 8, minute: 0);

  // @observable
  // TimeOfDay firstHourLast = const TimeOfDay(hour: 8, minute: 0);

  // @observable
  // TimeOfDay lastHourLast = const TimeOfDay(hour: 8, minute: 0);

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

  Stream<List<ExchangeModel>> get listenExchanges =>
      repository.listenExchange(referenceDate: referenceDate);

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
  setType(String? value) => type = value ?? type;

  @action
  setRequested(UserModel? value) => requested = value;

  @action
  setReferenceDate(DateTime value) => referenceDate = value;

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
    }
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

  // @action
  // setFirstTimeFirst(TimeOfDay value) => firstHourFirst = value;

  // @action
  // setLastTimeFirst(TimeOfDay value) => lastHourFirst = value;

  // @action
  // setFirstTimeLast(TimeOfDay value) => firstHourLast = value;

  // @action
  // setLastTimeLast(TimeOfDay value) => lastHourLast = value;

  @action
  Future<bool> save({required ExchangeModel exchange}) async {
    loading = true;
    final result = await repository.save(exchange: exchange);

    if (result != null) {
      await onDownload(id: result);
    }

    loading = false;
    return result != null;
  }

  // @action
  // Future<bool> update({required ExchangeModel exchange}) async {
  //   loading = true;
  //   final result = await repository.update(exchange: exchange);
  //   loading = false;

  //   return result;
  // }

  Future<bool> onDownload({required String id}) async {
    try {
      final url =
          'https://us-central1-bsucos-function.cloudfunctions.net/app/exchange/pdf?exchangeID=$id';

      if (kIsWeb) {
        debugPrint('É WEB');

        html.AnchorElement anchorElement = html.AnchorElement(href: url);
        anchorElement.download = url;
        anchorElement.click();
        // await launchUrlString(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Não é WEB');
        final appDocDir = await getApplicationDocumentsDirectory();
        String destFile = appDocDir.path;
        String filename = 'permutasamu_${DateTime.now().millisecond}.pdf';

        await repository.onDownload(
            destFile: destFile, filename: filename, path: url);

        await OpenAppFile.open('$destFile/$filename');
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  DateTime processDate({required DateTime date, required TimeOfDay hour}) {
    return DateTime(date.year, date.month, date.day, hour.hour, hour.minute, 0);
  }
}
