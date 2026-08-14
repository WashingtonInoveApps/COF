import 'package:bsu_control/core/sections_controller.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/cia_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/materials_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:bsu_control/model/team_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:mobx/mobx.dart';

import '../../model/obm_model.dart';

part 'materials_register_controller.g.dart';

class MaterialsRegisterController = _MaterialsRegisterControllerBase
    with _$MaterialsRegisterController;

abstract class _MaterialsRegisterControllerBase with Store {
  final MaterialsModel? init;
  final UserModel user;
  final List<OBMModel> obms;

  _MaterialsRegisterControllerBase({
    required this.obms,
    required this.init,
    required this.user,
  }) {
    inicialization();
    setOBM(obms.firstWhere((e) => e.id == user.obmID));
  }

  @observable
  ObservableList<dynamic> images = [].asObservable();

  @observable
  OBMModel? obm;

  @observable
  CiaModel? cia;

  @observable
  TeamModel? team;

  @observable
  ObservableList<SectionItensModel> sectionsItens =
      <SectionItensModel>[].asObservable();

  @observable
  ObservableList<OtherChangeModel> changes =
      <OtherChangeModel>[].asObservable();

  @observable
  ObservableList<CarStatusModel> status = <CarStatusModel>[].asObservable();

  @computed
  List<TeamModel> get teams {
    if (cia == null) return [];

    return obm?.team.where((e) => e.ciaID == cia?.id).toList() ?? [];
  }

  @computed
  MaterialsModel get car {
    return MaterialsModel(
      id: init?.id,
      cia: cia,
      ciaID: cia?.id ?? '',
      obmID: obm?.id ?? '',
      itens: sectionsItens,
      changes: init?.changes,
      obm: init?.obm ?? (obm ?? OBMModel(team: [], cias: [])),
      team: init?.team ?? team,
    );
  }

  @action
  void inicialization() {
    if (init != null) {
      sectionsItens.clear();

      obm = obms.firstWhere((e) => e.id == init?.obmID);

      cia = obm?.cias
          .cast<CiaModel?>()
          .firstWhere((e) => e?.id == init?.ciaID, orElse: () => null);

      for (final itens in init?.itens ?? []) {
        addSections(list: sectionsItens, value: itens.copyWith(value: false));
      }

      changes.addAll(init?.changes ?? []);
    }

    return;
  }

  @action
  void setOBM(OBMModel? value) {
    cia = null;
    team = null;

    obm = value;
  }

  @action
  void setCia(CiaModel? value) => cia = value;

  @action
  void setTeam(TeamModel? value) => team = value;

  void setImagens(List<dynamic> value) {
    images
      ..clear()
      ..addAll(value);
  }

  @action
  void onChanges(List<OtherChangeModel> value) {
    changes
      ..clear()
      ..addAll(value);
  }

  @action
  void removeChanges(int index) {
    changes.removeAt(index);
  }

  @action
  void expansionSections(
      {required List<SectionItensModel> list, required int index}) {
    SectionsController.expansionSections(
      list: list,
      index: index,
    );
  }

  @action
  void addSections({
    required List<SectionItensModel> list,
    required SectionItensModel value,
  }) {
    SectionsController.addSections(
      list: list,
      value: value,
    );
  }

  @action
  void editSections({
    required List<SectionItensModel> list,
    required int index,
    required SectionItensModel value,
  }) {
    SectionsController.editSections(
      list: list,
      index: index,
      value: value,
    );
  }

  @action
  void removeSections({
    required List<SectionItensModel> list,
    required int index,
  }) {
    SectionsController.removeSections(
      list: list,
      index: index,
    );
  }

  @action
  void addItensSection({
    required List<SectionItensModel> list,
    required int index,
    required ItemModel value,
  }) {
    SectionsController.addItensSection(
      list: list,
      index: index,
      value: value,
    );
  }

  @action
  void editItensSection({
    required List<SectionItensModel> list,
    required int index,
    required int indexItem,
    required ItemModel value,
  }) {
    SectionsController.editItensSection(
      list: list,
      index: index,
      indexItem: indexItem,
      value: value,
    );
  }

  @action
  void moveItensSection({
    required List<SectionItensModel> list,
    required int index,
    required int indexItem,
    required MoveDirection position,
  }) {
    SectionsController.moveItensSection(
      list: list,
      index: index,
      indexItem: indexItem,
      position: position,
    );
  }

  @action
  void removeItensSection({
    required List<SectionItensModel> list,
    required int index,
    required int indexItem,
  }) {
    SectionsController.removeItensSection(
      list: list,
      index: index,
      indexItem: indexItem,
    );
  }

  List<String> validationForm(int step) {
    List<String> messagesErros = [];

    switch (step) {
      case 0:
        if ((obm?.cias.isNotEmpty ?? false) && cia == null) {
          messagesErros.add('Selecione a companhia antes de continuar.');
        }

        if ((obm?.team.isNotEmpty ?? false) && team == null) {
          messagesErros.add('Selecione a guarnição antes de continuar.');
        }

        return messagesErros;
      case 1:
        return messagesErros;
      case 2:
        return messagesErros;
      default:
        return [];
    }
  }
}
