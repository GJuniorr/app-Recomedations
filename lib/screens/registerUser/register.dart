// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:watch/screens/loginUser/login.dart';

class Register extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) changeLanguage;
  const Register({
    required this.selectedLanguage,
    required this.changeLanguage,
    super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;

  void register(String email, String password, String name) async {
    if (passwordUser.text.length < 6) {
       ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error register: Password must have 6 or more characters')),
          );
    }
  await _auth.createUserWithEmailAndPassword(email: emailUser.text, password: passwordUser.text);
  // ignore: prefer_const_declarations
  //final url = 'https://192.168.5.159/register.php';
  // ignore: prefer_const_declarations
  final url = 'https://entirely-welcome-jackal.ngrok-free.app/register.php';

  // Corpo da requisição
  try{
  final response = await http.post(
    Uri.parse(url),
    body: {
      'Email': email,
      'Password': password,
      'User': name,
    },
  );

  // Verifique a resposta do servidor
   if (response.statusCode == 200) {
        final String responseBody = response.body;
        if (responseBody.contains("User registered successfully")) {
          // Sucesso no registro
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registered succesfully!')),
          );
          Navigator.pushNamed(context, 'login');
        } else if (responseBody.contains("Email already exists")) {
          // Email já existe
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already exists!')),
          );
        } else {
          // Outro erro
          print('Error register: $responseBody');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error register: $responseBody')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error server: ${response.statusCode}')),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connection: $e')),
      );
    }
  }

  TextEditingController emailUser = TextEditingController();
  TextEditingController passwordUser = TextEditingController();
  TextEditingController nameUser = TextEditingController();
  late String _selectedLanguage;

   @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage; // Inicialize com o idioma passado
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
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: nameUser,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: AppLocalizations.of(context)!.user,
                          labelStyle: const TextStyle(
                            color: Colors.black
                          ),
                        ),
                        style: const TextStyle(
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
                            register(emailUser.text, passwordUser.text, nameUser.text);
                          }, child: Text(AppLocalizations.of(context)!.register,
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
                              builder: (context) => Login(
                                selectedLanguage: _selectedLanguage,
                                changeLanguage: widget.changeLanguage),));
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
      ),
    );
  }
}