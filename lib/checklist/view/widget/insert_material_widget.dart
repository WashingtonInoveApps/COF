import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InsertMaterialWidget extends StatefulWidget {
  final List<ItemModel> init;
  final List<ItensChangesModel> materials;
  final Function(List<ItemModel>) onInsert;
  const InsertMaterialWidget(
      {Key? key,
      required this.materials,
      required this.onInsert,
      required this.init})
      : super(key: key);

  @override
  State<InsertMaterialWidget> createState() => _InsertMaterialWidgetState();
}

class _InsertMaterialWidgetState extends State<InsertMaterialWidget> {
  List<ItemModel> materials = [];
  List<ItemModel> itens = [];

  @override
  void initState() {
    super.initState();
    materials = widget.materials
        .map((e) => e.itens)
        .expand((element) => element)
        .toSet()
        .toList();

    itens
      ..clear()
      ..addAll(List<ItemModel>.from(materials));
  }

  List<ItemModel> processList(List<ItemModel> itens, List<ItemModel> compare) {
    List<ItemModel> list = [];

    for (final item in itens) {
      final index = compare.indexWhere(
          (e) => e.description.toLowerCase() == item.description.toLowerCase());

      if (index == -1) {
        list.add(item);
      } else {
        final material = compare[index];
        list.add(ItemModel(
            id: item.id,
            description: item.description,
            quantity: (item.quantity + material.quantity)));
      }
    }

    return list.where((e) => e.quantity > 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(maxWidth: 350),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'MATERIAIS DE CONSUMO',
                        style: Constants.title.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Constants.primary),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        MdiIcons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: List.generate(materials.length, (index) {
                    final item = materials[index];
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.description,
                            style: Constants.title,
                          ),
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            InkWell(
                                onTap: (itens[index].quantity > 0)
                                    ? () {
                                        setState(() {
                                          itens[index].quantity =
                                              (itens[index].quantity - 1);
                                        });
                                      }
                                    : null,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: (itens[index].quantity > 0)
                                      ? Constants.primary
                                      : Colors.grey,
                                  child: const Icon(
                                    Icons.remove,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                )),
                            Text(
                              itens[index].quantity.toString(),
                              style: Constants.title.copyWith(fontSize: 18),
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    itens[index].quantity =
                                        (itens[index].quantity + 1);
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Constants.primary,
                                  child: Icon(
                                    Icons.add,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    );
                  }).expand((widget) => [widget, const Divider()]).toList()
                    ..removeLast(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancelar',
                          style: Constants.title.copyWith(color: Colors.grey),
                        )),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onInsert(processList(itens, widget.init));
                          },
                          child: Text(
                            'Inserir',
                            style: Constants.titleButton,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
