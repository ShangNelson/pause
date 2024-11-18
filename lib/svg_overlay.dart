import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_drawing/path_drawing.dart';
import 'dart:developer' as developer;

class SvgOverlay extends StatelessWidget {
  final String svgImage;
  final List<SvgPath> svgPath;
  final String? imagePath;
  final String text;
  final double svgWidth;
  final double svgHeight;
  final Offset svgPosition;
  final Offset? imagePosition;
  final Offset textPosition;
  final Offset svgAnchor;
  final Offset textAnchor;
  final Offset imageAnchor;
  final double? textSize;
  final double? passedScreenHeight;
  final double? passedScreenWidth;
  final VoidCallback? onTap;

  const SvgOverlay({
    super.key,
    required this.svgImage,
    required this.svgPath,
    this.imagePath,
    required this.text,
    required this.svgWidth,
    required this.svgHeight,
    required this.svgPosition,
    this.textSize,
    this.imagePosition,
    required this.textPosition,
    this.onTap,
    this.svgAnchor = const Offset(0,0),
    this.textAnchor = const Offset(0,0),
    this.imageAnchor = const Offset(0,0),
    this.passedScreenHeight = 0,
    this.passedScreenWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = (passedScreenWidth != 0) ? passedScreenWidth : constraints.maxWidth;
        final screenHeight = (passedScreenHeight != 0) ? passedScreenHeight : constraints.maxHeight;
        developer.log("Screen Width: $screenWidth", name:"DEBUGGER");
        return Stack(
          children: [
            // Positioned SVG with Debug Border
            Positioned(
              left: screenWidth! * svgPosition.dx,
              top: screenHeight! * svgPosition.dy,
              child: FractionalTranslation(
                translation: svgAnchor,
                child: Transform.scale(
                  scaleX: svgWidth, // Custom scale factor for width
                  scaleY: svgHeight, // Custom scale factor for height
                  child: GestureDetector(
                    onTap: onTap,
                    child: ClipPath(
                      clipper: Clipper(svgPath: svgPath[0].path),  
                      child: SvgPicture.asset(svgImage),
                    ),
                  ),
                ),
              ),
            ),

            // Overlay Image with Debug Border
            if (imagePath != null && imagePosition != null)
              Positioned(
                left: screenWidth * imagePosition!.dx,
                top: screenHeight * imagePosition!.dy,
                child: FractionalTranslation(
                  translation: imageAnchor,
                  child: GestureDetector(
                    onTap: onTap,
                    child: Image.asset(imagePath!),
                  ),
                ),
              ),

            // Overlay Text with Debug Border
            Positioned(
              left: screenWidth * textPosition.dx,
              top: screenHeight * textPosition.dy,
              child: FractionalTranslation(
                translation: textAnchor,
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: textSize ?? 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SvgPath {
  final String id;
  final String path;
  final String color;
  final String name;

  const SvgPath({
    required this.id,
    required this.path,
    required this.color,
    required this.name,
  });
}

class Clipper extends CustomClipper<Path> {
  Clipper({
    required this.svgPath,
  });

  String svgPath;

  @override
  Path getClip(Size size) {
    var path = parseSvgPathData(svgPath);

    final Matrix4 matrix4 = Matrix4.identity();


    return path.transform(matrix4.storage);
  }


  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}