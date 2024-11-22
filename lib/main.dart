import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_button.dart' as home_button;
import 'breathe.dart' as breathe_chain;
import 'five_senses.dart' as five_senses;
import 'svg_overlay.dart' as svg_overlay;
import 'thoughts_on_trial.dart' as thoughts;
import 'dart:async';
import 'package:xml/xml.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Menco',
        useMaterial3: true,
      ),
      home: const SplashScreenState(),
      routes: {
        '/home': (context) => HomePage(title: "Pause", screenHeight: screenHeight, screenWidth: screenWidth,),
      },
    );
  }
}

class SplashScreenState extends StatefulWidget {
  const SplashScreenState({super.key});
  @override
  SplashScreen createState() => SplashScreen();
}

class SplashScreen extends State<SplashScreenState> {
  
  @override 
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    Future.delayed(const Duration(milliseconds: 2), () {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomePage(title: "Pause", screenHeight: screenHeight, screenWidth: screenWidth,),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(seconds: 1),
        ),
      );
    });
    return Scaffold(
      backgroundColor: const Color(0xFFE5AD5A),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              left: screenWidth/2,
              top: screenHeight/2-32,
              child: const FractionalTranslation(
                translation: Offset(-0.5, -0.5),
                child: Text(
                  "Welcome to",
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            Positioned(
              left: screenWidth/2,
              top: screenHeight/2+32,
              child: const FractionalTranslation(
                translation: Offset(-0.5, -0.5),
                child: Text(
                  "Pause",
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight/3,
              left: screenWidth/2,
              child: FractionalTranslation(
                translation: const Offset(-0.5, -0.5),
                child: SvgPicture.asset(
                  'lib/assets/clickableShapes/homeButton.svg',
                  height:100,
                  width:100,
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const HomePage({super.key, required title, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDD4DA),
      body: Center(
        child: Stack(
          children: [

            FutureBuilder(
              future: loadSvgImage(svgImage: 'lib/assets/clickableShapes/rectangle.svg',), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: 'lib/assets/clickableShapes/rectangle.svg',
                    svgPath: snapshot.data!,
                    text: "Help", 
                    svgWidth: 1, 
                    svgHeight: 1/8,
                    alignment: Alignment.bottomLeft,
                    svgPosition: const Offset(0, 1), 
                    svgAnchor: const Offset(0, -1),
                    textPosition: const Offset(0.5, 0.9),
                    textAnchor: const Offset(-0.5, -0.5),
                    onTap: () => _navigateToHelpPage(context),
                  );
                }
              }
            ),

            //Body Scan Section
            FutureBuilder<List<svg_overlay.SvgPath>>(
              future: loadSvgImage(svgImage: 'lib/assets/clickableShapes/bodyScan.svg'), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(  
                    svgImage: 'lib/assets/clickableShapes/bodyScan.svg',
                    svgPath: snapshot.data!,
                    svgWidth: 1,
                    svgHeight: 160/800,
                    svgPosition: const Offset(0, 0),
                    svgAnchor: const Offset(0, 0),
                    textPosition: const Offset(.5, .08),
                    imagePosition: const Offset(0.2, 0.1),
                    textAnchor: const Offset(-0.5, 0),
                    imageAnchor: const Offset(-0.5, -0.5),
                    text: "Body Scan",
                    imagePath: 'lib/assets/icons/PersonArmsSpread.png',
                    onTap: () => _navigateToBodyScanPage(context),
                  );
                }
              }
            ),
            
            FutureBuilder(
              future: loadSvgImage(svgImage: 'lib/assets/clickableShapes/5Senses.svg',), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: 'lib/assets/clickableShapes/5Senses.svg',
                    svgPath: snapshot.data!,
                    svgWidth: 284/360,
                    svgHeight: 169/800,
                    svgPosition: const Offset(0, 0.127),
                    textPosition: const Offset(0.4, 0.25),
                    imagePosition: const Offset(0.14, 0.275),
                    textAnchor: const Offset(-0.5, 0),
                    imageAnchor: const Offset(-0.5, -0.5),
                    text: "5 Senses",
                    imagePath: 'lib/assets/icons/HandTap.png',
                    onTap: () => _navigateToCentralPage(context, "5 Senses", "Take a few moments to observe your surroundings", const Color(0xFF5491A3), () => _navigateToFiveSensesPage(context)),
                  );
                }
              }
            ),
            
            
            FutureBuilder(
              future: loadSvgImage(svgImage: 'lib/assets/clickableShapes/breathe.svg',), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: 'lib/assets/clickableShapes/breathe.svg',
                    svgPath: snapshot.data!,
                    svgWidth: 187/360,
                    svgHeight: 325/800,
                    svgPosition: const Offset(1, 0.088),
                    textPosition: const Offset(0.82, 0.37),
                    imagePosition: const Offset(0.82, 0.32),
                    textAnchor: const Offset(-0.5, 0),
                    alignment: Alignment.topRight,
                    imageAnchor: const Offset(-0.5, -0.5),
                    svgAnchor: const Offset(-1, 0),
                    text: "Breathe",
                    imagePath: 'lib/assets/icons/Wind.png',
                    onTap: () => _navigateToCentralPage(context, "Breathe", "Find a place to be still for a few moments", const Color(0xFF76A487), ()=>_navigateToBreathPage(context)),
                  );
                }
              }
            ),

            FutureBuilder(
              future: loadSvgImage(svgImage: 'lib/assets/clickableShapes/thoughtsOnTrial.svg',), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: 'lib/assets/clickableShapes/thoughtsOnTrial.svg',
                    svgPath: snapshot.data!,
                    svgWidth: 296/360,
                    svgHeight: 186.57/800,
                    svgPosition: const Offset(0, .329),
                    textPosition: const Offset(0.35, 0.47),
                    imagePosition: const Offset(0.24, 0.42),
                    textAnchor: const Offset(-0.5, 0),
                    imageAnchor: const Offset(-0.5, -0.5),
                    text: "Thoughts on Trial",
                    imagePath: 'lib/assets/icons/ChatsTeardrop.png',
                    onTap: () => _navigateToCentralPage(context, "Thoughts on Trial", "Take a few deep breaths", const Color(0xFFE5AD5A), ()=>_navigateToThoughtsOnTrialPage(context)),
                  );
                }
              }
            ),
            
            FutureBuilder(
              future: loadSvgImage(svgImage: 'lib/assets/clickableShapes/visualization.svg',), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: 'lib/assets/clickableShapes/visualization.svg',
                    svgPath: snapshot.data!,
                    svgWidth: 235.12/360,
                    svgHeight: 207.7/800,
                    svgPosition: const Offset(0, 0.548),
                    textPosition: const Offset(0.25, 0.60),
                    imagePosition: const Offset(0.15, 0.70),
                    textAnchor: const Offset(-0.5, 0),
                    imageAnchor: const Offset(-0.5, -0.5),
                    text: "Visualization",
                    imagePath: 'lib/assets/icons/Shapes.png',
                    onTap: () => _navigateToCentralPage(context, "Visualization", "Empty Page", Colors.white,()=>{}),
                  );
                }
              }
            ),
            
            FutureBuilder(
              future: loadSvgImage(svgImage: 'lib/assets/clickableShapes/progressiveMuscleRelaxation.svg',), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: 'lib/assets/clickableShapes/progressiveMuscleRelaxation.svg',
                    svgPath: snapshot.data!,
                    svgWidth: 305.7/360,
                    svgHeight: 290.09/800,
                    alignment: Alignment.topRight,
                    svgPosition: const Offset(1, 0.515),
                    textPosition: const Offset(0.74, 0.67),
                    imagePosition: const Offset(0.74, 0.62),
                    textAnchor: const Offset(-0.5, 0),
                    imageAnchor: const Offset(-0.5, -0.5),
                    svgAnchor: const Offset(-1, 0),
                    text: "Progressive\nMuscle\nRelaxation",
                    imagePath: 'lib/assets/icons/Person.png',
                    onTap: () => _navigateToCentralPage(context, "Progressive Muscle Relaxation", "Empty Page", Colors.white,()=>{}),
                  );
                }
              }
            ),

            
          ],
        ),
      ),
    );
  }

  void _navigateToCentralPage(BuildContext context, String pageName, String centralText, Color backgroundColor, VoidCallback callBack) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => CentralTextPage(pageName: pageName, text: centralText, backgroundColor: backgroundColor, onTap: callBack, backOnLeft: true,),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToFiveSensesPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => FiveSensesPage(text: five_senses.senseChains[five_senses.senseChains.length-1][0].toString(), senseIndex: five_senses.senseChains.length-1, bgColor: five_senses.senseChains[five_senses.senseChains.length-1][1] as Color,),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToBodyScanPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const BodyScanPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
  
  void _navigateToBreathPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const BreathePage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        }
      )
    );
  }

  void _navigateToThoughtsOnTrialPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_,__,___) => const ThoughtsOnTrialPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        }
      )
    );
  }

  void _navigateToHelpPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HelpPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class CentralTextPage extends StatelessWidget {
  final String pageName;
  final String text;
  final Color backgroundColor;
  final double? textSize;
  final double? lineHeight;
  final bool? notBold;
  final VoidCallback? onTap;
  final bool? backOnLeft;

  const CentralTextPage({
    super.key, 
    required this.text, 
    required this.pageName, 
    required this.backgroundColor,
    this.textSize,
    this.lineHeight,
    this.notBold = false,
    this.onTap,
    this.backOnLeft = true,
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(pageName),
        backgroundColor: lighten(backgroundColor, 0.05),
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (textSize == null) ? 40 : textSize,
                      fontWeight: (notBold!) ? FontWeight.normal : FontWeight.w700,
                      height: (lineHeight == null) ? 1.2 : lineHeight,
                    ),
                  ),
                ),
              ),
            ),
            
            Positioned.fill(
              child: GestureDetector(
                onTap: () => {
                  if (backOnLeft!) {
                    _navigateToHomePage(context)
                  }
                }
              ),
            ),

            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                onTap: onTap,
              ),
            ),
            const home_button.ExpandingSvgButton(),
          ],
        ),
      ),
    );
  }
}

class BodyScanSectionPage extends StatelessWidget {
  final String text;
  final int breatheIndex;
  final String breatheSection;
  final Color backgroundColor;

  const BodyScanSectionPage({
    super.key, 
    required this.text,
    required this.breatheIndex,
    required this.backgroundColor,
    required this.breatheSection,
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Body Scan"),
        backgroundColor: lighten(backgroundColor, 0.05),
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  if (breatheIndex > 0) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BodyScanSectionPage(text: breathe_chain.breatheChains[breatheSection]![breatheIndex-1][0].toString(), breatheIndex: breatheIndex-1, breatheSection: breatheSection, backgroundColor: breathe_chain.breatheChains[breatheSection]![breatheIndex-1][1] as Color,),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),  
                    );
                  } else {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const BodyScanPage(),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),  
                    );
                  }
                },
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                onTap: () {
                  if (breatheIndex < breathe_chain.breatheChains[breatheSection]!.length-1) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BodyScanSectionPage(text: breathe_chain.breatheChains[breatheSection]![breatheIndex+1][0].toString(), breatheIndex: breatheIndex+1, breatheSection: breatheSection, backgroundColor: breathe_chain.breatheChains[breatheSection]![breatheIndex+1][1] as Color,),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),  
                    );
                  } else {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const BodyScanPage(),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),  
                    );
                  }
                },
              ),
            ),
            const home_button.ExpandingSvgButton(),
            ],
          ),
        ),
    );
  }
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9CC4A9),
      body: Center(
        child: Stack(
          children: [
            FutureBuilder(
              future: loadSvgImage(svgImage: "lib/assets/clickableShapes/tutorial.svg",), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: "lib/assets/clickableShapes/tutorial.svg",
                    svgPath: snapshot.data!,
                    text: "Tutorial", 
                    svgWidth: 388/360, 
                    svgHeight: 298/800, 
                    alignment: Alignment.topLeft,
                    svgPosition: const Offset(-21/360, -16/800), 
                    textPosition: const Offset(0.5, .1),
                    textSize: 36,
                    textAnchor: const Offset(-.5, 0),
                    onTap: () => Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => const TutorialPageOne(),
                                    transitionsBuilder: (_, animation, __, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ),
                                ),
                  );
                }
              }
            ),

            
            FutureBuilder(
              future: loadSvgImage(svgImage: "lib/assets/clickableShapes/whatIsPause.svg",), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: "lib/assets/clickableShapes/whatIsPause.svg",
                    svgPath: snapshot.data!,
                    text: "What is Pause?", 
                    svgWidth: 393/360, 
                    svgHeight: 362/800,
                    alignment: Alignment.topLeft,
                    svgPosition: const Offset(-26/360, 200/800), 
                    textSize: 36,
                    textPosition: const Offset(0.5, 0.38),
                    textAnchor: const Offset(-.5, 0),
                    onTap: () => Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => const CentralTextPage(pageName: "What is Pause?", text: "Pause is your companion in managing anxiety by offering guided techniques to help you regain focus and find inner peace. Whether you’re grounding yourself during a stressful moment or winding down after a long day, Pause is here to support you.", backgroundColor: Color(0xFF9CC4A9), textSize: 24, lineHeight: 2, notBold:true,),
                                    transitionsBuilder: (_, animation, __, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ),
                                ),
                  );
                }
              }
            ),

            
            FutureBuilder(
              future: loadSvgImage(svgImage: "lib/assets/clickableShapes/resources.svg",), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: "lib/assets/clickableShapes/resources.svg",
                    svgPath: snapshot.data!,
                    text: "Resources", 
                    svgWidth: 438.62/360, 
                    svgHeight: 252.25/800,
                    alignment: Alignment.topLeft,
                    svgPosition: const Offset(-41/360, 419/800), 
                    textSize: 36,
                    textPosition: const Offset(0.5, 0.65),
                    textAnchor: const Offset(-.5, 0),
                    onTap: () => Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => const ResourcePage(),
                                    transitionsBuilder: (_, animation, __, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ),
                                ),
                  );
                }
              }
            ),
            const home_button.ExpandingSvgButton(),
          ],
        ),
      ),
    );
  }
}

class ResourcePage extends StatelessWidget {
  const ResourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resources"), backgroundColor: const Color(0xFFE5AD5A),),
      backgroundColor: const Color(0xFFE5AD5A), // Light orange background color
      body: Stack(
        children: [
          Positioned(
            top: 10, // Control how far down the content starts
            left: 16, // Add horizontal padding
            right: 16, // Add horizontal padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Additional Resources',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(
                  color: Colors.black,
                  endIndent: 0.6 * MediaQuery.of(context).size.width,
                  thickness: 4,
                ),
                const SizedBox(height: 16),
                buildResourceItem(
                  title: '1-800-950-6264 or text “HelpLine” to 62640',
                  description: 'US National Alliance on Mental Illness (NAMI)',
                ),
                buildResourceItem(
                  title: '988',
                  description: 'US National Suicide Prevention Lifeline',
                ),
                buildResourceItem(
                  title: '877-870-4673',
                  description: 'US Samaritans',
                ),
                buildResourceItem(
                  title: '800-662-4357',
                  description: 'US SAMHSA National Helpline',
                ),
                const SizedBox(height: 16),
                const Text(
                  'This app is not meant to replace seeking licensed professional help. '
                  'Reach out to a therapist or use the above resources.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const home_button.ExpandingSvgButton(),
        ],
      ),
    );

  }

   Widget buildResourceItem({required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w100,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(
          color: Colors.black,
          thickness: 1,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class BodyScanPage extends StatelessWidget {

  const BodyScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: const Color(0xFFBDD4DA),
      body: Center(
        child: Stack(
          children: [
            
            
            FutureBuilder(
              future: loadSvgImage(svgImage: "lib/assets/clickableShapes/fullBody.svg",), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: "lib/assets/clickableShapes/fullBody.svg",
                    svgPath: snapshot.data!, 
                    text: "Full Body", 
                    svgWidth: 377.1/360,
                    alignment: Alignment.topLeft,
                    svgHeight: 0.3, 
                    svgPosition: const Offset(0,0), 
                    textPosition: const Offset(0.5, 0.1),
                    textAnchor: const Offset(-0.5, 0),
                    passedScreenHeight: screenHeight,
                    passedScreenWidth: screenWidth,
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BodyScanSectionPage(
                          text: breathe_chain.breatheChains['fullBody']![0][0].toString(),
                          backgroundColor: breathe_chain.breatheChains['fullBody']![0][1] as Color, 
                          breatheIndex: 0, 
                          breatheSection: 'fullBody',
                        ),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child:child);
                        }
                      
                      )
                    ),
                  );
                }
              }
            ),

            FutureBuilder(
              future: loadSvgImage(svgImage: "lib/assets/clickableShapes/lowerBody.svg",), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: "lib/assets/clickableShapes/lowerBody.svg",
                    svgPath: snapshot.data!, 
                    text: "LowerBody", 
                    svgWidth: 390/360,
                    svgHeight: 0.3,
                    alignment: Alignment.topLeft,
                    svgPosition: const Offset(0, 0.2), 
                    textPosition: const Offset(0.5, 0.3),
                    textAnchor: const Offset(-0.5, 0),
                    passedScreenHeight: screenHeight,
                    passedScreenWidth: screenWidth,
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BodyScanSectionPage(
                          text: breathe_chain.breatheChains['lowerBody']![0][0].toString(), 
                          backgroundColor: breathe_chain.breatheChains['lowerBody']![0][1] as Color, 
                          breatheIndex: 0, 
                          breatheSection: 'lowerBody',
                        ),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child:child);
                        }
                      
                      )
                    ),
                  );
                }
              }
            ),

            FutureBuilder(
              future: loadSvgImage(svgImage: "lib/assets/clickableShapes/torso.svg",), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: "lib/assets/clickableShapes/torso.svg",
                    svgPath: snapshot.data!, 
                    text: "Torso", 
                    svgWidth: 382.49/360,
                    alignment: Alignment.topLeft,
                    svgHeight: .3,
                    svgPosition: const Offset(0, 0.4), 
                    textPosition: const Offset(0.5, 0.51),
                    textAnchor: const Offset(-0.5, 0),
                    passedScreenHeight: screenHeight,
                    passedScreenWidth: screenWidth,
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BodyScanSectionPage(
                          text: breathe_chain.breatheChains['torso']![0][0].toString(), 
                          backgroundColor: breathe_chain.breatheChains['torso']![0][1] as Color, 
                          breatheIndex: 1, 
                          breatheSection: 'torso',
                        ),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child:child);
                        }
                      
                      )
                    ),
                  );
                }
              }
            ),
            

            FutureBuilder(
              future: loadSvgImage(svgImage: "lib/assets/clickableShapes/upperBody.svg",), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error if there's an issue
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No SVG data found'); // Handle case where no data is returned
                } else {
                  return svg_overlay.SvgOverlay(
                    svgImage: "lib/assets/clickableShapes/upperBody.svg",
                    svgPath: snapshot.data!, 
                    text: "Upper Body", 
                    svgWidth: 381.65/360,
                    alignment: Alignment.topLeft,
                    svgHeight: 0.3,
                    svgPosition: const Offset(0, 0.6), 
                    textPosition: const Offset(0.5, 0.68),
                    textAnchor: const Offset(-0.5, 0),
                    passedScreenHeight: screenHeight,
                    passedScreenWidth: screenWidth,
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BodyScanSectionPage(
                          text: breathe_chain.breatheChains['upperBody']![0][0].toString(), 
                          backgroundColor: breathe_chain.breatheChains['upperBody']![0][1] as Color, 
                          breatheIndex: 1, 
                          breatheSection: 'upperBody',
                        ),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child:child);
                        }
                      
                      )
                    ),
                  );
                }
              }
            ),

            const home_button.ExpandingSvgButton(),
          ],
        ),
      ),
    );
  }
}

Future<List<svg_overlay.SvgPath>> loadSvgImage({required String svgImage}) async {
    List<svg_overlay.SvgPath> pathsToAdd = [];
    
    String generalString = await rootBundle.loadString(svgImage);


    XmlDocument document = XmlDocument.parse(generalString);


    final paths = document.findAllElements('path');


    for (var element in paths) {
      String partId = element.getAttribute('id').toString();
      String partPath = element.getAttribute('d').toString();
      String name = element.getAttribute('name').toString();
      String color = element.getAttribute('color')?.toString() ?? 'D7D3D2';


      pathsToAdd.add(svg_overlay.SvgPath(id: partId, path: partPath, color: color, name: name));
    }


    return pathsToAdd;
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

class FiveSensesPage extends StatelessWidget {
  final int senseIndex;
  final Color bgColor;
  final String text;

  const FiveSensesPage({super.key, required this.text, required this.senseIndex, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0.125*screenHeight,
                      left: 0.5*screenWidth,
                      child: const FractionalTranslation(
                        translation: Offset(-0.5, 0),
                        child: Text(
                          "Describe",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0.075*screenHeight,
                      left: 0.5*screenWidth,
                      child: FractionalTranslation(
                        translation: const Offset(-0.5, 0),
                        child: Opacity(
                          opacity: 0.37,
                          child: Text(
                            (senseIndex+1).toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 400,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0.6*screenHeight,
                      left: 0.5*screenWidth,
                      child: const FractionalTranslation(
                        translation: Offset(-0.5, 0),
                        child: Text(
                          "things you can",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0.65*screenHeight,
                      left: 0.5*screenWidth,
                      child: FractionalTranslation(
                        translation: const Offset(-0.5, 0),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 120,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const home_button.ExpandingSvgButton(),
                  ],
                )
              ),
            ),

            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  if (senseIndex < five_senses.senseChains.length-1) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => FiveSensesPage(text: five_senses.senseChains[senseIndex+1][0].toString(), senseIndex: senseIndex+1, bgColor: five_senses.senseChains[senseIndex+1][1] as Color,),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),  
                    );
                  } else {
                    _navigateToCentralPage(context, "5 Senses", "Take a few moments to observe your surroundings", const Color(0xFF5491A3), () => _navigateToFiveSensesPage(context));
                  }
                },
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                onTap: () {
                  if (senseIndex > 0) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => FiveSensesPage(text: five_senses.senseChains[senseIndex-1][0].toString(), senseIndex: senseIndex-1, bgColor: five_senses.senseChains[senseIndex-1][1] as Color,),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),  
                    );
                  } else {
                    _navigateToCentralPage(context, "5 Senses", "Remember Healing is not linear. It is okay to pause.", const Color(0xFFBDD4DA), () => _navigateToHomePage(context));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFiveSensesPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => FiveSensesPage(text: five_senses.senseChains[five_senses.senseChains.length-1][0].toString(), senseIndex: five_senses.senseChains.length-1, bgColor: five_senses.senseChains[five_senses.senseChains.length-1][1] as Color,),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToCentralPage(BuildContext context, String pageName, String centralText, Color backgroundColor, VoidCallback callBack) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => CentralTextPage(pageName: pageName, text: centralText, backgroundColor: backgroundColor, onTap: callBack,),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class BreathePage extends StatefulWidget {
  const BreathePage({super.key});
  @override
  BreathePageState createState() => BreathePageState();
}

class BreathePageState extends State<BreathePage> {
  Color backgroundColor = const Color(0xFF76A487); // Initial background color

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Stack(
          children: [
            BreatheAnimation(
              duration: const Duration(seconds: 5),
              onAnimationComplete: 
              (newBackgroundColor) {
                setState(() {
                  backgroundColor = newBackgroundColor;
                });
              },
            ),
            Positioned(
              left: 0.5*screenWidth,
              top: 0.7*screenHeight,
              child: const FractionalTranslation(
                translation: Offset(-0.5, 0),
                child: Opacity(
                  opacity: 0.5,
                  child: Text(
                    "Tap anywhere to\nend practice",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _navigateToHomePage(context),
              ),
            ),
            const home_button.ExpandingSvgButton(),
          ],
        ),
      ),
    );
  }
}

class BreatheAnimation extends StatefulWidget {
  final Duration duration;
  final Function(Color) onAnimationComplete;

  const BreatheAnimation({super.key, required this.duration, required this.onAnimationComplete});

  @override
  BreatheAnimationState createState() => BreatheAnimationState();
}

class BreatheAnimationState extends State<BreatheAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // State variables for alternating between "Breathe In" and "Breathe Out"
  bool isBreathingIn = true; // Track which state is active
  Color circleColor = const Color(0xFFC69167);
  Color indicatorColor = const Color(0xFFE5AD5A);
  String displayText = "Breathe\nin";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Toggle state and restart the animation
          setState(() {
            isBreathingIn = !isBreathingIn; // Toggle state
            if (isBreathingIn) {
              circleColor = const Color(0xFFC69167);
              indicatorColor = const Color(0xFFE5AD5A);
              displayText = "Breathe\nin";

              widget.onAnimationComplete(const Color(0xFF76A487));
            } else {
              circleColor = const Color(0xFF9CC4A9); // Change circle color
              indicatorColor = const Color(0xFFE5AD5A); // Change indicator color
              displayText = "Breathe\nout"; // Update text
              
              widget.onAnimationComplete(const Color(0xFFC69167));
            }
          });

          // Restart the animation
          _controller.reset();
          _controller.forward();
        }
      });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: CircleProgressPainter(
            progress: _controller.value,
            circleColor: circleColor,
            indicatorColor: indicatorColor,
            gapSize: 10,
            circleGapSize: 10,
          ),
          child: Stack(
            children: [
              Positioned(
                top: screenHeight/3,
                left: screenWidth/2,
                child: FractionalTranslation(
                  translation: const Offset(-0.5, -0.40),
                  child: Text(
                    displayText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 0.9,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color circleColor;
  final Color indicatorColor;
  final double gapSize;
  final double circleGapSize;

  CircleProgressPainter({
    required this.progress,
    required this.circleColor,
    required this.indicatorColor,
    required this.gapSize,
    required this.circleGapSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 11.12; // Stroke width for the progress indicator
    double radius = min((size.height / 4), size.width/2-25) - strokeWidth;
    Offset center = Offset(size.width / 2, size.height / 3);

    double startAngle = -90.0 * 3.1415926535897932 / 180.0; // Top of the circle
    double gapAngle = gapSize * 3.1415926535897932 / 180.0; // Gap angle in radians
    double sweepAngle = (progress * 360.0) * 3.1415926535897932 / 180.0;

    // Adjusted angles to keep the top gap completely empty
    double filledStartAngle = startAngle + (gapAngle / 2);
    double filledSweepAngle = (sweepAngle > gapAngle)
        ? sweepAngle - gapAngle
        : 0.0; // Prevent overfilling small progress at the start

    double unfilledStartAngle = filledStartAngle + filledSweepAngle + gapAngle;
    double unfilledSweepAngle = (2 * 3.1415926535897932) - filledSweepAngle - (2 * gapAngle);

    // Paint for the unfilled portion of the progress indicator
    Paint unfilledPaint = Paint()
      ..color = const Color(0xFF9CC4A9)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Paint for the animated progress indicator
    Paint progressPaint = Paint()
      ..color = indicatorColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Paint for the inner circle shadow
    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Paint for the inner circle
    Paint innerCirclePaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;

    // Draw the unfilled arc, ensuring the gap is preserved at the top
    if (unfilledSweepAngle > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        unfilledStartAngle,
        unfilledSweepAngle,
        false,
        unfilledPaint,
      );
    }

    // Draw the filled progress arc, ensuring the gap is preserved at the top
    if (filledSweepAngle > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        filledStartAngle,
        filledSweepAngle,
        false,
        progressPaint,
      );
    }

    // Draw shadow for the inner circle
    canvas.drawCircle(center, radius - strokeWidth - circleGapSize + 2, shadowPaint);

    // Draw the inner circle with a gap
    canvas.drawCircle(center, radius - strokeWidth - circleGapSize, innerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ThoughtsOnTrialPage extends StatefulWidget {
  const ThoughtsOnTrialPage({super.key});
  @override
  ThoughtsOnTrialState createState() => ThoughtsOnTrialState();
}

class ThoughtsOnTrialState extends State<ThoughtsOnTrialPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30), // Full cycle duration
      vsync: this,
    )..repeat(); // Loop forever

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;

        return Scaffold(
          backgroundColor: const Color(0xFFBDD4DA),
          body:Stack(
            children: [
              // Left side shapes
              ..._buildMovingShapes(
                offset: 0.0,
                isLeft: true,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),

              const Center(
                child: Text(
                  "What is worrying\nyou right now?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const home_button.ExpandingSvgButton(),
              Positioned.fill(
              child: GestureDetector(
                onTap: () => _navigateToCentralPage(context, "Thoughts on Trial", "Take a few deep breaths", const Color(0xFFE5AD5A), ()=>_navigateToThoughtsOnTrialPage(context),),
              )
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    PageRouteBuilder(
                      pageBuilder: (_,__,___) => ThoughtsOnTrialChain(text: thoughts.thoughtChains[0][0].toString(), color: thoughts.thoughtChains[0][1] as Color, index: 0),
                      transitionsBuilder: (_,animation,__,child) {
                        return FadeTransition(opacity: animation, child: child,);
                      }
                    ),
                  );
                },
              ),
            ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToCentralPage(BuildContext context, String pageName, String centralText, Color backgroundColor, VoidCallback callBack) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => CentralTextPage(pageName: pageName, text: centralText, backgroundColor: backgroundColor, onTap: callBack, backOnLeft: true,),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToThoughtsOnTrialPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_,__,___) => const ThoughtsOnTrialPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        }
      )
    );
  }

  List<Widget> _buildMovingShapes({
    required double offset,
    required bool isLeft,
    required double screenWidth,
    required double screenHeight,
  }) {
    return [
      AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          double position1 = (_animation.value + offset) % 1.0;
          double position2 = (_animation.value + offset-0.5) % 1.0;
          return Stack(
            children: [
              _buildShape(
                isLeft: isLeft,
                screenWidth: screenWidth,
                screenHeight: 2*screenHeight,
                position: position1,
              ),
              _buildShape(
                isLeft: !isLeft,
                screenWidth: screenWidth,
                screenHeight: 2*screenHeight,
                position: position2,
              ),
            ],
          );
        },
      ),
    ];
  }

  Widget _buildShape({
    required bool isLeft,
    required double screenWidth,
    required double screenHeight,
    required double position,
  }) {
    double adjustedPosition = screenHeight * position;

    return Positioned(
      left: isLeft ? 0 : null,
      right: isLeft ? null : 0,
      bottom: adjustedPosition-screenHeight*0.45,
      child: Opacity(
        opacity: 0.5, 
        child: isLeft ? SvgPicture.asset("lib/assets/clickableShapes/leftLung.svg") : SvgPicture.asset("lib/assets/clickableShapes/rightLung.svg"),
      ),
    );
  }
}

class ThoughtsOnTrialChain extends StatelessWidget {
  final String text;
  final Color color;
  final int index;

  const ThoughtsOnTrialChain({
    super.key, 
    required this.text, 
    required this.color, 
    required this.index
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () => {
                  if (index > 0) {
                    Navigator.push(
                      context, 
                      PageRouteBuilder(
                        pageBuilder: (_,__,___) => ThoughtsOnTrialChain(text: thoughts.thoughtChains[index-1][0].toString(), color: thoughts.thoughtChains[index-1][1] as Color, index: index-1),
                        transitionsBuilder: (_,animation,__,child) {
                          return FadeTransition(opacity: animation, child: child,);
                        }
                      ),
                    )
                  } else {
                    Navigator.push(
                      context, 
                      PageRouteBuilder(
                        pageBuilder: (_,__,___) => const ThoughtsOnTrialPage(),
                        transitionsBuilder: (_,animation,__,child) {
                          return FadeTransition(opacity: animation, child: child,);
                        }
                      ),
                    )
                  }
                },
              )
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                onTap: () {
                  if (index < thoughts.thoughtChains.length-1) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => ThoughtsOnTrialChain(text: thoughts.thoughtChains[index+1][0].toString(), index: index+1, color: thoughts.thoughtChains[index][1] as Color,),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),  
                    );
                  } else {
                    _navigateToHomePage(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TutorialPageOne extends StatelessWidget {
  const TutorialPageOne({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9CC4A9),
      body: Center(
        child: Stack(
          children: [
            
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_,__,___) => const HelpPage(),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    }
                  )
                ), 
              ),
            ),

            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_,__,___) => const TutorialPageTwo(),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    }
                  )
                ), 
                child: Opacity(
                  opacity: 0.32,
                  child: Container(
                    color: const Color(0xFFFFFFFF),
                  ),
                )
              ),
            ),

            const Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: IgnorePointer( // Ensures the Text does not block touch events
                    child: Text(
                      "Press right of screen to progress to next screen",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const home_button.ExpandingSvgButton(),
          ],
        ),
      ),
    );
  }
}

class TutorialPageTwo extends StatelessWidget {
  const TutorialPageTwo({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5AD5A),
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_,__,___) => const TutorialPageThree(),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    }
                  )
                ), 
              ),
            ),

            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.sizeOf(context).width/2,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_,__,___) => const TutorialPageOne(),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    }
                  )
                ), 
                child: Opacity(
                  opacity: 0.32,
                  child: Container(
                    color: const Color(0xFFFFFFFF),
                  ),
                )
              ),
            ),
            
            const Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: IgnorePointer( // Ensures the Text does not block touch events
                    child: Text(
                      "Press left of screen to go back to last screen",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const home_button.ExpandingSvgButton(),
          ],
        ),
      ),
    );
  }
}

class TutorialPageThree extends StatelessWidget {
  const TutorialPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top:0.6*screenHeight,
              child: Center(
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.sizeOf(context).width,
                    child: const Text(
                      "Press here any time to return home",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0.735*screenHeight,
              left: 0.3*screenWidth,
              child: Transform(
                transform: Matrix4.rotationZ(0.25),
                child: SvgPicture.asset(
                  "lib/assets/icons/arrow.svg",
                  height: screenHeight/10,
                  width: screenHeight/10,
                ),
              ),
            ),
            const home_button.ExpandingSvgButton(),
          ],
        ),
      )
    );
  }

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