// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:watch/screens/forgotPassword.dart';
import 'package:watch/screens/homepage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:watch/screens/registerUser/register.dart';

class Login extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) changeLanguage;
  const Login({
    required this.changeLanguage,
    required this.selectedLanguage,
    super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  final _auth = FirebaseAuth.instance;

  TextEditingController emailUser = TextEditingController();
  TextEditingController passwordUser = TextEditingController();

  void login(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(
    email: emailUser.text, 
    password: passwordUser.text);
    // ignore: prefer_const_declarations
    //final url = 'http://192.168.5.159/login.php';
    // ignore: prefer_const_declarations
    final url = 'https://entirely-welcome-jackal.ngrok-free.app/login.php';
    // ignore: prefer_const_declarations

  // Corpo da requisição
  final response = await http.post(
    Uri.parse(url),
    body: {
      'Email': emailUser.text,
      'Password': passwordUser.text,
    },
  );


  // Verifique a resposta do servidor
  if (response.statusCode == 200) {
    // ignore: unused_local_variable
    var data = jsonDecode(response.body);
    final Map<String, dynamic> serverResponse = jsonDecode(response.body);

    if (serverResponse['status'] == "login success") {
      final userID = serverResponse['user_id'];
      final user = serverResponse['user'];
      // Exiba uma mensagem ou navegue para outra página
      // ignore: use_build_context_synchronously
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => Homepage(
        userID: userID,
        user: user,
        selectedLanguage: _selectedLanguage,
        changeLanguage: widget.changeLanguage,
      ),
      ),
      );
    } else {
        print('Erro: ${response.statusCode}');
        print('Resposta do Servidor: ${response.body}');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${serverResponse['status']}')),
      );
    }
  } else {
    print("Erro na conexão: ${response.statusCode}");
  }
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Database crashed')));
  }
  }

  String _selectedLanguage = 'pt';

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
    print(_selectedLanguage);
    print('Outro: ${widget.selectedLanguage}'); // Inicialize com o idioma passado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: DropdownButton<String>(
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(10),
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                  widget.changeLanguage(newValue);
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
              ),
              const SizedBox(
                height: 40,
              ),       
            SizedBox(
                      width: 300,
                      child: TextField(
                        controller: emailUser,
                        decoration:  const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Email',
                          labelStyle: TextStyle(
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
                      child: TextField(
                        controller: passwordUser,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: AppLocalizations.of(context)!.password,
                          labelStyle: const TextStyle(
                            color: Colors.black
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black
                        ),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.only(left: 180),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Forgotpassword(
                                selectedLanguage: _selectedLanguage,
                                changeLanguage: widget.changeLanguage,),));
                        }, child: Text(AppLocalizations.of(context)!.forgot_password,
                        style: const TextStyle(
                          color: Colors.black
                        ),),
                        )),
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
                            login(emailUser.text, passwordUser.text);
                          }, child: Text(AppLocalizations.of(context)!.login,
                          style: const TextStyle(
                            color: Colors.black
                          ),
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
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Register(
                                selectedLanguage: _selectedLanguage,
                                changeLanguage: widget.changeLanguage,),));
                          }, child: Text(AppLocalizations.of(context)!.register,
                          style: const TextStyle(
                            color: Colors.black
                          ),
                          ),
                          ),
                     ),
            ],
          ),
        ),
      ),
    );
  }
}