//Adicionar imagem e descrição.
import 'package:bsu_control/core/constants.dart';
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
                widget.change.fileImage != null
                    ? Image.memory(
                        widget.change.fileImage!,
                        height: 250,
                        width: 350,
                        fit: BoxFit.cover,
                      )
                    : kIsWeb
                        ? Image.network(
                            widget.change.image?.url ?? '',
                            height: 250,
                            width: 350,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            height: 250,
                            width: 350,
                            imageUrl: widget.change.image?.url ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox(
                                height: 60.0,
                                width: 60.0,
                                child:
                                    Center(child: CircularProgressIndicator())),
                            errorWidget: (context, url, error) => const Center(
                                child: Icon(
                              Icons.error,
                              size: 60.0,
                            )),
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
                                  widget.onRemove();
                                  Navigator.of(context).pop();
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
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.change.description,
                    style: Core.title,
                  ),
                  Text(
                    "${widget.change.user.graduation} ${widget.change.user.name} - ${widget.change.user.registration}",
                    style: Core.subtitleHint,
                  ),
                  Text(
                    Core.formatDate(widget.change.date, largeDay: true),
                    style: Core.subtitleHint,
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
