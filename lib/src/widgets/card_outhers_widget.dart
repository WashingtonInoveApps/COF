import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CardOutherChange extends StatelessWidget {
  final ChecklistOutherChange outher;
  final Function()? onDelete;
  const CardOutherChange({Key? key, required this.outher, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(5),
          child: outher.fileImage != null
              ? Image.memory(
                  outher.fileImage!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
              : kIsWeb
                  ? Image.network(
                      outher.image?.url ?? '',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: outher.image?.url ?? '',
                      height: 100,
                      width: 100,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
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
        ),
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
