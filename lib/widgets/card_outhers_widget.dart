import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/outher_changes_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CardOutherChange extends StatelessWidget {
  final OtherChangeModel outher;
  final Function()? onDelete;
  const CardOutherChange({Key? key, required this.outher, this.onDelete})
      : super(key: key);

  Widget image(
      {required OtherChangeModel value,
      double heigth = 100,
      double width = 140}) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(5),
      child: value.fileImage != null
          ? Image.memory(
              value.fileImage!,
              height: heigth,
              width: width,
              fit: BoxFit.contain,
            )
          : kIsWeb
              ? Image.network(
                  value.image?.url ?? '',
                  height: heigth,
                  width: width,
                  fit: BoxFit.contain,
                )
              : CachedNetworkImage(
                  imageUrl: value.image?.url ?? '',
                  height: heigth,
                  width: width,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                        color: Constants.primary,
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => const Center(
                      child: Icon(
                    Icons.error,
                    size: 60.0,
                  )),
                  fit: BoxFit.contain,
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        contentPadding: const EdgeInsets.all(5),
                        content: Stack(
                          children: [
                            image(value: outher, heigth: 300, width: 450),
                            Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                    style: IconButton.styleFrom(
                                        backgroundColor: Colors.black45),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.white,
                                    )))
                          ],
                        ),
                      ));
            },
            child:
                Tooltip(message: 'Abrir imagem', child: image(value: outher))),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                outher.description,
                style: Constants.title,
              ),
              Text(
                Core.formatDate(outher.date, largeDayHour: true),
                style: Constants.subtitleHint,
              )
            ],
          ),
        ),
        (onDelete != null)
            ? IconButton(
                onPressed: () => onDelete?.call(),
                icon: const Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.grey,
                ))
            : Container()
      ],
    );
  }
}
