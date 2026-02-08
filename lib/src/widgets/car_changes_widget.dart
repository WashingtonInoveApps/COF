import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/image_view_change_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../model/file_model.dart';
import 'image_change_widget.dart';

class CarChangesWidget extends StatefulWidget {
  final int region;
  final CarModel car;
  final bool add;
  final bool remove;
  final UserModel user;
  final bool update;
  final bool register;
  final String? checklistID;

  final Function(List<CarChangeModel> change)? onChange;
  final Function(List<dynamic> images)? onChangeImages;

  const CarChangesWidget(
      {Key? key,
      this.region = 15,
      required this.car,
      this.add = true,
      this.remove = false,
      this.register = false,
      this.checklistID,
      this.onChange,
      required this.user,
      this.update = false,
      this.onChangeImages})
      : super(key: key);

  @override
  State createState() => _CarChangesWidgetState();
}

class _CarChangesWidgetState extends State<CarChangesWidget> {
  GlobalKey paintKey = GlobalKey();
  int indexImage = 0;

  double heightImage = 400;
  double widthImage = 600;

  List<CarChangeModel> changes = [];
  List<dynamic> images = List.filled(4, null, growable: true);

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.car.images.length; i++) {
      images[i] = widget.car.images[i];
    }

    widget.onChangeImages?.call(images);
  }

  hasImageChange(dynamic image) {
    if (image != null) {
      if (image is FileModel) return image.url.isNotEmpty;
      if (image is Uint8List) return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    changes
      ..clear()
      ..addAll(widget.car.changes.where((e) => e.indexImage == indexImage));
    debugPrint('Chagens widget.: ${changes.length}');

    final image = images[indexImage];

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              contentPadding: const EdgeInsets.all(10),
                              content: imagesChangesView(
                                  context: context, changes: changes),
                            );
                          });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(100)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.list_alt_rounded,
                          size: 25,
                          color: Constants.primary,
                        ),
                      ),
                    )),
              )),
              menuView(
                  indexImage: indexImage,
                  onChange: (value) {
                    setState(() {
                      indexImage = value;
                    });
                  }),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          (hasImageChange(image))
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Center(
                    child: Stack(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(5),
                            child: (image is Uint8List)
                                ? Image.memory(
                                    image,
                                    height: heightImage,
                                    width: widthImage,
                                    fit: BoxFit.contain,
                                  )
                                : (image is FileModel)
                                    ? CachedNetworkImage(
                                        imageUrl: image.url,
                                        height: heightImage,
                                        width: widthImage,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: CircularProgressIndicator(
                                              color: Constants.primary,
                                              value: downloadProgress.progress),
                                        ),
                                        fit: BoxFit.contain,
                                      )
                                    : Column(
                                        spacing: 5,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Sem imagem',
                                            style: Constants.subtitleHint,
                                          ),
                                        ],
                                      ),
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTapDown: (TapDownDetails details) async {
                              RenderBox box = paintKey.currentContext!
                                  .findRenderObject()! as RenderBox;

                              final local =
                                  box.globalToLocal(details.globalPosition);

                              // 📌 COORDENADA PROPORCIONAL
                              final tapDx = local.dx / box.size.width;
                              final tapDy = local.dy / box.size.height;

                              int index = -1;

                              // 🔍 VERIFICA SE TOCOU EM UM PONTO JÁ EXISTENTE
                              for (int i = 0; i < changes.length; i++) {
                                final dx = (changes[i].dx - tapDx).abs();
                                final dy = (changes[i].dy - tapDy).abs();

                                if (dx < (widget.region / box.size.width) &&
                                    dy < (widget.region / box.size.height)) {
                                  index = i;
                                  break;
                                }
                              }

                              if (index != -1) {
                                final enable = ((widget.remove &&
                                        (widget.checklistID ==
                                            changes[index].checklistID) &&
                                        !changes[index].value) ||
                                    widget.update);

                                showDialog(
                                    context: context,
                                    builder: (context) => ImageViewChangeWidget(
                                          enable: enable,
                                          change: changes[index],
                                          onRemove: () {
                                            List<CarChangeModel> carChanges =
                                                List<CarChangeModel>.from(
                                                    widget.car.changes);

                                            carChanges.removeAt(index);
                                            widget.onChange?.call(carChanges);
                                          },
                                        ));
                              } else {
                                if (widget.add) {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => ImageChangeWidget(
                                            onSelect: (image, description) {
                                              final change = CarChangeModel(
                                                checklistID: widget.checklistID,
                                                user: widget.user,
                                                value: widget.update,
                                                dx: tapDx, // 🔥 SALVA PROPORCIONAL
                                                dy: tapDy,
                                                description: description,
                                                fileImage: image,
                                                indexImage: indexImage,
                                                date: DateTime.now(),
                                              );

                                              changes.add(change);
                                              List<CarChangeModel> carChanges =
                                                  List<CarChangeModel>.from(
                                                      widget.car.changes);
                                              carChanges.add(change);

                                              widget.onChange?.call(carChanges);
                                            },
                                          ));
                                }
                              }
                            },
                            child: paintChangesImage(
                                key: paintKey,
                                changes: changes,
                                checklistID: widget.checklistID,
                                heightImage: heightImage,
                                widthImage: widthImage),
                            // child: CustomPaint(
                            //   key: paintKey,
                            //   foregroundPainter: MyCustomPainter(
                            //       changes: changes,
                            //       checklistID: widget.checklistID),
                            //   child: Container(
                            //     height: heightImage, // 🔒 TAMANHO FIXO
                            //     width: widthImage,
                            //     color: Colors.transparent,
                            //   ),
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : (widget.register)
                  ? InkWell(
                      onTap: () {
                        Core.pickerImage(
                                context: context,
                                height: heightImage,
                                width: widthImage)
                            .then((data) {
                          if (data != null) {
                            setState(() {
                              images[indexImage] = data;
                              widget.onChangeImages?.call(images);
                            });
                          }
                        });
                      },
                      child: Column(
                        spacing: 5,
                        children: [
                          const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                          Text(
                            'Clique para adicionar imagem',
                            style: Constants.subtitleHint,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                          Text(
                            'Sem imagem',
                            style: Constants.subtitleHint,
                          ),
                        ],
                      ),
                    ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: (widget.register && hasImageChange(image)),
            child: Align(
              alignment: Alignment.centerRight,
              child: Card(
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.all(5),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertMessage(
                                        title: '',
                                        message:
                                            'Deseja alterar a imagem da vista ?',
                                        titleOK: 'Sim',
                                        cancel: true,
                                        onPressedCancel: () =>
                                            Navigator.of(context).pop(false),
                                        onPressedOK: () => Navigator.of(context)
                                            .pop(true))).then((value) {
                                  if (value ?? false) {
                                    Core.pickerImage(
                                            context: context,
                                            height: heightImage,
                                            width: widthImage)
                                        .then((data) {
                                      if (data != null) {
                                        setState(() {
                                          images[indexImage] = data;
                                          widget.onChangeImages?.call(images);

                                          List<CarChangeModel> carChanges =
                                              List<CarChangeModel>.from(
                                                  widget.car.changes);

                                          carChanges.removeWhere((e) =>
                                              e.indexImage == indexImage);
                                          widget.onChange?.call(carChanges);
                                        });
                                      }
                                    });
                                  }
                                });
                              },
                              child: Icon(
                                MdiIcons.imageEdit,
                                size: 20,
                                color: Constants.primary,
                              )),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          child: InkWell(
                              onTap: changes.isNotEmpty
                                  ? () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertMessage(
                                              title: '',
                                              message:
                                                  'Deseja remover as alterações constada na imagem ?',
                                              titleOK: 'Sim',
                                              cancel: true,
                                              onPressedCancel: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              onPressedOK: () =>
                                                  Navigator.of(context).pop(
                                                      true))).then((value) {
                                        if (value ?? false) {
                                          List<CarChangeModel> carChanges =
                                              List<CarChangeModel>.from(
                                                  widget.car.changes);

                                          carChanges.removeWhere((e) =>
                                              e.indexImage == indexImage);
                                          widget.onChange?.call(carChanges);
                                        }
                                      });
                                    }
                                  : null,
                              child: Icon(
                                MdiIcons.refresh,
                                size: 20,
                                color: changes.isNotEmpty
                                    ? Constants.primary
                                    : Colors.grey,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget imagesChangesView(
    {required BuildContext context, required List<CarChangeModel> changes}) {
  const double height = 120;
  const double width = 170;

  final list = List<CarChangeModel>.from(changes);
  list.sort((a, b) => b.date.compareTo(a.date));

  return SingleChildScrollView(
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.black45,
                child: Icon(
                  MdiIcons.close,
                  size: 20,
                  color: Colors.white,
                )),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: List.generate(list.length, (index) {
            final change = list[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(5),
                      child: change.fileImage != null
                          ? Image.memory(
                              change.fileImage!,
                              height: height,
                              width: width,
                              fit: BoxFit.fill,
                            )
                          : kIsWeb
                              ? Image.network(
                                  change.image?.url ?? '',
                                  height: height,
                                  width: width,
                                  fit: BoxFit.fill,
                                )
                              : CachedNetworkImage(
                                  imageUrl: change.image?.url ?? '',
                                  height: height,
                                  width: width,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: CircularProgressIndicator(
                                        color: Constants.primary,
                                        value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                          child: Icon(
                                    Icons.error,
                                    size: 60.0,
                                  )),
                                  fit: BoxFit.fill,
                                ),
                    ),
                    Positioned(
                      top: 5,
                      left: 5,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black45,
                        child: Text(
                          ((list.length) - index).toString().padLeft(2, '0'),
                          style:
                              Constants.subtitle.copyWith(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        change.description,
                        style: Constants.title,
                      ),
                      Text(
                        "${change.user.graduation} ${change.user.name} - ${change.user.registration}",
                        style: Constants.subtitleHint,
                      ),
                      Text(
                        Core.formatDate(change.date, largeDay: true),
                        style: Constants.subtitleHint,
                      ),
                    ],
                  ),
                )
              ],
            );
          }).expand((widget) => [widget, const Divider()]).toList()
            ..removeLast(),
        )
      ],
    ),
  );
}

Widget menuView({required int indexImage, required Function(int) onChange}) {
  return Card(
    child: IntrinsicHeight(
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(5.0),
        child: Row(
          spacing: 5,
          children: [
            Expanded(
              child: InkWell(
                  onTap: () => onChange(0),
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.chevronDown,
                        size: 20,
                        color:
                            indexImage == 0 ? Constants.primary : Colors.grey,
                      ),
                      Icon(
                        MdiIcons.car,
                        size: 20,
                        color:
                            indexImage == 0 ? Constants.primary : Colors.grey,
                      ),
                    ],
                  )),
            ),
            const VerticalDivider(),
            Expanded(
              child: InkWell(
                  onTap: () => onChange(1),
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.chevronRight,
                        size: 20,
                        color:
                            indexImage == 1 ? Constants.primary : Colors.grey,
                      ),
                      Icon(
                        MdiIcons.car,
                        size: 20,
                        color:
                            indexImage == 1 ? Constants.primary : Colors.grey,
                      ),
                    ],
                  )),
            ),
            const VerticalDivider(),
            Expanded(
              child: InkWell(
                  onTap: () => onChange(2),
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.car,
                        size: 20,
                        color:
                            indexImage == 2 ? Constants.primary : Colors.grey,
                      ),
                      Icon(
                        MdiIcons.chevronLeft,
                        size: 20,
                        color:
                            indexImage == 2 ? Constants.primary : Colors.grey,
                      ),
                    ],
                  )),
            ),
            const VerticalDivider(),
            Expanded(
              child: InkWell(
                  onTap: () => onChange(3),
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.car,
                        size: 20,
                        color:
                            indexImage == 3 ? Constants.primary : Colors.grey,
                      ),
                      Icon(
                        MdiIcons.chevronUp,
                        size: 20,
                        color:
                            indexImage == 3 ? Constants.primary : Colors.grey,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget paintChangesImage(
    {Key? key,
    required List<CarChangeModel> changes,
    String? checklistID,
    required double heightImage,
    required double widthImage}) {
  return Stack(
    key: key,
    children: [
      SizedBox(
        height: heightImage, // 🔒 TAMANHO FIXO
        width: widthImage,
        // color: Colors.transparent,
      ),
      ...List.generate(changes.length, (index) {
        final change = changes[index];

        final px = change.dx * widthImage;
        final py = change.dy * heightImage;

        final isToday = ((change.checklistID == null) && (change.value == true))
            ? false
            : (change.checklistID == checklistID)
                ? true
                : false;

        return Positioned(
          left: px - 12,
          top: py - 12,
          child: CircleAvatar(
            radius: 12,
            backgroundColor: isToday ? Colors.red : Colors.blue,
            child: Text(
              (index + 1).toString().padLeft(2, '0'),
              style: Constants.subtitle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ),
        );
      }),
    ],
  );
}

class MyCustomPainter extends CustomPainter {
  final List<CarChangeModel> changes;
  final String? checklistID;

  MyCustomPainter({this.checklistID, required this.changes});

  @override
  void paint(Canvas canvas, Size size) {
    var paintOld = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round;

    var paintToday = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round;

    for (final change in changes) {
      // 🔥 CONVERTE DE PROPORCIONAL PARA PIXEL
      final px = change.dx * size.width;
      final py = change.dy * size.height;

      final isToday = ((change.checklistID == null) && (change.value == true))
          ? false
          : (change.checklistID == checklistID)
              ? true
              : false;

      canvas.drawCircle(
        Offset(px, py),
        6,
        isToday ? paintToday : paintOld,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
