import 'dart:io';
import 'dart:ui' as ui;

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/file_service/file_service.dart';
import '../widgets/app_text.dart';

Future<FileX?> cropImageDialog(BuildContext context, FileX file) async {
  return await showDialog<FileX?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.9,
            maxHeight: MediaQuery.sizeOf(context).height * 0.7,
          ),
          child: CropImagePage(
            file: file,
            onFinished: (value) => Navigator.of(context).pop<FileX?>(value),
          ),
        ),
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
      );
    },
  );
}

class CropImagePage extends StatefulWidget {
  final FileX file;
  final ValueChanged<FileX> onFinished;
  const CropImagePage({
    super.key,
    required this.file,
    required this.onFinished,
  });

  @override
  State<CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  late final controller = CropController(aspectRatio: 1);
  Image? croppedImage;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> onFinished() async {
    ui.Image bitmap = await controller.croppedBitmap();
    final data = await bitmap.toByteData(format: ui.ImageByteFormat.png);
    final bytes = data!.buffer.asUint8List();
    widget.onFinished(widget.file.copyWith(bytes: bytes));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        AppText(
          croppedImage == null ? 'Crop image' : 'Cropped image',
          fontSize: 16,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 320,
          width: 320,
          child: croppedImage ??
              CropImage(
                controller: controller,
                paddingSize: 10,
                image: Image.file(File(widget.file.path)),
                alwaysMove: true,
                minimumImageSize: 512,
                maximumImageSize: 512,
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF585858)),
              splashRadius: 20,
              onPressed: () => GoRouter.of(context).pop(),
            ),
            TextButton(
              onPressed: () async {
                if (croppedImage != null) return onFinished();
                croppedImage = await controller.croppedImage();
                setState(() {});
              },
              child: AppText(
                croppedImage == null ? 'Crop' : 'Done',
                color: const Color(0xFF585858),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
