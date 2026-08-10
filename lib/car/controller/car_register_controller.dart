import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/user_model.dart';
import '../../enum/core_enum.dart';
import '../../model/obm_model.dart';

import 'package:mobx/mobx.dart';
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

  List<dynamic> images = [];

  @observable
  OBMModel? obm;

  @observable
  String? cia;

  @observable
  String? function;

  @observable
  String? type;

  @observable
  bool fieldCarTypeVisible = false;

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
  ObservableList<ItensChangesModel> sectionsItens =
      <ItensChangesModel>[].asObservable();

  @observable
  ObservableList<ItensChangesModel> sectionsMaterials =
      <ItensChangesModel>[].asObservable();

  @observable
  ObservableList<ItensChangesModel> sectionsMaterialsConsumable =
      <ItensChangesModel>[].asObservable();

  @observable
  ObservableList<CarChangeModel> changes = <CarChangeModel>[].asObservable();

  @observable
  ObservableList<CarStatusModel> status = <CarStatusModel>[].asObservable();

  @computed
  CarModel get car {
    return CarModel(
        type: type ?? '',
        function: function ?? '',
        ticket: ticket,
        itens: sectionsItens,
        changes: changes,
        status: status,
        images: [],
        materials: sectionsMaterials,
        materialsConsumable: sectionsMaterialsConsumable);
  }

  @action
  void inicialization() {
    if (init != null) {
      sectionsItens.clear();
      sectionsMaterials.clear();
      sectionsMaterialsConsumable.clear();

      type = init?.type;
      function = init?.function;

      for (final itens in car.itens) {
        addSections(list: sectionsItens, value: itens.copyWith(value: false));
      }

      for (final itens in car.materials) {
        addSections(
            list: sectionsMaterials, value: itens.copyWith(value: false));
      }

      for (final itens in car.materialsConsumable) {
        addSections(
            list: sectionsMaterialsConsumable,
            value: itens.copyWith(value: false));
      }

      changes.addAll(init?.changes ?? []);
    }

    return;
  }

  @action
  void setOBM(OBMModel? value) => obm = value;

  @action
  void setCia(String? value) => cia = value;

  @action
  void setFunction(String? value) => function = value ?? function;

  @action
  void setType(String? value) {
    type = value;

    if (type == "Outros") {
      fieldCarTypeVisible = true;
    } else {
      fieldCarTypeVisible = false;
    }
  }

  void setImagens(List<dynamic> value) {
    images
      ..clear()
      ..addAll(value);
  }

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
  expansionSections(
      {required List<ItensChangesModel> list, required int index}) {
    final section = list[index].copyWith(value: !list[index].value);
    list.removeAt(index);
    list.insert(index, section);
  }

  @action
  void addSections({
    required List<ItensChangesModel> list,
    required ItensChangesModel value,
  }) {
    list.add(value);
  }

  @action
  void editSections({
    required List<ItensChangesModel> list,
    required int index,
    required ItensChangesModel value,
  }) {
    final section = list[index].copyWith(description: value.description);

    list.removeAt(index);
    list.insert(index, section);
  }

  @action
  void removeSections({
    required List<ItensChangesModel> list,
    required int index,
  }) {
    list.removeAt(index);
  }

  @action
  void addItensSection({
    required List<ItensChangesModel> list,
    required int index,
    required ItemModel value,
  }) {
    final section = ItensChangesModel.fromMap(list[index].toMap());

    final itens = List<ItemModel>.from(section.itens);
    itens.add(value);

    list.removeAt(index);
    list.insert(index, section.copyWith(itens: itens));
  }

  @action
  void editItensSection({
    required List<ItensChangesModel> list,
    required int index,
    required int indexItem,
    required ItemModel value,
  }) {
    final section = ItensChangesModel.fromMap(list[index].toMap());

    final itens = List<ItemModel>.from(section.itens);
    itens.removeAt(indexItem);
    itens.insert(indexItem, value);

    list.removeAt(index);
    list.insert(index, section.copyWith(itens: itens));
  }

  @action
  void moveItensSection({
    required List<ItensChangesModel> list,
    required int index,
    required int indexItem,
    required MoveDirection position,
  }) {
    int pos = 0;
    final section = ItensChangesModel.fromMap(list[index].toMap());
    final itens = List<ItemModel>.from(section.itens);

    if (position == MoveDirection.up) {
      pos = indexItem - 1;
    } else {
      pos = indexItem + 1;
    }

    if (pos == -1 || pos > (itens.length - 1)) return;

    final item = ItemModel.fromMap(itens[indexItem].toMap());

    itens.removeAt(indexItem);
    itens.insert(pos, item);

    list.removeAt(index);
    list.insert(index, section.copyWith(itens: itens));
  }

  @action
  void removeItensSection({
    required List<ItensChangesModel> list,
    required int index,
    required int indexItem,
  }) {
    final section = ItensChangesModel.fromMap(list[index].toMap());

    final itens = List<ItemModel>.from(section.itens);
    itens.removeAt(indexItem);

    list.removeAt(index);
    list.insert(index, section.copyWith(itens: itens));
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
      default:
        return [];
    }
  }
}
