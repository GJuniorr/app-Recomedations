import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watch/firebase_options.dart';
import 'package:watch/screens/createWatch.dart';
import 'package:watch/screens/forgotPassword.dart';
import 'package:watch/screens/homepage.dart';
import 'package:watch/screens/loginUser/login.dart';
import 'package:watch/screens/menu/profile.dart';
import 'package:watch/screens/registerUser/register.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('pt', 'BR');

  // Função para alterar o idioma
  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode, '');
    });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),  // Inglês
        Locale('pt', 'BR') // Português Brasil
      ],
      locale: _locale, // Aplica o idioma selecionado
      initialRoute: 'login',
      routes: {
        'login': (context) => Login(
          selectedLanguage: 'pt',
          changeLanguage: _changeLanguage,
        ),
        'register': (context) => Register(
          selectedLanguage: '',
          changeLanguage: _changeLanguage,
        ),
        'homepage': (context) => Homepage(
          selectedLanguage: '',
          changeLanguage: _changeLanguage,
          userID: 0,
          user: ''
        ),
        'createWatch': (context) => CreateWatch(
          selectedLanguage: '',
          changeLanguage: _changeLanguage,
          userID: 0,
          user: ''
        ),
        'profile': (context) => Profile(
          selectedLanguage: '',
          changeLanguage: _changeLanguage,
          userID: 0, 
          user: ''),
        'forgotPassword': (context) => Forgotpassword(
          selectedLanguage: '',
          changeLanguage: _changeLanguage
        ),
      },
    );
  }}