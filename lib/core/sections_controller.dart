import '../model/item_model.dart';
import '../model/itens_changes_model.dart';

enum MoveDirection {
  up,
  down,
}

class SectionsController {
  static void addSections({
    required List<ItensChangesModel> list,
    required ItensChangesModel value,
  }) {
    list.add(value);
  }

  static void removeSections({
    required List<ItensChangesModel> list,
    required int index,
  }) {
    list.removeAt(index);
  }

  static void addItensSection({
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

  static void editItensSection({
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

  static void moveItensSection({
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

  static void removeItensSection({
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

  static void editSections({
    required List<ItensChangesModel> list,
    required int index,
    required ItensChangesModel value,
  }) {
    final section = list[index].copyWith(description: value.description);

    list.removeAt(index);
    list.insert(index, section);
  }

  static void expansionSections(
      {required List<ItensChangesModel> list, required int index}) {
    final section = list[index].copyWith(value: !list[index].value);
    list.removeAt(index);
    list.insert(index, section);
  }
}
