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
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _yValueAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Both animations are driven by the same controller to play in parallel
    _sizeAnimation = Tween<double>(begin: 1.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _yValueAnimation = Tween<double>(begin: 0.0, end: -30.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  void _navigateToHomePage(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    _controller.forward().then((_) {
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
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _sizeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _yValueAnimation.value),
                    child: SvgPicture.asset(
                      widget.svgPath,
                      width: height/13, // Original width; scaling takes effect
                      height: height/13, // Original height; scaling takes effect
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
