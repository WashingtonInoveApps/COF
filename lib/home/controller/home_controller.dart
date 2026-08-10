import 'dart:developer';

import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/state_enum.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:bsu_control/home/repository/home_interface.dart';
import 'package:bsu_control/home/repository/home_repository.dart';
import 'package:bsu_control/model/service_model.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final ConfigModel config;
  late IHomeRepository repository;

  _HomeControllerBase({required this.config}) {
    repository = HomeRepository(
        endpoint: config.endpoint, appID: config.appID, test: config.test);
  }

  @observable
  bool loading = false;

  @observable
  bool isOperacionalToday = true;

  @observable
  List<ChecklistModel> checklistsPeriod = <ChecklistModel>[].asObservable();

  @observable
  List<ServiceModel> servicesPeriod = <ServiceModel>[].asObservable();

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

  @computed
  int get lengthSortings {
    if (filter.isEmpty) return servicesPeriod.length;

    return servicesPeriodSort.length;
  }

  @computed
  List<ChecklistModel> get checklistPeriodSort {
    if (filter.isNotEmpty) {
      final filtered = checklistsPeriod
          .where((e) =>
              ((e.prefix.toLowerCase().contains(filter.toLowerCase())) ||
                  e.obm.toLowerCase().contains(filter.toLowerCase()) ||
                  (e.cia.toLowerCase().contains(filter.toLowerCase())) ||
                  (e.team.toLowerCase().contains(filter.toLowerCase())) ||
                  (e.state.label.toLowerCase().contains(filter.toLowerCase()))))
          .toList();

      final list = Core.paginate(list: filtered, page: page, limit: limit);
      return List<ChecklistModel>.from(list);
    } else {
      final list =
          Core.paginate(list: checklistsPeriod, page: page, limit: limit);
      return List<ChecklistModel>.from(list);
    }
  }

  @computed
  List<ServiceModel> get servicesPeriodSort {
    if (filter.isNotEmpty) {
      final lowFilter = filter.toLowerCase();

      final filtered = servicesPeriod
          .where((e) =>
              (e.obm.prefix.toLowerCase() == lowFilter) ||
              (e.team?.toLowerCase() == lowFilter) ||
              (e.components
                  .map((e) => e.user.fullname.toLowerCase())
                  .contains(lowFilter)))
          .toList();

      final list = Core.paginate(list: filtered, page: page, limit: limit);
      return List<ServiceModel>.from(list);
    } else {
      final list =
          Core.paginate(list: servicesPeriod, page: page, limit: limit);
      return List<ServiceModel>.from(list);
    }
  }

  @action
  Stream<List<ChecklistModel>> listenChecklistPeriod(
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
  Stream<List<ServiceModel>> listenServices({
    required DateTime dateStart,
    required DateTime dateFinish,
  }) {
    loading = true;

    log('Date Start: ${Core.formatDate(dateStart)}');
    log('Date Finish: ${Core.formatDate(dateFinish)}');

    final stream = repository.listenServices(
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
  setDateRange({
    required DateTime dateStart,
    required DateTime dateFinish,
  }) {
    dateReferenceStart = dateStart;
    dateReferenceFinish = dateFinish;
  }

  @action
  setChecklistPeriod(List<ChecklistModel> value) {
    value.sort((a, b) => b.date.compareTo(a.date));
    checklistsPeriod
      ..clear()
      ..addAll(value);
  }

  @action
  setServicesPeriod(List<ServiceModel> value) {
    value.sort((a, b) => b.date.compareTo(a.date));
    servicesPeriod
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
