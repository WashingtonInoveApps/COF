import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../model/section_itens_model.dart';

class ListItensViewWidget extends StatelessWidget {
  final List<SectionItensModel> categories;

  const ListItensViewWidget({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = List<SectionItensModel>.from(categories);

    return StatefulBuilder(
      builder: (context, setState) {
        return ExpansionPanelList(
          elevation: 2,
          expandedHeaderPadding: EdgeInsets.zero,
          expansionCallback: (panelIndex, expanded) {
            setState(() {
              list[panelIndex].value = expanded;
            });
          },
          children: list.map((category) {
            return ExpansionPanel(
                isExpanded: category.value,
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 10),
                    title: Text(
                      category.description,
                      style: Constants.title,
                    ),
                  );
                },
                body: Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: category.itens
                        .map((item) {
                          return Row(
                            children: [
                              Expanded(
                                  child: Text(
                                item.description,
                                style: Constants.title,
                              )),
                              Text.rich(
                                TextSpan(
                                    text: item.quantity.toString(),
                                    children: [
                                      TextSpan(
                                        text: ' unids.',
                                        style: Constants.subtitleHint,
                                      )
                                    ]),
                                style: Constants.title,
                              ),
                            ],
                          );
                        })
                        .expand((widget) => [
                              widget,
                              const Divider(),
                            ])
                        .toList()
                      ..removeLast(),
                  ),
                ));
          }).toList(),
        );
      },
    );
  }
}
