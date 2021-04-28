import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

File _image;
final picker = ImagePicker();

Future _imgFromCamera() async {
  final pickedFile = await picker.getImage(source: ImageSource.camera);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
}

Future uploadImage() async {
  final pickedFile = await picker.getImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
}

Future showPicker(context) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return SafeArea(
        child: Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Photo Library'),
                  onTap: () {
                    uploadImage();
                    Navigator.of(context).pop();
                  }),
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text('Camera'),
                onTap: () {
                  _imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
