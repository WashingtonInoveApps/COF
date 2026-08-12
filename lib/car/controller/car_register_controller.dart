import 'package:bsu_control/core/sections_controller.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/cia_model.dart';
import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:mobx/mobx.dart';

import '../../core/constants.dart';
import '../../model/obm_model.dart';

part 'car_register_controller.g.dart';

class CarRegisterController = _CarRegisterControllerBase
    with _$CarRegisterController;

abstract class _CarRegisterControllerBase with Store {
  final CarModel? init;
  final UserModel user;
  final List<OBMModel> obms;
  final List<String> types;

  _CarRegisterControllerBase({
    required this.obms,
    required this.init,
    required this.user,
    required this.types,
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
  String? function;

  @observable
  String? type;

  @observable
  bool outherTypeField = false;

  @observable
  String prefix = '';

  @observable
  String model = '';

  @observable
  String modelPneu = '';

  @observable
  String plate = '';

  @observable
  String km = '';

  @observable
  String ticket = '';

  @observable
  String? outherType;

  @observable
  StatusCar state = StatusCar.waiting;

  @observable
  ObservableList<ItensChangesModel> sectionsItens =
      <ItensChangesModel>[].asObservable();

  // @observable
  // ObservableList<ItensChangesModel> sectionsMaterials =
  //     <ItensChangesModel>[].asObservable();

  // @observable
  // ObservableList<ItensChangesModel> sectionsMaterialsConsumable =
  //     <ItensChangesModel>[].asObservable();

  @observable
  ObservableList<CarChangeModel> changes = <CarChangeModel>[].asObservable();

  @observable
  ObservableList<CarStatusModel> status = <CarStatusModel>[].asObservable();

  @computed
  bool get adm => function != Constants.carsFunctions.first;

  @computed
  CarModel get car {
    return CarModel(
        id: init?.id,
        type: outherType ?? (type ?? ''),
        state: state,
        function: function ?? '',
        model: model,
        plate: plate,
        cia: cia,
        ciaID: cia?.id,
        modelPneu: modelPneu,
        obmID: obm?.id ?? '',
        prefix: prefix,
        km: int.parse(km),
        adm: adm,
        ticket: ticket,
        itens: sectionsItens,
        changes: changes,
        status: status,
        arref: init?.arref ?? 0,
        oil: init?.oil ?? 0,
        images: List<FileModel>.from(images.whereType<FileModel>().toList()),
        materials: [],
        materialsConsumable: []);
  }

  @action
  void inicialization() {
    if (init != null) {
      sectionsItens.clear();

      obm = obms.firstWhere((e) => e.id == init?.obmID);

      cia = obm?.cias
          .cast<CiaModel?>()
          .firstWhere((e) => e?.id == init?.ciaID, orElse: () => null);

      type = init?.type;
      function = init?.function;
      prefix = init?.prefix ?? '';
      plate = init?.plate ?? '';
      model = init?.model ?? '';
      modelPneu = init?.modelPneu ?? '';
      ticket = init?.ticket ?? '';
      km = init?.km.toString() ?? '';
      state = init?.state ?? StatusCar.waiting;

      for (final itens in init?.itens ?? []) {
        addSections(list: sectionsItens, value: itens.copyWith(value: false));
      }

      images
        ..clear()
        ..addAll(init?.images ?? []);

      changes.addAll(init?.changes ?? []);
    }

    return;
  }

  @action
  void setOBM(OBMModel? value) => obm = value;

  @action
  void setCia(CiaModel? value) => cia = value;

  @action
  void setFunction(String? value) => function = value ?? function;

  @action
  void setType(String? value) {
    type = value;

    if (type == "Outros") {
      outherTypeField = true;
    } else {
      outherTypeField = false;
    }
  }

  void setImagens(List<dynamic> value) {
    images
      ..clear()
      ..addAll(value);
  }

  @action
  void setOutherType(String? value) => outherType = value;

  @action
  void setPrefix(String? value) => prefix = value ?? '';

  @action
  void setModel(String? value) => model = value ?? '';

  @action
  void setModelPneu(String? value) => modelPneu = value ?? '';

  @action
  void setTicket(String? value) => ticket = value ?? '';

  @action
  void setKM(String? value) => km = value ?? '0';

  @action
  void setPlate(String? value) => plate = value ?? '';

  @action
  void onChanges(List<CarChangeModel> value) {
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
      {required List<ItensChangesModel> list, required int index}) {
    SectionsController.expansionSections(
      list: list,
      index: index,
    );
  }

  @action
  void addSections({
    required List<ItensChangesModel> list,
    required ItensChangesModel value,
  }) {
    SectionsController.addSections(
      list: list,
      value: value,
    );
  }

  @action
  void editSections({
    required List<ItensChangesModel> list,
    required int index,
    required ItensChangesModel value,
  }) {
    SectionsController.editSections(
      list: list,
      index: index,
      value: value,
    );
  }

  @action
  void removeSections({
    required List<ItensChangesModel> list,
    required int index,
  }) {
    SectionsController.removeSections(
      list: list,
      index: index,
    );
  }

  @action
  void addItensSection({
    required List<ItensChangesModel> list,
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
    required List<ItensChangesModel> list,
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
    required List<ItensChangesModel> list,
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
    required List<ItensChangesModel> list,
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

        if (prefix.isEmpty) {
          messagesErros.add('Insira um prefixo antes de continuar.');
        }

        return messagesErros;
      case 1:
        if (model.isEmpty) {
          messagesErros.add('Insira o modelo do veículo.');
        }
        if (plate.isEmpty) {
          messagesErros.add('Insira a placa do veículo.');
        }
        if (km.isEmpty) {
          messagesErros.add('Insira o KM inicial do veículo.');
        }
        if (modelPneu.isEmpty) {
          messagesErros.add('Insira a referência do pneu do veículo.');
        }
        if (ticket.isEmpty) {
          messagesErros.add('Insira o número do cartão de abastecimento.');
        }

        return messagesErros;
      case 2:
        if (function?.isEmpty ?? true) {
          messagesErros.add('Selecione a função do veículo.');
        }

        if (type?.isEmpty ?? true) {
          messagesErros.add('Selecione o tipo do veículo.');
        }

        if (images.isEmpty) {
          messagesErros.add('Adicione as images do veículo.');
        }

        if (outherTypeField && (outherType == null)) {
          messagesErros.add('Insira o novo tipo do veículo.');
        }

        return messagesErros;
      default:
        return [];
    }
  }
}
