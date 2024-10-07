// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watch/screens/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:watch/screens/menu/profile.dart';

class CreateWatch extends StatefulWidget {
  final int userID;
  final String user;
  final String selectedLanguage;
  final Function(String) changeLanguage;

  const CreateWatch({
    super.key,
    required this.selectedLanguage,
    required this.changeLanguage,
    required this.userID,
    required this.user});

  @override
  State<CreateWatch> createState() => _CreateWatchState();
}

class _CreateWatchState extends State<CreateWatch> {

  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  
   switch(selectedIndex){

    case 0:

   }
  }

  TextEditingController name = TextEditingController();
  TextEditingController whereWatch = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController description = TextEditingController();
  String? selectedWhereWatch; 
  String? selectedCategory; 
  String? selectedWatch;

  int rating = 0;

  Future<void> registerAnime() async {
    //var url = Uri.parse('http://192.168.5.159/registerAnime.php');
    var url = Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/registerAnime.php');

    // Montando os dados para enviar
    var response = await http.post(url, body: {
      'ID_User': widget.userID.toString(),
      'Name': name.text,
      'Where_Watch': selectedWhereWatch!,
      'Category': selectedCategory!,
      'Rating': rating.toString(),
      'Description': description.text,
    });

    // Verificando a resposta do servidor
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Homepage(
          selectedLanguage: _selectedLanguage,
          changeLanguage: widget.changeLanguage,
          userID: widget.userID, 
          user: widget.user),));
      // ignore: use_build_context_synchronously
    } else {
      print('Erro ao registrar Anime: ${response.body}');
      // ignore: use_build_context_synchronously
    }
  }

  Future<void> registerMovie() async {
    //var url = Uri.parse('http://192.168.5.159/registerMovie.php');
    var url = Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/registerMovie.php');


    // Montando os dados para enviar
    var response = await http.post(url, body: {
      'ID_User': widget.userID.toString(),
      'Name': name.text,
      'Where_Watch': selectedWhereWatch!,
      'Category': selectedCategory!,
      'Rating': rating.toString(),
      'Description': description.text,
    });

    // Verificando a resposta do servidor
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Homepage(
          selectedLanguage: _selectedLanguage,
          changeLanguage: widget.changeLanguage,
          userID: widget.userID, 
          user: widget.user),));
      // ignore: use_build_context_synchronously
    } else {
      print('Erro ao registrar Movie: ${response.body}');
      // ignore: use_build_context_synchronously
    }
  }

  Future<void> registerSerie() async {
    //var url = Uri.parse('http://192.168.5.159/registerSerie.php');
    var url = Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/registerSerie.php');
    

    // Montando os dados para enviar
    var response = await http.post(url, body: {
      'ID_User': widget.userID.toString(),
      'Name': name.text,
      'Where_Watch': selectedWhereWatch!,
      'Category': selectedCategory!,
      'Rating': rating.toString(),
      'Description': description.text,
    });

    // Verificando a resposta do servidor
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Homepage(
          selectedLanguage: _selectedLanguage,
          changeLanguage: widget.changeLanguage,
          userID: widget.userID, 
          user: widget.user),));
      // ignore: use_build_context_synchronously
    } else {
      print('Erro: ${response.body}');
      // ignore: use_build_context_synchronously
    }
  }

  late String _selectedLanguage;

  @override
  void initState() {
    _selectedLanguage = widget.selectedLanguage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
            onPressed: () {
            Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => Homepage(
                  selectedLanguage: _selectedLanguage,
                  changeLanguage: widget.changeLanguage,
                  userID: widget.userID,
                  user: widget.user,),));
          }, icon: const Icon(
            Icons.home,
            color: Colors.white,
            size: 25,
          ),
          ),
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => Profile(
                selectedLanguage: _selectedLanguage,
                changeLanguage: widget.changeLanguage,
                userID: widget.userID,
                user: widget.user),));
          }, icon: const Icon(
            Icons.account_box,
            color: Colors.white,
            size: 25,
          ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        unselectedIconTheme: const IconThemeData(
          size: 25
        ),
        items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.group),
              label: AppLocalizations.of(context)!.friends,),
              BottomNavigationBarItem(
                icon: const Icon(Icons.add,),
                label: AppLocalizations.of(context)!.addNew,)
        ]),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 200,
                  color: Colors.grey,
                  child: Text(
                       selectedWatch == 'Série'
                            ? 'S'
                            : selectedWatch == 'Movie'
                                ? AppLocalizations.of(context)!.m
                                : selectedWatch == 'Anime'
                                    ? 'A'
                                    : '+', // Caso não seja nenhum dos três
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: AppLocalizations.of(context)!.name,
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
                DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: selectedWatch,
                  hint: Text(AppLocalizations.of(context)!.selectingType,
                  style: const TextStyle(
                    color: Colors.white
                  ),),
                  onChanged: (value) {
                    setState(() {
                      selectedWatch = value!;
                    });
                  },
                  items: [ const DropdownMenuItem(
                    value: 'Anime',
                    child: Text('Anime',
                    style: TextStyle(
                      color: Colors.white
                    ),)),
                    DropdownMenuItem(
                      value: 'Movie',
                      child: Text(AppLocalizations.of(context)!.movie,
                      style: const TextStyle(
                        color: Colors.white
                      ),
                      ),
                      ),
                      DropdownMenuItem(
                        value: 'Série',
                        child: 
                            Text(AppLocalizations.of(context)!.series,
                            style: const TextStyle(
                              color: Colors.white
                            ),
                            ),      
                        ),
                                ],
                                  ),
                DropdownButton<String>(
                  onTap: () {
                    
                  },
                  dropdownColor: Colors.black,
                  value: selectedWhereWatch,
                  hint: Text(AppLocalizations.of(context)!.selectingTheplataformToWatch,
                  style: const TextStyle(
                    color: Colors.white
                  ),),
                  onChanged: (value) {
                    setState(() {
                      selectedWhereWatch = value!;
                    });
                  },
                  items: [ const DropdownMenuItem(
                    value: 'Prime Video',
                    child: Text('Prime Video',
                    style: TextStyle(
                      color: Colors.blueAccent
                    ),)),
                    const DropdownMenuItem(
                      value: 'Disney+',
                      child: Text('Disney+',
                      style: TextStyle(
                        color: Colors.blue
                      ),
                      ),
                      ),
                      const DropdownMenuItem(
                        value: 'Netflix',
                        child: 
                            Text('Netflix',
                            style: TextStyle(
                              color: Colors.red
                            ),
                            ),      
                        ),
                        const DropdownMenuItem(
                              value: 'GloboPlay',
                              child: Text('GloboPlay',
                              style: TextStyle(
                                color: Colors.orange
                              ),
                              ),
                              ),
                              const DropdownMenuItem(
                                value: 'HBO Max',
                                child: Text('HBO Max',
                                style: TextStyle(
                                  color: Colors.blue
                                ),
                                ),
                                ),
                                const DropdownMenuItem(
                                    value: 'Crunchyroll',
                                    child: 
                                        Text('Crunchyroll',
                                        style: TextStyle(
                                          color: Colors.orange
                                        ),
                                        ),      
                                    ),
                                 DropdownMenuItem(
                                    value: 'Pirate',
                                    child: 
                                        Text(AppLocalizations.of(context)!.pirata,
                                        style: const TextStyle(
                                          color: Colors.white
                                        ),
                                        ),      
                                    ),
                                    DropdownMenuItem(
                                    value: 'Others',
                                    child: 
                                        Text(AppLocalizations.of(context)!.others,
                                        style: const TextStyle(
                                          color: Colors.white
                                        ),
                                        ),      
                                    ),
                                  ], 
                                  ),
                                  DropdownButton<String>(
                                    dropdownColor: Colors.black,
                                    value: selectedCategory,
                                    hint: Text(AppLocalizations.of(context)!.selectingCategory,
                                    style: const TextStyle(
                                      color: Colors.white
                                    ),),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCategory = value!;
                                      });
                                    },
                                    items: [ DropdownMenuItem(
                                      value: 'Ação',
                                      child: Text(AppLocalizations.of(context)!.acao,
                                      style: const TextStyle(
                                        color: Colors.white
                                      ),
                                      ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Aventura',
                                        child: Text(AppLocalizations.of(context)!.aventura,
                                        style: const TextStyle(
                                          color: Colors.white
                                        ),
                                        ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Comédia',
                                          child: Text(AppLocalizations.of(context)!.comedia,
                                              style: const TextStyle(
                                                color: Colors.white
                                              ),
                                              ),
                                          ),
                                          DropdownMenuItem(
                                                value: 'Terror',
                                                child: Text(AppLocalizations.of(context)!.terror,
                                                style: const TextStyle(
                                                  color: Colors.white
                                                ),
                                                ),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Romance',
                                                  child: Text(AppLocalizations.of(context)!.romance,
                                                  style: const TextStyle(
                                                    color: Colors.white
                                                  ),
                                                  ),
                                                  ),
                                                   DropdownMenuItem(
                                                  value: 'Ficção Científica',
                                                  child: Text(AppLocalizations.of(context)!.ficcaoCientifica,
                                                  style: const TextStyle(
                                                    color: Colors.white
                                                  ),
                                                  ),
                                                  ),
                                                    ], 
                                                    ),
                                                     Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: List.generate(5, (index) {
                                                            return IconButton(
                                                              icon: Icon(
                                                                Icons.star,
                                                                color: index < rating ? Colors.yellow : Colors.grey,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  rating = index + 1;  
                                                                });
                                                              },
                                                            );
                                                          }),
                                                        ),
                                                        SizedBox(
                                                          width: 300,
                                                          child: TextField(
                                                            controller: description,
                                                            decoration: InputDecoration(
                                                              border: const OutlineInputBorder(),
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              labelText: AppLocalizations.of(context)!.description,
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
                                                          width: 200,
                                                          child: TextButton(
                                                            style: const ButtonStyle(
                                                              shape: WidgetStatePropertyAll(
                                                                LinearBorder()
                                                              ),
                                                              backgroundColor: WidgetStatePropertyAll(
                                                                Colors.white
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              if (selectedWatch == 'Anime') {
                                                                registerAnime();
                                                              } if(selectedWatch == 'Movie'){
                                                                registerMovie();
                                                              } if(selectedWatch == 'Série'){
                                                                registerSerie();
                                                              } else{
                                                                return;
                                                              }
                                                            }, child: Text(AppLocalizations.of(context)!.save,
                                                            style: const TextStyle(
                                                              color: Colors.black
                                                            ),
                                                            ),
                                                            ),
                                                        ),
                                                        SizedBox(
                                                          width: 200,
                                                          child: TextButton(
                                                            style: const ButtonStyle(
                                                              shape: WidgetStatePropertyAll(
                                                                LinearBorder()
                                                              ),
                                                              backgroundColor: WidgetStatePropertyAll(
                                                                Colors.white
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(context, 
                                                              MaterialPageRoute(
                                                                builder: (context) => Homepage(
                                                                  selectedLanguage: _selectedLanguage,
                                                                  changeLanguage: widget.changeLanguage,
                                                                  userID: widget.userID,
                                                                  user: widget.user),));
                                                            }, child: Text(AppLocalizations.of(context)!.cancel,
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