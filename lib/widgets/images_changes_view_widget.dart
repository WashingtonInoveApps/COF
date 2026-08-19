// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bsu_control/core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:bsu_control/model/car_changes_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../core/constants.dart';

class ImagesChangesViewWidget extends StatelessWidget {
  final List<CarChangeModel> changes;
  const ImagesChangesViewWidget({
    Key? key,
    required this.changes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(5),
                        child: change.image?.data != null
                            ? Image.memory(
                                change.image!.data!,
                                // height: height,
                                width: width,
                                fit: BoxFit.fill,
                              )
                            : kIsWeb
                                ? Image.network(
                                    change.image?.url ?? '',
                                    // height: height,
                                    width: width,
                                    fit: BoxFit.fill,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: change.image?.url ?? '',
                                    // height: height,
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
                          radius: 13,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Constants.primary,
                            child: Text(
                              ((list.length) - index)
                                  .toString()
                                  .padLeft(2, '0'),
                              style: Constants.subtitle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          change.description,
                          style: Constants.title,
                        ),
                        Core.boldFirstName(
                            name: change.user.name,
                            fullName: change.user.fullname,
                            style: Constants.titleHint),
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
}
