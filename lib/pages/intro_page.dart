import 'package:flutter/material.dart';
import 'package:geminichatapp/pages/home_page.dart';
import 'package:geminichatapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    // ignore: unused_local_variable
    Brightness systemBrightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Image.asset(
                'assets/ai2.png',
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Your Powerful And\nPersonal AI Assistant',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'You can communicate and improve your knowledge on any topic you want !',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoute());
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.blue.shade800;
                              }

                              return Colors.blue.shade600;
                            },
                          ),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 30,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Start a Conversation',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
