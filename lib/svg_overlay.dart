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
  final Alignment alignment;

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
    this.alignment= Alignment.topLeft,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;


        // Compute the position based on the screen size and position factor
        final left = svgPosition.dx * screenWidth;
        final top = svgPosition.dy * screenHeight;

        Rect pathBounds = parseSvgPathData(svgPath[0].path).getBounds();

        developer.log("SVG: $svgImage", name:"DEBUGGER");
        developer.log("Computed SVG Scale - Width: ${svgWidth * screenWidth / pathBounds.width}, Height: ${svgHeight * screenHeight / pathBounds.height}", name: "DEBUGGER");
        developer.log("Screen Dimensions - Width: $screenWidth, Height: $screenHeight", name: "DEBUGGER");
        developer.log("Path Bounds - Width: ${pathBounds.width}, Height: ${pathBounds.height}", name: "DEBUGGER");
        developer.log("");

        return Stack(
          children: [
            // Positioned SVG with Debug Border
            Positioned(
              left: left,
              top: top,
              child: FractionalTranslation(
                translation: svgAnchor,
                child: Transform(
                  alignment: alignment,
                  transform: Matrix4.identity()
                    ..scale(svgWidth * 1.065 * screenWidth/pathBounds.width, 
                            svgHeight * 1.166 * screenHeight/pathBounds.height),
                  child: GestureDetector(
                    onTap: onTap,
                    child: ClipPath(
                      clipper: Clipper(svgPath: svgPath[0].path),
                      child: SvgPicture.asset(
                        svgImage,
                        fit: BoxFit.fill,
                        ),
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