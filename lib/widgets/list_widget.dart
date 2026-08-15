// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ListWidget<T> extends StatefulWidget {
  final T? value;
  final List<T> list;
  final Widget Function(T) child;
  final Function(T) onSelect;
  final String hint;
  final String Function(T)? searchText;

  const ListWidget({
    Key? key,
    required this.list,
    required this.child,
    this.hint = 'SELECIONE',
    this.searchText,
    required this.onSelect,
    this.value,
  }) : super(key: key);

  @override
  State<ListWidget<T>> createState() => _ListWidgetState<T>();
}

class _ListWidgetState<T> extends State<ListWidget<T>> {
  T? value;

  void _openDropdown() {
    final controller = TextEditingController();
    List<T> filteredList = List.from(widget.list);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(10),
              content: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Pesquisar...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        setDialogState(() {
                          final search = text.toLowerCase();

                          filteredList = widget.list.where((item) {
                            final value = widget.searchText != null
                                ? widget.searchText!(item)
                                : item.toString();

                            return value.toLowerCase().contains(search);
                          }).toList();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];

                          return InkWell(
                            onTap: () {
                              setState(() {
                                value = item;
                                widget.onSelect(value as T);
                              });

                              Navigator.pop(context);
                            },
                            child: widget.child(item),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    value = widget.value;
    return Material(
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade700),
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              onTap: _openDropdown,
              child: Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: value == null
                        ? Text(
                            widget.hint,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        : widget.child(value as T),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class ListWidget<T> extends StatefulWidget {
//   final List<T> list;
//   final Widget Function(T) child;
//   const ListWidget({Key? key, required this.list, required this.child})
//       : super(key: key);

//   @override
//   State<ListWidget<T>> createState() => _ListWidgetState<T>();
// }

// class _ListWidgetState<T> extends State<ListWidget<T>> {
//   T? value;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.list.isNotEmpty) value = widget.list.first;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             height: 50.0,
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 5),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(5.0)),
//             child: DropdownButton<T>(
//                 isExpanded: true,
//                 value: value,
//                 underline: const SizedBox.shrink(),
//                 onChanged: (result) {},
//                 items: widget.list
//                     .map((e) => DropdownMenuItem<T>(
//                           value: e,
//                           child: widget.child(e),
//                         ))
//                     .toList()),
//           ),
//         ],
//       ),
//     );
//   }
// }
