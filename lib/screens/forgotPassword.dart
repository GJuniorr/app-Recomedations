// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Forgotpassword extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) changeLanguage;
  const Forgotpassword({
    required this.changeLanguage,
    required this.selectedLanguage,
    super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {

  final _auth = FirebaseAuth.instance;

    Future<void> emailForgotPassword() async {
      try{
      await _auth.sendPasswordResetEmail(email: email.text);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    }

    TextEditingController email = TextEditingController();

    late String _selectedLanguage;

    @override
  void initState() {
    _selectedLanguage = widget.selectedLanguage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(10),
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
                widget.changeLanguage(newValue!);
              },
              items: <String>['en', 'pt']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      // Exibe a bandeira correspondente
                      value == 'en'
                          ? Image.asset('assets/images/america-flag.png', height: 30,)
                          : Image.asset('assets/images/brasil.png', height: 30,),
                      const SizedBox(width: 8), // Espaçamento
                      Text(value == 'en' ? 'English' : 'Português'),
                    ],
                  ),
                );
              }).toList(),
            ),
            centerTitle: true,
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.enterEmailtosendYourPassword,
            style: const TextStyle(
              color: Colors.white
            ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: email,
                decoration:  InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: AppLocalizations.of(context)!.email,
                  labelStyle: const TextStyle(
                    color: Colors.black
                  ),
                ),
                style:  const TextStyle(
                  color: Colors.black
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 300,
              child: TextButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.white
                  ),
                  shape: WidgetStatePropertyAll(
                    LinearBorder()
                  )
                ),
                onPressed: () {
                  emailForgotPassword();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context)!.anemailforpasswordresethasbeensenttoyouremail,)));
                }, child: Text(AppLocalizations.of(context)!.send,
                style: const TextStyle(
                  color: Colors.black
                ),
                ),
                ),
            ),
             const SizedBox(
              height: 0,
            ),
            SizedBox(
                  width: 300,
                  child: TextButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.white
                      ),
                      shape: WidgetStatePropertyAll(
                        LinearBorder()
                      )
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'login');
                    }, child: Text(AppLocalizations.of(context)!.back,
                    style: const TextStyle(
                      color: Colors.black
                    ),
                    ),
                    ),
                ),
          ],
        ),
        ),
    );
  }
}