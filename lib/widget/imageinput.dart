import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.imagechange});
  final Function imagechange;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedimage;
  void _takepicture() async {
    final imagex = ImagePicker();
    XFile? result = await imagex.pickImage(source: ImageSource.camera);
    if (result != null) {
      setState(() {
        _selectedimage = File(result.path);
      });
      widget.imagechange(_selectedimage);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: () => _takepicture(),
        icon: Icon(Icons.camera),
        label: const Text("Take Picture"));
    if (_selectedimage != null) {
      setState(() {
        content = Image.file(
          _selectedimage!,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      });
    }
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Theme.of(context).primaryColor.withOpacity(0.2))),
      alignment: Alignment.center,
      child: content,
    );
  }
}
