import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/model/exchange_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/exchange/repository/exchange_interface.dart';
import 'package:mobx/mobx.dart';
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
  ObservableList<ExchangeModel> exchanges = <ExchangeModel>[].asObservable();

  @observable
  DateTime referenceDate = DateTime.now();

  @observable
  DateTime dateFirst = DateTime.now();

  @observable
  DateTime dateLast = DateTime.now();

  @observable
  ExchangeModel? exchangeVerify;

  Stream<List<ExchangeModel>> get listenExchanges =>
      repository.listenExchange(referenceDate: referenceDate);

  @computed
  List<ExchangeModel> get exhangesSort => app.user.adm
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
  setRequested(UserModel? value) => requested = value;

  @action
  setDateFirst(DateTime value) => dateFirst = value;

  @action
  setReferenceDate(DateTime value) => referenceDate = value;

  @action
  setCheckConfirm(bool? value) => checkConfirm = value ?? checkConfirm;

  @action
  setDateLast(DateTime value) => dateLast = value;

  @action
  setExchangeVerify(ExchangeModel? value) => exchangeVerify = value;

  @action
  Future<ExchangeModel?> verifyFile({required String token}) async {
    try {
      loading = true;
      final result = await repository.verifyFile(token: token);
      loading = false;

      exchangeVerify = result;
      return result;
    } catch (e) {
      loading = false;

      exchangeVerify = null;
      return null;
    }
  }

  @action
  Future<bool> save({required ExchangeModel exchange}) async {
    loading = true;
    final result = await repository.save(exchange: exchange);
    loading = false;

    return result != null;
  }

  @action
  Future<bool> update({required ExchangeModel exchange}) async {
    loading = true;
    final result = await repository.update(exchange: exchange);
    loading = false;

    return result;
  }
}
