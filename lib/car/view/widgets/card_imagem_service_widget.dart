import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../model/file_model.dart';

class CardServiceImageWidget extends StatelessWidget {
  final FileModel value;
  final Function()? onDelete;
  final Function()? onView;
  final Function()? onClose;
  final double? heigth;
  final double? width;

  const CardServiceImageWidget({
    Key? key,
    required this.value,
    this.onDelete,
    this.heigth = 200,
    this.width = 200,
    this.onView,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onView,
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(5),
            child: value.data != null
                ? Image.memory(
                    value.data!,
                    height: heigth,
                    width: width,
                    fit: BoxFit.cover,
                  )
                : kIsWeb
                    ? Image.network(
                        value.url,
                        height: heigth,
                        width: width,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: value.url,
                        height: heigth,
                        width: width,
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
                        fit: BoxFit.cover,
                      ),
          ),
        ),
        if (onView != null)
          const Positioned(
              bottom: 5,
              left: 10,
              child: Icon(
                Icons.image_search_rounded,
                size: 30,
                color: Colors.black45,
              )),
        Positioned(
          top: 10,
          right: 10,
          child: Row(
            spacing: 10,
            children: [
              if (onDelete != null)
                InkWell(
                  onTap: onDelete,
                  child: const CircleAvatar(
                    backgroundColor: Colors.black45,
                    radius: 20,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              if (onClose != null)
                InkWell(
                  onTap: onClose,
                  child: const CircleAvatar(
                    backgroundColor: Colors.black45,
                    radius: 20,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
