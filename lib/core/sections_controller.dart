import '../model/item_model.dart';
import '../model/section_itens_model.dart';

enum MoveDirection {
  up,
  down,
}

class SectionsController {
  static void addSections({
    required List<SectionItensModel> list,
    required SectionItensModel value,
  }) {
    list.add(value);
  }

  static void removeSections({
    required List<SectionItensModel> list,
    required int index,
  }) {
    list.removeAt(index);
  }

  static void addItensSection({
    required List<SectionItensModel> list,
    required int index,
    required ItemModel value,
  }) {
    final section = SectionItensModel.fromMap(list[index].toMap());

    final itens = List<ItemModel>.from(section.itens);
    itens.add(value);

    list.removeAt(index);
    list.insert(index, section.copyWith(itens: itens));
  }

  static void editItensSection({
    required List<SectionItensModel> list,
    required int index,
    required int indexItem,
    required ItemModel value,
  }) {
    final section = SectionItensModel.fromMap(list[index].toMap());

    final itens = List<ItemModel>.from(section.itens);
    itens.removeAt(indexItem);
    itens.insert(indexItem, value);

    list.removeAt(index);
    list.insert(index, section.copyWith(itens: itens));
  }

  static void moveItensSection({
    required List<SectionItensModel> list,
    required int index,
    required int indexItem,
    required MoveDirection position,
  }) {
    int pos = 0;
    final section = SectionItensModel.fromMap(list[index].toMap());
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
    required List<SectionItensModel> list,
    required int index,
    required int indexItem,
  }) {
    final section = SectionItensModel.fromMap(list[index].toMap());

    final itens = List<ItemModel>.from(section.itens);
    itens.removeAt(indexItem);

    list.removeAt(index);
    list.insert(index, section.copyWith(itens: itens));
  }

  static void editSections({
    required List<SectionItensModel> list,
    required int index,
    required SectionItensModel value,
  }) {
    final section = list[index].copyWith(description: value.description);

    list.removeAt(index);
    list.insert(index, section);
  }

  static void expansionSections(
      {required List<SectionItensModel> list, required int index}) {
    final section = list[index].copyWith(value: !list[index].value);
    list.removeAt(index);
    list.insert(index, section);
  }
}
