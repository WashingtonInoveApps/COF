import 'dart:developer';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/src/home/repository/home_interface.dart';
import 'package:bsu_control/src/home/repository/home_repository.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final AppController app;
  late IHomeRepository repository;

  _HomeControllerBase({required this.app}) {
    repository = HomeRepository(
        endpoint: app.endpoint, appID: app.appID, test: app.test);
  }

  @observable
  bool loading = false;

  @observable
  bool isOperacionalToday = true;

  @observable
  List<CheckListModel> checklistsPeriod = <CheckListModel>[].asObservable();

  @observable
  DateTime date = DateTime.now();

  @observable
  DateTime dateReferenceStart = DateTime.now();

  @observable
  DateTime dateReferenceFinish = DateTime.now();

  @observable
  String filter = '';

  @observable
  int limit = 10;

  @observable
  int page = 1;

  @action
  Stream<List<CheckListModel>> listenChecklistPeriod(
      {required DateTime dateStart, required DateTime dateFinish}) {
    loading = true;

    log('Date Start: ${Core.formatDate(dateStart)}');
    log('Date Finish: ${Core.formatDate(dateFinish)}');

    final stream = repository.listenChecklistPeriod(
      referenceDateStart: dateStart,
      referenceDateFinish: dateFinish,
    );

    loading = false;

    return stream;
  }

  @action
  setLoading(bool value) {
    loading = value;
  }

  @action
  setDateRangeChecklist(
      {required DateTime dateStart, required DateTime dateFinish}) {
    dateReferenceStart = dateStart;
    dateReferenceFinish = dateFinish;
  }

  @computed
  List<CheckListModel> get checklistPeriodSort {
    if (filter.isNotEmpty) {
      final filtered = checklistsPeriod
          .where((e) =>
              (e.prefix.toLowerCase().contains(filter.toLowerCase()) ||
                  e.obm.toLowerCase().contains(filter.toLowerCase()) ||
                  (e.cia.toLowerCase().contains(filter.toLowerCase())) ||
                  (e.team.toLowerCase().contains(filter.toLowerCase())) ||
                  (e.state.label.toLowerCase().contains(filter.toLowerCase()))))
          .toList();

      final list = Core.paginate(list: filtered, page: page, limit: limit);
      return List<CheckListModel>.from(list);
    } else {
      final list =
          Core.paginate(list: checklistsPeriod, page: page, limit: limit);
      return List<CheckListModel>.from(list);
    }
  }

  @action
  setChecklistPeriod(List<CheckListModel> value) {
    value.sort((a, b) => b.date.compareTo(a.date));
    checklistsPeriod
      ..clear()
      ..addAll(value);
  }

  @action
  setDate(DateTime value) {
    date = value;
  }

  @action
  onChangeFilter(String? value) {
    filter = value ?? '';
    page = 1;
  }

  @action
  setLimit(int? value) {
    limit = value ?? limit;
    page = 1;
  }

  @action
  setPage(int value) {
    page = value;
  }
}
