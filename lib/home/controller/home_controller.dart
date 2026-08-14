import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/state_enum.dart';
import 'package:bsu_control/home/repository/home_interface.dart';
import 'package:bsu_control/home/repository/home_repository.dart';
import 'package:bsu_control/model/checklist_model.dart';
import 'package:bsu_control/model/config_model.dart';
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
  DateTime date = DateTime.now();

  @observable
  DateTime operationDate = DateTime.now();

  @observable
  String filter = '';

  @observable
  int limit = 10;

  @observable
  int page = 1;

  @computed
  int get lengthSortings {
    if (filter.isEmpty) return checklistsPeriod.length;

    return checklistPeriodSort.length;
  }

  @computed
  List<ChecklistModel> get checklistPeriodSort {
    if (filter.isNotEmpty) {
      final filtered = checklistsPeriod
          .where((e) =>
              ((e.prefix.toLowerCase().contains(filter.toLowerCase())) ||
                  e.obm.name.toLowerCase().contains(filter.toLowerCase()) ||
                  ((e.cia?.name.toLowerCase() ?? '')
                      .contains(filter.toLowerCase())) ||
                  ((e.team?.name.toLowerCase() ?? '')
                      .contains(filter.toLowerCase())) ||
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

  @action
  setLoading(bool value) {
    loading = value;
  }

  @action
  setOperationDate({
    required DateTime value,
  }) {
    operationDate = value;
  }

  @action
  setChecklistPeriod(List<ChecklistModel> value) {
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
