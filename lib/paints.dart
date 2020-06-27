import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  BoundingBoxPainter({
    @required this.rect,
    @required this.imageFile,
  });

  List<Rect> rect;
  var imageFile;

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    for (Rect rectangle in rect) {
      canvas.drawRect(
        rectangle,
        Paint()
          ..color = Colors.yellow
          ..strokeWidth = 6.0
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
