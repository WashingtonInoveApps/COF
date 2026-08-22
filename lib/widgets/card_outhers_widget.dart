import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/outher_changes_model.dart';
import 'package:bsu_control/widgets/alert_message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CardOutherChange extends StatelessWidget {
  final bool admin;
  final String? checklistID;
  final OtherChangeModel other;
  final Function()? onDelete;

  const CardOutherChange({
    Key? key,
    required this.other,
    this.onDelete,
    this.checklistID,
    this.admin = false,
  }) : super(key: key);

  Widget image(
      {required OtherChangeModel value,
      double heigth = 100,
      double width = 140}) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(5),
      child: value.image.data != null
          ? Image.memory(
              value.image.data!,
              height: heigth,
              width: width,
              fit: BoxFit.cover,
            )
          : kIsWeb
              ? Image.network(
                  value.image.url,
                  height: heigth,
                  width: width,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: value.image.url,
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
                  fit: BoxFit.cover,
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
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                image(value: other, heigth: 400, width: 400),
                                Positioned(
                                    top: 5,
                                    right: 5,
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
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsetsGeometry.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    other.description,
                                    style: Constants.title,
                                  ),
                                  Text(
                                    Core.formatDate(other.date,
                                        largeDayHour: true),
                                    style: Constants.titleHint,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
            },
            child: Tooltip(
                message: 'Abrir imagem',
                child: Stack(
                  children: [
                    image(value: other),
                    const Positioned(
                        bottom: 5,
                        left: 10,
                        child: Icon(
                          Icons.image_search_rounded,
                          size: 30,
                          color: Colors.black45,
                        ))
                  ],
                ))),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                other.description,
                style: Constants.title,
              ),
              Core.boldFirstName(
                  name: other.user.name,
                  fullName: other.user.fullname,
                  style: Constants.titleHint),
              Text(
                Core.formatDate(other.date, largeDayHour: true),
                style: Constants.subtitleHint,
              ),
            ],
          ),
        ),
        if ((onDelete != null && other.checklistID == checklistID ||
                (other.image.data?.isNotEmpty ?? false)) ||
            (onDelete != null && admin))
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertMessage(
                          message: 'Deseja deletar esse registro ?',
                          cancel: true,
                          titleOK: 'Sim',
                          onPressedOK: () => Navigator.of(context).pop(true),
                          onPressedCancel: () =>
                              Navigator.of(context).pop(false),
                        )).then((result) {
                  if (result ?? false) {
                    onDelete?.call();
                  }
                });
              },
              icon: const Icon(
                Icons.delete,
                size: 20,
                color: Colors.grey,
              )),
      ],
    );
  }
}
