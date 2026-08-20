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

  static List<SectionItensModel> deepCopySections({
    required List<SectionItensModel> value,
  }) {
    return value.map((section) {
      return SectionItensModel(
        id: section.id,
        description: section.description,
        value: false,
        obs: section.obs,
        itens: section.itens.map((item) {
          return ItemModel(
            id: item.id,
            description: item.description,
            quantity: item.quantity,
            quantityMarked: item.quantityMarked,
            value: item.value,
            obmID: item.obmID,
            ciaID: item.ciaID,
          );
        }).toList(),
      );
    }).toList();
  }

  //Criado com auxilio do ChatGPT
  static List<SectionItensModel> mergeSections({
    required List<SectionItensModel> currentSections,
    required List<SectionItensModel> savedSections,
  }) {
    /// 1️⃣ Cria um mapa das seções salvas usando o ID como chave
    final Map<String, SectionItensModel> savedSectionsMap = {
      for (var section in savedSections) section.id: section
    };

    /// 2️⃣ Percorre as seções atuais do carro
    return currentSections.map((currentSection) {
      /// 3️⃣ Procura se essa seção já existia no checklist salvo
      final savedSection = savedSectionsMap[currentSection.id];

      /// 4️⃣ Se não existir, significa que é uma seção nova
      if (savedSection == null) {
        return currentSection;
      }

      /// 5️⃣ Cria um mapa dos itens salvos dessa seção
      final Map<String, ItemModel> savedItemsMap = {
        for (var item in savedSection.itens) item.id: item
      };

      /// 6️⃣ Agora percorremos os itens atuais da seção
      final mergedItems = currentSection.itens.map((currentItem) {
        /// 7️⃣ Verifica se esse item já foi salvo antes
        final savedItem = savedItemsMap[currentItem.id];

        /// 8️⃣ Se existir, reaproveita os dados do checklist salvo
        if (savedItem != null) {
          return currentItem.copyWith(
              quantityMarked: savedItem.quantityMarked, value: savedItem.value);
        }

        /// 9️⃣ Se não existir, é um item novo
        return currentItem;
      }).toList();

      /// 🔟 Retorna a seção mesclada
      return currentSection.copyWith(
        itens: mergedItems,
        obs: savedSection.obs,
        value: false,
      );
    }).toList();
  }

  static List<SectionItensModel> changeList({
    required List<SectionItensModel> list,
    required ItemModel value,
    required int indexSection,
    required int indexItem,
  }) {
    final section = SectionItensModel.fromMap(list[indexSection].toMap());
    List<ItemModel> itens = List.from(section.itens);

    itens.removeAt(indexItem);
    itens.insert(indexItem, value);

    list.removeAt(indexSection);
    list.insert(indexSection, section.copyWith(itens: itens));

    return list;
  }
}
