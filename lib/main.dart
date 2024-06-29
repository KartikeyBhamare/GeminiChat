import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:geminichatapp/const.dart';
import 'package:geminichatapp/pages/home_page.dart';
import 'package:geminichatapp/pages/intro_page.dart';
import 'package:geminichatapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Gemini',
            theme: themeProvider.themeData,
            home: const IntroPage(),
            routes: {
              '/intro page': (context) => const IntroPage(),
              '/home page': (context) => const HomePage(),
            },
          );
        },
      ),
    );
  }
}
