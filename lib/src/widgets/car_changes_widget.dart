import 'dart:typed_data';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';

class CarChangesWidget extends StatefulWidget {
  final int region;
  final List<CarChangeModel>? initValue;
  final bool add;
  final bool remove;
  final UserModel user;
  final bool update;
  final String? checklistId;

  final Function(CarChangeModel change)? onAdd;
  final Function(int i)? onRemove;

  const CarChangesWidget(
      {Key? key,
      this.region = 15,
      this.initValue,
      this.add = true,
      this.remove = false,
      this.checklistId,
      this.onAdd,
      this.onRemove,
      required this.user,
      this.update = false})
      : super(key: key);

  @override
  _CarChangesWidgetState createState() => _CarChangesWidgetState();
}

class _CarChangesWidgetState extends State<CarChangesWidget> {
  GlobalKey paintKey = GlobalKey();

  List<CarChangeModel> changes = [];

  @override
  Widget build(BuildContext context) {
    changes
      ..clear()
      ..addAll(widget.initValue ?? changes);
    final offs = changes.map((e) => Offset(e.dx, e.dy)).toList();

    debugPrint('Chagens widget.: ${widget.initValue?.length}');

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              height: 250.0,
              width: 380.0,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/car.jpg"), fit: BoxFit.contain)),
            ),
          ),
          Center(
            child: Listener(
              onPointerDown: (PointerDownEvent event) async {
                RenderBox box = paintKey.currentContext!.findRenderObject()! as RenderBox;

                var _off = box.globalToLocal(event.position);
                var result = Offset((_off.dx.round()).toDouble(), (_off.dy.round()).toDouble());

                int index = -1;

                if (offs.isNotEmpty) {
                  for (int i = 0; i < offs.length; i++) {
                    var dx = (offs[i].dx - result.dx).abs();
                    var dy = (offs[i].dy - result.dy).abs();

                    if (dx < widget.region && dy < widget.region) {
                      index = i;
                      break;
                    }
                  }
                }

                if (index != -1) {
                  final enable = (widget.remove || ((widget.checklistId == changes[index].checklistId) && (changes[index].value == widget.update)));

                  debugPrint('Enable.: $enable , checklistId.: ${changes[index].checklistId}');
                  await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            titlePadding: EdgeInsets.zero,
                            contentPadding: EdgeInsets.zero,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Stack(
                                    children: [
                                      changes[index].fileImage != null
                                          ? Image.memory(
                                              changes[index].fileImage!,
                                              height: 250,
                                              width: 350,
                                              fit: BoxFit.cover,
                                            )
                                          : kIsWeb
                                              ? Image.network(
                                                  changes[index].image,
                                                  height: 250,
                                                  width: 350,
                                                  fit: BoxFit.cover,
                                                )
                                              : CachedNetworkImage(
                                                  height: 250,
                                                  width: 350,
                                                  imageUrl: changes[index].image,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const SizedBox(height: 60.0, width: 60.0, child: Center(child: CircularProgressIndicator())),
                                                  errorWidget: (context, url, error) => const Center(
                                                      child: Icon(
                                                    Icons.error,
                                                    size: 60.0,
                                                  )),
                                                ),
                                      Positioned(
                                          top: 10.0,
                                          right: 10.0,
                                          child: enable
                                              ? GestureDetector(
                                                  onTap: () {
                                                    if (widget.onRemove != null) {
                                                      widget.onRemove!(index);
                                                    }

                                                    changes.removeAt(index);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: Colors.black45,
                                                      child: Icon(
                                                        MdiIcons.delete,
                                                        size: 20,
                                                        color: Colors.white,
                                                      )),
                                                )
                                              : Container())
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatDate(changes[index].date),
                                        style: subtitleHint,
                                      ),
                                      const Divider(),
                                      Text(
                                        changes[index].description,
                                        style: title,
                                      ),
                                      const Divider(),
                                      Text(
                                        "${changes[index].user.name} - ${changes[index].user.matricula}",
                                        style: subtitleHint,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ));
                } else {
                  if (widget.add) {
                    await showDialog(
                        context: context,
                        builder: (context) => AddChange(
                              onSelect: (image, description) {
                                final change = CarChangeModel(
                                    checklistId: widget.checklistId,
                                    user: widget.user,
                                    value: widget.update,
                                    dx: result.dx,
                                    dy: result.dy,
                                    description: description,
                                    fileImage: image,
                                    date: DateTime.now());

                                changes.add(change);
                                if (widget.onAdd != null) widget.onAdd!(change);
                              },
                            ));
                  }
                }
              },
              child: CustomPaint(
                key: paintKey,
                foregroundPainter: MyCustomPainter(changes: changes),
                child: Container(
                  height: 250.0,
                  width: 380.0,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  final List<CarChangeModel> changes;

  MyCustomPainter({required this.changes});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round;

    var paint2 = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round;

    final points = changes.map((e) => Offset(e.dx, e.dy)).toList();

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 6, changes[i].value ? paint1 : paint2);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

//Adicionar imagem e descrição.
class AddChange extends StatefulWidget {
  final Function(dynamic image, String description) onSelect;
  const AddChange({Key? key, required this.onSelect}) : super(key: key);

  @override
  _AddChangeState createState() => _AddChangeState();
}

class _AddChangeState extends State<AddChange> {
  Uint8List? image;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(6),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () async {
                final result = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);

                if (result != null) {
                  image = await result.readAsBytes();

                  setState(() {});
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(5), color: Colors.grey.shade300),
                child: image != null
                    ? Image.memory(
                        image!,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          MdiIcons.imagePlus,
                          size: 50.0,
                          color: Colors.white,
                        ),
                      ),
              )),
          const SizedBox(
            height: 10.0,
          ),
          FieldText(controller: controller, hint: "DESCRIÇÃO"),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
              height: 50.0,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (image != null) {
                      widget.onSelect(image!, controller.text);
                    }

                    Navigator.of(context).pop();
                  },
                  child: Text("INSERIR", style: titleButton)))
        ],
      ),
    );
  }
}
