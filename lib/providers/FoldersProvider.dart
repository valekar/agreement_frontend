import 'package:agreement_frontend/models/model.dart';
import 'package:flutter/foundation.dart';
//import 'package:path_provider/path_provider.dart';
import 'dart:developer';
//import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import '../constants/constants.dart';
import '../exceptions/SQLException.dart';

class FoldersProvider with ChangeNotifier {
  List<Folder> _folders;

  List<Folder> get folders {
    return [..._folders];
  }

  Future<String> createFolderAndSaveImage(Uint8List imageBytes) async {
    try {
      final imageName =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.png";

      //String imagePath = await _createFileFromBytes(imageArray, imageName);

      final result = await Folder(
              picture: imageBytes,
              title: DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.now()),
              createdAt: DateTime.now().millisecondsSinceEpoch,
              updatedAt: DateTime.now().millisecondsSinceEpoch)
          .save();

      if (result > 0) {
        await _saveImage(result, imageBytes, imageName);
      } else {
        throw SQLException(Constants.ERROR_SAVE_FOLDER);
      }
    } catch (err) {
      throw SQLException(err);
    }
    return Constants.SUCCESS;
  }

  Future<void> fetchFolders() async {
    final folderList = await Folder().select().toList();
    _folders = folderList;
    notifyListeners();
  }

  Future _saveImage(int result, Uint8List imageBytes, String imageName) async {
    final imageResult = await Picture(
            folderId: result,
            picture: imageBytes,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
            title: imageName)
        .save();

    if (imageResult > 0) {
      log(Constants.SUCCESS_MESSAGE_IMAGE);
    } else {
      throw SQLException(Constants.ERROR_SAVE_IMAGE);
    }
  }

  // Future<String> _createFileFromBytes(final bytes, final imageName) async {
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   String fullPath = "$dir/$imageName";
  //   log("storing at $fullPath");
  //   File file = File(fullPath);
  //   await file.writeAsBytes(bytes);
  //   log(file.path);

  //   //final result = await ImageGallerySaver.saveImage(bytes);
  //   //log(result);
  //   return file.path;
  // }

  Future<Folder> findFolderById(String id) async {
    final folder = await Folder().getById(int.parse(id));
    return folder;
  }

  Future<String> saveImageWithFolderId(
      int folderId, Uint8List imageBytes) async {
    try {
      final imageName =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.png";
      //String imagePath = await _createFileFromBytes(imageArray, imageName);
      await _saveImage(folderId, imageBytes, imageName);
    } catch (err) {
      throw SQLException(err);
    }
    return Constants.SUCCESS;
  }
}
