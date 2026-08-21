import 'dart:typed_data';

import 'package:bsu_control/checklist/repository/checklist_interface.dart';
import 'package:bsu_control/checklist/repository/checklist_repository.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/state_enum.dart';
import 'package:bsu_control/model/checklist_model.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:mobx/mobx.dart';

import '../../model/material_checklist_model.dart';

part 'checklist_controller.g.dart';

// ignore: library_private_types_in_public_api
class CheckListController = _CheckListControllerBase with _$CheckListController;

abstract class _CheckListControllerBase with Store {
  final ConfigModel config;
  final List<ChecklistModel> checklistTodays;
  late ICheckListRepository repository;

  List<String> messagesErros = [];

  @observable
  bool loading = false;

  _CheckListControllerBase({
    required this.config,
    required this.checklistTodays,
  }) {
    repository = CheckListRepository(
      endpoint: config.endpoint,
      appID: config.appID,
      test: config.test,
    );
  }

  Stream<ChecklistModel> streamChecklistByID({required String checklistID}) {
    return repository.streamChecklistByID(checklistID: checklistID);
  }

  @observable
  ObservableList<ChecklistModel> myChecklistUser =
      <ChecklistModel>[].asObservable();

  @observable
  ObservableList<SectionItensModel> materialsConsumable =
      <SectionItensModel>[].asObservable();

  @observable
  ObservableList<ItemModel> materialsConsumedUsed =
      <ItemModel>[].asObservable();

  @observable
  DateTime date = DateTime.now();

  @observable
  DateTime dateReferenceStart = DateTime.now();

  @observable
  DateTime dateReferenceFinish = DateTime.now();

  @observable
  DateTime dateStartConfig = DateTime.now().subtract(const Duration(days: 1));

  @observable
  DateTime dateFinishConfig = DateTime.now();

  @observable
  DateTime dateMyChecklist = DateTime.now();

  String? id;

  @observable
  int step = 0;

  @observable
  String filter = '';

  @observable
  int limit = 10;

  @observable
  int page = 1;

  Stream<List<ChecklistModel>> streamChecklistPeriod(
      {required String userID,
      required DateTime referenceDateStart,
      required DateTime referenceDateFinish}) {
    return repository.streamChecklistPeriod(
        referenceDateStart: referenceDateStart,
        referenceDateFinish: referenceDateFinish);
  }

  Stream<List<ChecklistModel>> streamChecklistUser({required String userID}) {
    return repository.streamChecklistUser(userID: userID);
  }

  @computed
  List<ChecklistModel> get myChecklistUserSort {
    if (filter.isNotEmpty) {
      final filtered = myChecklistUser
          .where((e) =>
              (e.prefix.toLowerCase().contains(filter.toLowerCase()) ||
                  (e.obm?.name.toLowerCase().contains(filter.toLowerCase()) ??
                      false) ||
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
          Core.paginate(list: myChecklistUser, page: page, limit: limit);
      return List<ChecklistModel>.from(list);
    }
  }

  @action
  changeDate(DateTime? value) => date = value ?? date;

  @action
  setDateMyChecklist(DateTime? value) =>
      dateMyChecklist = value ?? dateMyChecklist;

  @action
  setDateRangeChecklist(
      {required DateTime dateStart, required DateTime dateFinish}) {
    dateReferenceStart = dateStart;
    dateReferenceFinish = dateFinish;
  }

  @action
  void cleanExibitionConfig() {
    dateStartConfig = DateTime.now().subtract(const Duration(days: 1));
    dateFinishConfig = DateTime.now();
  }

  @action
  setDateStartConfig(DateTime? value) {
    dateStartConfig = value ?? dateStartConfig;
  }

  @action
  setDateFinishConfig(DateTime? value) {
    dateFinishConfig = value ?? dateFinishConfig;
  }

  @action
  setMyChecklistUser(List<ChecklistModel> value) {
    value.sort((a, b) => b.date.compareTo(a.date));

    myChecklistUser
      ..clear()
      ..addAll(value);
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

  @action
  addMaterialsConsumedUsed(List<ItemModel> values) {
    materialsConsumedUsed
      ..clear()
      ..addAll(values);
  }

  @action
  deleteMaterialsConsumedUsed(int index) {
    materialsConsumedUsed.removeAt(index);
  }

  @action
  void processStep(bool value) {
    if (value) {
      step++;
    } else {
      if (step > 0) step--;
    }
  }

  @action
  setLoading(bool value) => loading = value;

  @action
  Future<bool> save({required ChecklistModel checklist}) async {
    try {
      loading = true;

      final result = await repository.save(
        checklist: checklist,
      );

      loading = false;
      return false;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> finish(
      {required ChecklistModel checklist, Uint8List? image}) async {
    try {
      final now = DateTime.now();
      final states = List<StatesChecklist>.from(checklist.states);

      final state = StatesChecklist(state: StateProgress.completed, date: now);
      states.add(state);

      final result = await repository.finish(
          checklist: checklist.copyWith(
              state: state.state,
              // materials: materialsConsumedUsed,
              states: states,
              dateFinish: now,
              enable: false),
          image: image);

      loading = false;
      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> delete({required ChecklistModel checklist}) async {
    // try {
    //   loading = true;

    //   final car = cars.cast<CarModel?>().firstWhere(
    //       (e) => e?.id == checklist.vehicular?.car.id,
    //       orElse: () => null);

    //   if (car == null) {
    //     throw Exception('Veículo não encontrado.');
    //   }

    //   final changes = List<CarChangeModel>.from(car.changes);

    //   for (final change in (checklist.vehicular?.changes ?? [])) {
    //     changes.removeWhere(
    //         (e) => (e.checklistID != null) && (e.checklistID == checklist.id));
    //   }

    //   final result = await repository.delete(
    //       checklist: checklist, car: car.copyWith(changes: changes));

    //   loading = false;
    //   return result;
    // } catch (e) {
    //   loading = false;
    //   rethrow;
    // }

    return false;
  }

  @action
  Future<MaterialChecklistModel?> getChecklistMaterial({
    required String? teamID,
  }) async {
    if (teamID == null) return null;

    loading = true;
    final result = await repository.getChecklistMaterial(teamID: teamID);
    loading = false;

    return result;
  }
}
