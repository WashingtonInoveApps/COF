import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';

///Criado com auxílio do ChatGPT
class PaginationWidget extends StatefulWidget {
  final int page;
  final int limit;
  final int length;
  final Function(int) onChange;
  const PaginationWidget(
      {Key? key,
      required this.page,
      required this.length,
      required this.onChange,
      required this.limit})
      : super(key: key);

  @override
  State<PaginationWidget> createState() => _PaginationWidgetState();
}

class _PaginationWidgetState extends State<PaginationWidget> {
  List<dynamic> buildPages(int current, int length, {int window = 1}) {
    final pages = <dynamic>[];

    int start = current - window;
    int end = current + window;

    if (start < 2) start = 2;
    if (end > length - 1) end = length - 1;

    pages.add(1);

    if (start > 2) pages.add('...');

    for (int i = start; i <= end; i++) {
      pages.add(i);
    }

    if (end < length - 1) pages.add('...');

    if (length > 1) pages.add(length);

    return pages;
  }

  Widget pageButton(dynamic item, int current, Function(int) onChange) {
    final isDots = item == '...';
    final isActive = item == current;

    return InkWell(
      onTap: isDots ? null : () => onChange(item),
      child: CircleAvatar(
        radius: 15,
        backgroundColor: isActive ? Constants.primary : Colors.grey.shade400,
        child: Text(
          item.toString().padLeft(2, '0'),
          style: Constants.subtitle.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  int get totalPages => (widget.length / widget.limit).ceil();

  @override
  Widget build(BuildContext context) {
    final enableBack = widget.page > 1;
    final enableNext = widget.page < totalPages;
    return Row(
      spacing: 2,
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: enableBack ? () => widget.onChange(widget.page - 1) : null,
          child: CircleAvatar(
            radius: 18,
            backgroundColor:
                enableBack ? Constants.primary : Colors.grey.shade300,
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 1,
        ),
        ...buildPages(widget.page, totalPages).map((item) {
          return pageButton(item, widget.page, widget.onChange);
        }),
        const SizedBox(
          width: 1,
        ),
        InkWell(
          onTap: enableNext ? () => widget.onChange(widget.page + 1) : null,
          child: CircleAvatar(
            radius: 18,
            backgroundColor:
                enableNext ? Constants.primary : Colors.grey.shade300,
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
