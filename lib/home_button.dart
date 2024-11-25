import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pause/main.dart';


class ExpandingSvgButton extends StatefulWidget {
  final String svgPath;

  const ExpandingSvgButton({
    super.key, 
    this.svgPath = 'lib/assets/clickableShapes/homeButton.svg',
  });

  @override
  ExpandingSvgButtonState createState() => ExpandingSvgButtonState();
}

class ExpandingSvgButtonState extends State<ExpandingSvgButton> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void _navigateToHomePage(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(title:"Pause", screenHeight: screenHeight, screenWidth: screenWidth,),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Define the fade-out effect using an opacity animation
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Positioned(
      bottom: height/100,
      left:  width / 2,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: GestureDetector(
          onTap: () => _navigateToHomePage(context),
            child: SvgPicture.asset(
              widget.svgPath,
              width: height/13,
              height: height/13,
          ),
        ),
      ),
    );
  }
}
