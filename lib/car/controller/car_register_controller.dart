import 'dart:developer';

import 'package:bsu_control/core/sections_controller.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/cia_model.dart';
import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:mobx/mobx.dart';

import '../../core/validation.dart';
import '../../model/obm_model.dart';
import '../../model/outher_changes_model.dart';

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

    if (init == null) setOBM(obms.firstWhere((e) => e.id == user.obmID));
  }

  List<FileModel> deletFiles = [];

  @observable
  ObservableList<FileModel?> images = <FileModel?>[].asObservable();

  @observable
  OBMModel? obm;

  @observable
  CiaModel? cia;

  @observable
  FunctionCar? function;

  @observable
  String? type;

  @observable
  bool otherTypeField = false;

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
  String? otherType;

  @observable
  StatusCar state = StatusCar.waiting;

  @observable
  ObservableList<SectionItensModel> sectionsItens =
      <SectionItensModel>[].asObservable();

  @observable
  ObservableList<CarChangeModel> changes = <CarChangeModel>[].asObservable();

  @observable
  ObservableList<OtherChangeModel> others = <OtherChangeModel>[].asObservable();

  @observable
  ObservableList<CarStatusModel> status = <CarStatusModel>[].asObservable();

  @computed
  bool get adm => function == FunctionCar.administrative;

  @computed
  CarModel get car {
    return CarModel(
      id: init?.id,
      type: otherType ?? (type ?? ''),
      state: state,
      function: function ?? FunctionCar.operational,
      model: model,
      plate: plate,
      cia: cia,
      ciaID: cia?.id,
      modelPneu: modelPneu,
      obmID: obm?.id ?? '',
      obm: obm,
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

      others
        ..clear()
        ..addAll(init?.others ?? []);

      changes.addAll(init?.changes ?? []);
    }

    return;
  }

  @action
  void addOtherChange(OtherChangeModel value) {
    others.add(value);
  }

  @action
  void deleteOtherChange(int index) {
    others.removeAt(index);
  }

  void deletedFiles(FileModel? file) {
    if (file == null) return;

    log('File: ${file.toJson()}');

    if (file.data == null) {
      deletFiles.add(file);
    }
  }

  @action
  void setOBM(OBMModel? value) {
    cia = null;
    obm = value;
  }

  @action
  void setCia(CiaModel? value) => cia = value;

  @action
  void setFunction(FunctionCar? value) => function = value ?? function;

  @action
  void setType(String? value) {
    type = value;

    if (type == "Outros") {
      otherTypeField = true;
    } else {
      otherTypeField = false;
    }
  }

  void setImagens(List<FileModel?> value) {
    images
      ..clear()
      ..addAll(value);
  }

  @action
  void setOtherType(String? value) => otherType = value;

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

        if (prefix.isEmpty) {
          messagesErros.add('Insira um prefixo antes de continuar.');
        }

        return messagesErros;
      case 1:
        if (Validation.validatorPreenchimento(model) != null) {
          messagesErros.add('Insira o modelo do veículo.');
        }
        if (Validation.validatorPreenchimento(plate) != null) {
          messagesErros.add('Insira a placa do veículo.');
        }
        if (Validation.validatorNumber(km) != null) {
          messagesErros.add('Insira o KM inicial do veículo.');
        }
        // if (modelPneu.isEmpty) {
        //   messagesErros.add('Insira a referência do pneu do veículo.');
        // }
        // if (ticket.isEmpty) {
        //   messagesErros.add('Insira o número do cartão de abastecimento.');
        // }

        return messagesErros;
      case 2:
        if (function == null) {
          messagesErros.add('Selecione a função do veículo.');
        }

        if (Validation.validatorPreenchimento(type) != null) {
          messagesErros.add('Selecione o tipo do veículo.');
        }

        if (Validation.validatorListImage(images) != null) {
          messagesErros.add('Adicione as images do veículo.');
        }

        if (otherTypeField &&
            (Validation.validatorPreenchimento(otherType) != null)) {
          messagesErros.add('Insira o novo tipo do veículo.');
        }

        if (sectionsItens.isNotEmpty) {
          for (final section in sectionsItens) {
            if (section.itens.isEmpty) {
              messagesErros.add(
                  'Adicione itens à seção de itens ${section.description}, antes de continuar ou exclua a seção.');
            }
          }
        }

        return messagesErros;
      default:
        return [];
    }
  }
}
