// ignore_for_file: avoid_print, file_names

import 'dart:convert';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:watch/screens/createWatch.dart';
import 'package:watch/screens/homepage.dart';
import 'package:watch/screens/menu/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profilefriend extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) changeLanguage;
  final int userID;
  final int friendID;
  final String user;
  const Profilefriend({
    required this.selectedLanguage,
    required this.changeLanguage,
    required this.userID,
    required this.friendID,
    required this.user,
    super.key});

  @override
  State<Profilefriend> createState() => _ProfilefriendState();
}

class _ProfilefriendState extends State<Profilefriend> {
   Map<String, dynamic>? userInfo;
   void requisitedUserInfo() async {
    // ignore: prefer_const_declarations
    //final url = 'http://192.168.5.159/selectInfo.php';
    // ignore: prefer_const_declarations
    final url = 'https://entirely-welcome-jackal.ngrok-free.app/selectInfo.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'ID_User': widget.friendID.toString()},
      );

      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          userInfo = json.decode(response.body);
          print(json.decode(response.body));
        });
      } else {
        throw Exception('Falha ao carregar dados do usuário.');
      }
    } catch (e) {
      // ignore: duplicate_ignore
      // ignore: avoid_print
      print('Erro: $e');
    }
  }


  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  
   switch(selectedIndex){

    case 0:

    break;

    case 1:
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => CreateWatch(
          selectedLanguage: _selectedLanguage,
          changeLanguage: widget.changeLanguage,
          userID: widget.userID,
          user: widget.user,),));
   }
  }

  bool allColor = true;
  bool animesColor = false;
  bool moviesColor = false;
  bool seriesColor = false;


  List watchUser = [];
  List tempWatchUser = []; 

  List movies = [];
  List series = [];
  List animes = [];
  List allWatch = [];

  int rowCount = 0;
  int rowCountFriend = 0;
  List usersRequest = [];
  List usersFriend = [];
  String testeRequest = '';
  List idtesteRequest = [];


  String filter = 'Only My';
  bool myAndFriends = true;
  bool onlyMy = false;
  bool onlyFriends = false;
  Future<void> seeWatch() async {
  final response = await http.post(
    //Uri.parse('http://192.168.5.159/seeAll.php'),
    Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/seeAll.php'),
    body: {
      'ID_User': widget.friendID.toString(),
      'filter': filter
    },
  );

  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body.trim());

    setState(() {
      movies = data['movies'] ?? [];
      series = data['series'] ?? [];
      animes = data['animes'] ?? [];

      allWatch = [];
      allWatch.addAll(movies);
      allWatch.addAll(series);
      allWatch.addAll(animes);
    });

    print('Movies: $movies');
    print('Séries: $series');
    print('Animes: $animes');
    updateWatchUser();
  } else {
    throw Exception('Falha ao carregar os dados');
  }
}

  bool containsAny(List list, List items) {
  for (var item in items) {
    if (list.contains(item)) {
      return true;
    }
  }
  return false;
}

  void updateWatchUser() {
  List tempWatchUser = []; 

  if (allColor) {
    tempWatchUser = List.from(allWatch); 
  } else if (moviesColor && seriesColor && animesColor) {
    tempWatchUser.addAll(movies);
    tempWatchUser.addAll(series);
    tempWatchUser.addAll(animes);
  } else if (moviesColor && seriesColor) {
    if (!containsAny(tempWatchUser, movies)) {
      tempWatchUser.addAll(movies);
    }
    if (!containsAny(tempWatchUser, series)) {
      tempWatchUser.addAll(series);
    }
  } else if (moviesColor && animesColor) {
    if (!containsAny(tempWatchUser, movies)) {
      tempWatchUser.addAll(movies);
    }
    if (!containsAny(tempWatchUser, animes)) {
      tempWatchUser.addAll(animes);
    }
  } else if (seriesColor && animesColor) {
    if (!containsAny(tempWatchUser, series)) {
      tempWatchUser.addAll(series);
    }
    if (!containsAny(tempWatchUser, animes)) {
      tempWatchUser.addAll(animes);
    }
  } else if (moviesColor) {
    tempWatchUser = List.from(movies);
  } else if (seriesColor) {
    tempWatchUser = List.from(series);
  } else if (animesColor) {
    tempWatchUser = List.from(animes);
  }

  if (searchController.text.isNotEmpty) {
    String nameFilter = searchController.text.toLowerCase();
    tempWatchUser = tempWatchUser.where((item) {
      return item['Name'].toLowerCase().contains(nameFilter);
    }).toList();
  }

  setState(() {
    watchUser = tempWatchUser;
    filteredWatchUser = tempWatchUser;
  });
}
  List<dynamic> filteredWatchUser = [];
    TextEditingController searchController = TextEditingController();

  void filterResults() {
    setState(() {
      // Verifica se o campo de busca está vazio
      if (searchController.text.isEmpty) {
        filteredWatchUser = List.from(watchUser); // Mostra todos os itens se não houver filtro
      } else {
        filteredWatchUser = watchUser.where((item) {
          // Filtra os itens com base no nome ou tipo
          return item['Name'].toLowerCase().contains(searchController.text.toLowerCase());
        }).toList();
      }
    });
  }

  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
    requisitedUserInfo();
    seeWatch();
    filterResults();
    print('O ID DO AMIGO É: ${widget.friendID}');
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                  user: widget.user),));
          }, icon: const Icon(
            Icons.home,
            color: Colors.white,
            size: 25,
          ),
          ),
        title:  SizedBox(
          height: 40,
          child: TextField(
            onChanged: (value) {
             filterResults();
            },
            controller: searchController,
            decoration:  InputDecoration(
              labelText: AppLocalizations.of(context)!.search,
              labelStyle: const TextStyle(
                color: Colors.black
              ),
              filled: true,
              fillColor: Colors.blue,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  searchController.clear(); 
                  filterResults();
                }, icon: const Icon(Icons.clear))
            ),
          ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12.0, top: 20),
                child: Icon(Icons.account_box,
                color: Colors.white,
                size: 40,),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: userInfo != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.user}: ${userInfo!['User']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 150,
                              color: Colors.white,
                              child: Text(
                                '${AppLocalizations.of(context)!.ratingAnime}: ${userInfo!['Ratings_Anime']}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 150,
                              color: Colors.white,
                              child: Text(
                                '${AppLocalizations.of(context)!.ratingMovie}: ${userInfo!['Ratings_Movie']}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                       Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 150,
                              color: Colors.white,
                              child: Text(
                                '${AppLocalizations.of(context)!.ratingSerie}: ${userInfo!['Ratings_Series']}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 150,
                              color: Colors.white,
                              child: Text(
                                '${AppLocalizations.of(context)!.rating}: ${userInfo!['Ratings']}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const CircularProgressIndicator(),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              width: 420,
              height: 30,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(AppLocalizations.of(context)!.list,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20
              ),),
            ),
            const SizedBox(
              height: 10,
            ),
                Container(
                  width: 420,
                  height: 40,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            allColor = true;
                            animesColor = false;
                            moviesColor = false;
                            seriesColor = false;
                            updateWatchUser();
                          });
                        }, child: Text(AppLocalizations.of(context)!.all,
                        style: TextStyle(
                          color: allColor ? Colors.black : Colors.grey[600]
                        ),)),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            allColor = false;
                            animesColor = !animesColor;
                            updateWatchUser();
                          });
                        }, child: Text('Animes',
                        style: TextStyle(
                          color: animesColor ? Colors.black : Colors.grey[600]
                        ),)),
                        TextButton(
                        onPressed: () {
                          setState(() {
                            allColor = false;
                            moviesColor = !moviesColor;
                            updateWatchUser();
                          });
                        }, child: Text(AppLocalizations.of(context)!.movie,
                        style: TextStyle(
                          color: moviesColor ? Colors.black : Colors.grey[600]
                        ),)),
                        TextButton(
                        onPressed: () {
                          setState(() {
                            allColor = false;
                            seriesColor = !seriesColor;
                            updateWatchUser();
                          });
                        }, child: Text(AppLocalizations.of(context)!.series,
                        style: TextStyle(
                          color: seriesColor ? Colors.black : Colors.grey[600]
                        ),
                        ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                    SizedBox(
                      width: 420,
                      child: GridView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount:  filteredWatchUser.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Define 2 itens por linha
                                crossAxisSpacing: 10, // Espaço entre os itens horizontalmente
                                mainAxisSpacing: 10, // Espaço entre os itens verticalmente
                                childAspectRatio: 1 / 1.0, // Proporção de aspecto (largura/altura)
                              ),
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                // ignore: sized_box_for_whitespace
                                child: Container(
                                  width: 0,
                                  height: 0,
                                  color: Colors.blue,
                                  child: ListTile(
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Center(
                                          child: Text(
                                            filteredWatchUser[index]['Where_Watch'] == 'Prime Video'
                                                      ? 'Prime Video'
                                                      :  filteredWatchUser[index]['Where_Watch'] == 'Disney +'
                                                          ? 'Disney +'
                                                          :  filteredWatchUser[index]['Where_Watch'] == 'Netflix'
                                                              ? 'Netflix'
                                                              :  filteredWatchUser[index]['Where_Watch'] == 'GloboPlay'
                                                              ? 'Globo' 
                                                              :  filteredWatchUser[index]['Where_Watch'] == 'HBO Max'
                                                              ? 'HBO Max'
                                                              : filteredWatchUser[index]['Where_Watch'] == 'Crunchyroll'
                                                              ? 'Crunchyroll'
                                                              :  filteredWatchUser[index]['Where_Watch'] == 'Pirata'
                                                              ? 'Pirata'
                                                              : 'Error', // Caso não seja nenhum dos três
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                        Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 100,
                                              height: 100,
                                              color: Colors.grey,
                                              child:Text(
                                                  filteredWatchUser[index]['Type'] == 'Série'
                                                      ? 'S'
                                                      : filteredWatchUser[index]['Type'] == 'Movie'
                                                          ? AppLocalizations.of(context)!.m
                                                          : filteredWatchUser[index]['Type'] == 'Anime'
                                                              ? 'A'
                                                              : 'Erro', // Caso não seja nenhum dos três
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 5,),
                                           Center(
                                             child: Text(filteredWatchUser[index]['Name'], 
                                              style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),),
                                           ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                             IconButton(
                                                onPressed: () {
                                                  
                                                }, icon: const Icon(Icons.favorite),
                                                color: Colors.red,
                                                iconSize: 25,),
                                            Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          // ignore: unnecessary_string_interpolations
                                          child: Text("${filteredWatchUser[index]['Rating'].toString()}.0", 
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15),
                                            ),
                                        ),
                                        Padding(
                                              padding: const EdgeInsets.only(right: 0.0,),
                                              child: IconButton(
                                                onPressed: () {
                                                  
                                                }, icon: const Icon(Icons.bookmark_add_outlined,
                                                color: Colors.white,),
                                                iconSize: 25,),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    ),
          ],
          ),
        ),
    );
  }
}