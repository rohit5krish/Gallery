import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  List<String> pathLists = [];
  @override
  void initState() {
    var imgPathList = displayImages();
    pathLists = imgPathList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gallery'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await takePhoto();
            var imgPathList = displayImages();
            setState(() {
              pathLists = imgPathList;
            });
          },
          child: Icon(Icons.camera_alt),
        ),
        body: pathLists == null
            ? Center(child: Text('NO Images'))
            : GridView.builder(
                itemCount: pathLists.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return Container(
                    height: 150,
                    width: 150,
                    child: Card(
                      child: Image.file(File(pathLists[index])),
                    ),
                  );
                }));
  }

  Future takePhoto() async {
    if (await _requestPermission(Permission.storage)) {
      XFile? img = await ImagePicker().pickImage(source: ImageSource.camera);

      var dir = await getDirectory();

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      if (await dir.exists()) {
        final filename = basename(img!.path);
        File imgfilenam = File(img.path);
        final File newimg = await imgfilenam.copy('${dir.path}/$filename');
        // await ImageGallerySaver.saveFile(newimg.path);
      }
    } else {
      return;
    }

    // if (img == null) {
    //   return;
    // }
    // int i = 0;
    // final appDir = await getExternalStorageDirectory();
    // final myImagePath = '${appDir!.path}/ImagesFolder';
    // final myImgDir = await Directory(myImagePath).create();
    // var compresimg = File("$myImagePath/image_$i.jpg")
    //   ..writeAsBytesSync(img.encodeJpg());

    // final fileName = basename(img.path);
    // final savedImage = await File(img.path).copy('${appDir.path}/$fileName');
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  getDirectory() async {
    if (await _requestPermission(Permission.storage)) {
      Directory dir;
      dir = (await getExternalStorageDirectory())!;

      String newpath = "";

      List<String> folders = dir.path.split("/");
      for (int i = 1; i < folders.length; i++) {
        String fold = folders[i];

        if (fold != "Android") {
          newpath += "/" + fold;
        } else {
          break;
        }
      }
      newpath = newpath + "/MyGalleryImages";
      dir = Directory(newpath);
      return dir;
    }
    return null;
  }

  checkForImages() async {
    Directory imgDir = await getDirectory();
    if (!await imgDir.exists()) {
      await imgDir.create(recursive: true);
    } else {
      return;
    }
  }

  List<String> displayImages() {
    // Directory imgDir = await getDirectory();
    checkForImages();
    final Directory imgDir = Directory('/storage/emulated/0/MyGalleryImages');
    List<String> imagesList = imgDir
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".jpg"))
        .toList();
    return imagesList;
  }
}
