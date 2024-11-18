import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SvgBoundaryPainter extends CustomPainter {
  final ui.Picture svgPicture;

  SvgBoundaryPainter(this.svgPicture);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outlinePaint = Paint()
      ..color = Colors.red // Customize the outline color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw the SVG itself
    canvas.drawPicture(svgPicture);

    // You can add any additional boundary or outline drawing here as needed
    canvas.drawRect(Offset.zero & size, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
