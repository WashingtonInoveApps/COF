import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/model/dashboard_model.dart';
import 'package:mobx/mobx.dart';
part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final AppController app;

  _HomeControllerBase({required this.app});

  @observable
  bool loading = false;

  @observable
  DateTime date = DateTime.now();

  @observable
  DateTime dateReferenceStart = DateTime.now();

  @observable
  DateTime dateReferenceFinish = DateTime.now();

  @observable
  DashboardModel dashboard = DashboardModel();

  @action
  setDate(DateTime value) => date = value;

  @action
  setDateStart(DateTime? value) {
    dateReferenceStart = value ?? dateReferenceStart;
  }

  @action
  setDateFinish(DateTime? value) {
    dateReferenceFinish = value ?? dateReferenceFinish;
  }
}
