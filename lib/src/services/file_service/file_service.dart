import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FileServiceX {
  static List<String> images = ["jpg", "jpeg", "png", "gif", "bmp", "tiff", "heif", "heic", "webp"];
  static List<String> videos = ["mp4", "avi", "mkv", "mov", "wmv", "webm", "3gp", "m4v"];
  static List<String> pdf = ["pdf"];

  static Future<bool> _checkStoragePermission() async {
    if (Platform.isIOS) return true;

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) return true;

      final status = await Permission.storage.status;
      if (status == PermissionStatus.granted) return true;

      final result = await Permission.storage.request();
      return result == PermissionStatus.granted;
    }

    throw StateError('unknown platform');
  }

  static Future<void> saveImageToGallary(File file) async {
    if (!await _checkStoragePermission()) return;
    final filename = file.path.split("/").last;
    File("/storage/emulated/0/Download/$filename")
      ..createSync(recursive: true)
      ..writeAsBytesSync(file.readAsBytesSync());
  }

  static Future<String?> pickGallaryImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (picked == null) return null;
    return picked.path;
  }

  static Future<FileX?> pickImage({int limit = 5}) async {
    final picked = await ImagePicker().pickImage(imageQuality: 50, source: ImageSource.gallery);
    if (picked == null) return null;
    return FileX(await picked.readAsBytes(), picked.path);
  }

  static Future<List<FileX>?> pickImages({int limit = 5}) async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 50, limit: limit);
    return Future.wait(picked.map((e) async => FileX(await e.readAsBytes(), e.path)));
  }
}

class FileX {
  final Uint8List? bytes;
  final String path;

  const FileX(this.bytes, this.path);

  FileX copyWith({Uint8List? bytes, String? path}) => FileX(bytes ?? this.bytes, path ?? this.path);

  @override
  String toString() => 'FileX(bytes: $bytes, path: $path)';
}
