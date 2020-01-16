import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  final Function onPressed;

  CustomFloatingButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(
          Icons.camera_alt,
          size: 60,
        ),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
