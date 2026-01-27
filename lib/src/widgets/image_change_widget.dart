//Adicionar imagem e descrição.
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageChangeWidget extends StatefulWidget {
  final Function(dynamic image, String description) onSelect;
  const ImageChangeWidget({Key? key, required this.onSelect}) : super(key: key);

  @override
  State createState() => _ImageChangeWidgetState();
}

class _ImageChangeWidgetState extends State<ImageChangeWidget> {
  Uint8List? image;
  final controller = TextEditingController();

  double heightImage = 300;
  double widthImage = 400;

  Future<Uint8List?> pickerImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
        uiSettings: [
          AndroidUiSettings(
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile != null) {
        final bytes = await croppedFile.readAsBytes();
        final original = img.decodeImage(bytes)!;

        final resized = img.copyResize(
          original,
          width: widthImage.toInt(),
          height: heightImage.toInt(),
        );

        final result = File("${croppedFile.path}_600x400.png")
          ..writeAsBytesSync(img.encodePng(resized));
        return await result.readAsBytes();
      }
    }

    return null;
  }

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
                    pickerImage().then((result) {
                      if (result != null) {
                        image = result;
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
                    child: image != null
                        ? Image.memory(
                            image!,
                            width: widthImage,
                            height: heightImage,
                            fit: BoxFit.contain,
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
                                  style: Core.subtitleHint,
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
                        if (image != null) {
                          widget.onSelect(image!, controller.text);
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text("ADICIONAR", style: Core.titleButton)))
            ],
          ),
        ),
      ),
    );
  }
}
