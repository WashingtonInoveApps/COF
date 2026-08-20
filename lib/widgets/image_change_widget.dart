//Adicionar imagem e descrição.
import 'dart:typed_data';

import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/file_model.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:uuid/uuid.dart';

import 'textfield_widget.dart';

class ImageChangeWidget extends StatefulWidget {
  final CropAspectRatio? aspectRatio;
  final Function(FileModel image, String description) onSelect;

  const ImageChangeWidget({
    Key? key,
    required this.onSelect,
    this.aspectRatio = const CropAspectRatio(ratioX: 3, ratioY: 2),
  }) : super(key: key);

  @override
  State createState() => _ImageChangeWidgetState();
}

class _ImageChangeWidgetState extends State<ImageChangeWidget> {
  Uint8List? data;
  final controller = TextEditingController();

  double widthImage = 400;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widthImage,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: () async {
                    Core.pickerImage(
                            context: context, aspectRatio: widget.aspectRatio)
                        .then((result) {
                      if (result != null) {
                        data = result;
                        setState(() {});
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade200),
                    child: data != null
                        ? Image.memory(
                            data!,
                            width: widthImage,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              spacing: 5,
                              children: [
                                const Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Clique para adicionar imagem',
                                  style: Constants.subtitleHint,
                                ),
                              ],
                            ),
                          ),
                  )),
              const SizedBox(
                height: 10.0,
              ),
              FieldText(
                controller: controller,
                hint: "Descrição",
                label: 'Descrição',
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                  height: 45.0,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (data != null) {
                          widget.onSelect(
                              FileModel(
                                  id: const Uuid().v4(),
                                  name: '',
                                  url: '',
                                  path: '',
                                  data: data!),
                              controller.text);
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text("Adicionar", style: Constants.titleButton)))
            ],
          ),
        ),
      ),
    );
  }
}
