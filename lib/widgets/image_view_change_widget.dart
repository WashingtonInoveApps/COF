//Adicionar imagem e descrição.
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/widgets/alert_message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../model/car_changes_model.dart';

class ImageViewChangeWidget extends StatefulWidget {
  final CarChangeModel change;
  final bool enable;
  final Function() onRemove;
  const ImageViewChangeWidget(
      {Key? key,
      required this.change,
      required this.enable,
      required this.onRemove})
      : super(key: key);

  @override
  State createState() => _ImageViewChangeWidgetState();
}

class _ImageViewChangeWidgetState extends State<ImageViewChangeWidget> {
  Uint8List? image;
  final controller = TextEditingController();

  // double heightImage = 400;
  double widthImage = 500;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(5),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: widget.change.image?.data != null
                      ? Image.memory(
                          widget.change.image!.data!,
                          width: widthImage,
                          fit: BoxFit.cover,
                        )
                      : kIsWeb
                          ? Image.network(
                              widget.change.image?.url ?? '',
                              width: widthImage,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: widget.change.image?.url ?? '',
                              width: widthImage,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: LinearProgressIndicator(
                                      color: Constants.primary,
                                      value: downloadProgress.progress),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                      child: Icon(
                                Icons.error,
                                size: 60.0,
                              )),
                              fit: BoxFit.cover,
                            ),
                ),
                Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: Row(
                      spacing: 10,
                      children: [
                        widget.enable
                            ? InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                          title: '',
                                          message:
                                              'Deseja remover as alterações constada na imagem ?',
                                          titleOK: 'Sim',
                                          cancel: true,
                                          onPressedCancel: () =>
                                              Navigator.of(context).pop(false),
                                          onPressedOK: () =>
                                              Navigator.of(context)
                                                  .pop(true))).then((result) {
                                    if (result ?? false) {
                                      widget.onRemove();
                                      Navigator.of(context).pop();
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.black45,
                                    child: Icon(
                                      MdiIcons.delete,
                                      size: 20,
                                      color: Colors.white,
                                    )),
                              )
                            : Container(),
                        InkWell(
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
                      ],
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.change.description,
                    style: Constants.title,
                  ),
                  Text(
                    "${widget.change.user.graduation} ${widget.change.user.name} - ${widget.change.user.registration}",
                    style: Constants.subtitleHint,
                  ),
                  Text(
                    Core.formatDate(widget.change.date, largeDay: true),
                    style: Constants.subtitleHint,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
