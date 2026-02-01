import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:flutter/material.dart';

class ChacklistItemWidget extends StatefulWidget {
  final ItemModel init;
  final ItemModel item;
  final Function(ItemModel)? onChange;

  const ChacklistItemWidget({
    Key? key,
    required this.item,
    this.onChange,
    required this.init,
  }) : super(key: key);

  @override
  State<ChacklistItemWidget> createState() => _ChacklistItemWidgetState();
}

class _ChacklistItemWidgetState extends State<ChacklistItemWidget> {
  int quantity = 0;
  bool enable = false;

  @override
  void initState() {
    super.initState();
    quantity = widget.init.quantity;
    enable = widget.init.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.description,
                    style: Constants.title,
                  ),
                  (widget.item.quantity > 1)
                      ? Text(
                          '${widget.item.quantity} unids.',
                          style: Constants.subtitleHint,
                        )
                      : Container()
                ],
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            (widget.item.quantity > 1)
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      spacing: 10,
                      children: [
                        InkWell(
                            onTap: (quantity > 0)
                                ? () {
                                    setState(() {
                                      quantity--;
                                      widget.onChange?.call(widget.item
                                          .copyWith(
                                              value: (quantity ==
                                                  widget.item.quantity),
                                              quantity: quantity));
                                    });
                                  }
                                : null,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: (quantity > 0)
                                  ? Constants.primary
                                  : Colors.grey,
                              child: const Icon(
                                Icons.remove,
                                size: 20,
                                color: Colors.white,
                              ),
                            )),
                        Text(
                          quantity.toString(),
                          style: Constants.title.copyWith(fontSize: 18),
                        ),
                        InkWell(
                            onTap: (quantity < widget.item.quantity)
                                ? () {
                                    setState(() {
                                      quantity++;
                                      widget.onChange?.call(widget.item
                                          .copyWith(
                                              value: (quantity ==
                                                  widget.item.quantity),
                                              quantity: quantity));
                                    });
                                  }
                                : null,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: (quantity < widget.item.quantity)
                                  ? Constants.primary
                                  : Colors.grey,
                              child: const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                  )
                : Switch(
                    value: enable,
                    padding: EdgeInsets.zero,
                    activeThumbColor: Constants.primary,
                    onChanged: (value) {
                      setState(() {
                        enable = value;
                        widget.onChange?.call(widget.item
                            .copyWith(value: value, quantity: quantity));
                      });
                    }),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
