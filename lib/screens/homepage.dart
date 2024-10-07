// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:watch/screens/createWatch.dart';
import 'package:watch/screens/menu/profile.dart';
import 'package:watch/screens/profileFriend.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:watch/updateCheck.dart';
//import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) changeLanguage;
  final int userID;
  final String user;
  const Homepage({
    super.key,
    required this.changeLanguage,
    required this.selectedLanguage,
    required this.userID,
    required this.user});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

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
  List friendIDsList = []; 

  Future<void> deleteFriend(String friendID) async {
  final response = await http.post(
    //Uri.parse('http://192.168.5.159/deleteFriendList.php'),
    Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/deleteFriendList.php'),
    
    body: {
      'ID_UserOne': widget.userID.toString(),
      'ID_UserTwo': friendID,
    }
  );

  print(response.body);

  if (response.statusCode == 200) {
    
  } else {
    throw Exception('Failed');
  }
}

 Future<void> countFriends() async {
  final response = await http.post(
    //Uri.parse('http://192.168.5.159/friendlist.php'),
    Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/friendList.php'),
    body: {'user': widget.user},
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    
    // Extrair a lista de amigos (IDs e nomes)
    List friends = data['friends'];
    
    // Listas separadas para IDs e Nomes
    List<String> friendNames = [];
    List<String> friendIDs = [];

    // Iterar pela lista de amigos
    for (var friend in friends) {
      friendNames.add(friend['friendName']);
      friendIDs.add(friend['friendID'].toString());
    }

    setState(() {
      // Atualizar o estado com as listas separadas
      usersFriend = friendNames; // Lista apenas com os nomes dos amigos
      friendIDsList = friendIDs; // Lista apenas com os IDs dos amigos
      rowCountFriend = data['numberOfFriends']; // Número de amigos
    });
  } else {
    throw Exception('Failed');
  }
}


  Future<void> requestCount() async {
  final response = await http.post(
    //Uri.parse('http://192.168.5.159/requestCount.php'),
    Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/requestCount.php'),
    body: {'user': widget.user},
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
      setState(() {
        rowCount = data['rowCount']; 
      });
  } else {
    throw Exception('Failed');
  }
}

  Future<void> requestUsers() async {
  final response = await http.post(
    //Uri.parse('http://192.168.5.159/requestList.php'),
    Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/requestList.php'),
    body: {'user': widget.user},
  );

  if (response.statusCode == 200) {
    if (response.body.isEmpty) {
      
    } else {
      print(response.body);
    var data = jsonDecode(response.body);
      setState(() {
        testeRequest = data['userRequest'];
        idtesteRequest = data['ID_UserRequest'];
      });
  } 
  } else {
    throw Exception('Failed');
    }
    
}

  Future<void> acceptFriend() async {
  final response = await http.post(
    //Uri.parse('http://192.168.5.159/acceptFriend.php'),
    Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/acceptFriend.php'),
    body: {
      'ID_UserOne': idtesteRequest.toString(),
      'userOne': testeRequest,
      'ID_UserTwo': idtesteRequest,
      'userTwo': widget.user,
      },
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Friend accept!')),
          );
          print(response.body);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed!')),
          );
    throw Exception('Failed');
  }
}

  Future<void> rejectFriend() async {
  final response = await http.post(
    //Uri.parse('http://192.168.5.159/rejectFriend.php'),
    Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/rejectFriend.php'),
    body: {
      'ID_UserOne': idtesteRequest.toString(),
      'userOne': testeRequest,
      'ID_UserTwo': idtesteRequest,
      'user_Two': widget.user,},
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Friend rejected!')),
          );
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

  String filter = 'My and Friends';

  Future<void> testeFriend() async {
  final response = await http.post(
    //Uri.parse('http://192.168.5.159/testeFriend.php'),
    Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/testeFriend.php'),
    body: {'user': widget.user},
  );

  if (response.statusCode == 200) {
    print('FUNCIONOU');
    print(response.body);
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

  Future<void> seeWatch() async {
  final response = await http.post(
    //Uri.parse('http://192.168.5.159/seeAll.php'),
    Uri.parse('https://entirely-welcome-jackal.ngrok-free.app/seeAll.php'),
    body: {
      'ID_User': widget.userID.toString(),
      'filter': filter, // Envia o filtro: 'my', 'friends', ou 'my_and_friends'
    },
  );

  print('Response Body AQUI AOUIDHAUIODHAUIDAHSIDA: ${response.body}');

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

      for (var movie in movies) {
      print('Movie Name: ${movie['Name']}, User ID: ${movie['ID_User']}');
    }
    });

   
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

  // ignore: prefer_collection_literals
  Set<String> selectedPlatforms = Set();
  void updateWatchUser() {
  List tempWatchUser = []; 

  // Adicione todos os itens com base no tipo selecionado
  if (allColor) {
    tempWatchUser.addAll(movies);
    tempWatchUser.addAll(series);
    tempWatchUser.addAll(animes);
  } else if (animesColor) {
    tempWatchUser.addAll(animes);
  } else if (moviesColor) {
    tempWatchUser.addAll(movies);
  } else if (seriesColor) {
    tempWatchUser.addAll(series);
  }

  // Filtrar por plataformas selecionadas
  if (selectedPlatforms.isNotEmpty) {
    tempWatchUser = tempWatchUser.where((item) {
      return selectedPlatforms.contains(item['Where_Watch']);
    }).toList();
  }

  // Filtrando por nome, se necessário
  if (searchController.text.isNotEmpty) {
    String nameFilter = searchController.text.toLowerCase();
    tempWatchUser = tempWatchUser.where((item) {
      return item['Name'].toLowerCase().contains(nameFilter);
    }).toList();
  }

  setState(() {
    watchUser = tempWatchUser; // Atualiza a lista exibida
    filteredWatchUser = tempWatchUser;
  });
   // Exibindo os IDs de usuários
  for (var item in filteredWatchUser) {
    print('ID_User: ${item['ID_User']}');
  }
}


  void registerMovie(int userID, String movie, String whereWatch, String category, double rating, String description) async {
  // ignore: prefer_const_declarations
  //final url = 'http://192.168.5.159/registerMovie.php';
  // ignore: prefer_const_declarations
  final url = 'https://entirely-welcome-jackal.ngrok-free.app/registerMovie.php';
  try{
  final response = await http.post(
    Uri.parse(url),
    body: {
      'ID_User': widget.userID,
      'Movie': movie,
      'Where_Watch': whereWatch,
      'Category': category,
      'Rating': rating,
      'Description': description
    },
  );

  // Verifique a resposta do servidor
   if (response.statusCode == 200) {
        final String responseBody = response.body;
        if (responseBody.contains("Movie registered successfully")) {
          // Sucesso no registro
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Movie registered succesfully!')),
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

    var overlayController = OverlayPortalController();
    TextEditingController userReceive = TextEditingController();
    bool showTextField = false;

    var overlayControllerRequests = OverlayPortalController();

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

  void removeItem(String type, int idItem) async {
  //String url = 'http://192.168.5.159/removeItem.php'; // URL do seu script PHP
  String url = 'https://entirely-welcome-jackal.ngrok-free.app/removeItem.php';

  // Monta o corpo da requisição com o ID do item
  var body = {
    'idUser': widget.userID.toString(),
    'type': type,
    'idItem': idItem.toString(), // Adicione o ID do item aqui
  };

  print('Corpo da requisição: $body');

  var response = await http.post(Uri.parse(url), body: body);

  if (response.statusCode == 200) {
    seeWatch();
    print(': ${response.body}');
  } else {
    // Tratar erro de remoção
    print('Erro ao remover o item: ${response.body}');
  }
}

  late String _selectedLanguage;


   @override
  void initState() {
    super.initState();
    //UpdateChecker().checkForUpdates(context);
    _selectedLanguage = widget.selectedLanguage;
    seeWatch(); 
    //requestCount();
    //requestUsers();
    //countFriends();
    searchController.addListener(() {
    filterResults();
  });
    WidgetsBinding.instance.addPostFrameCallback((_) {
    UpdateChecker().checkForUpdates(context); // Verifica atualizações ao iniciar
  });
  }


  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  
   switch(selectedIndex){

    case 0:
    requestCount();
    requestUsers();
    countFriends();
    overlayController.show();

    break;

    case 1:
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => CreateWatch(
          selectedLanguage: _selectedLanguage,
          changeLanguage: widget.changeLanguage,
          userID: widget.userID,
          user: widget.user),));
   }
  }

  bool allColor = true;
  bool animesColor = false;
  bool moviesColor = false;
  bool seriesColor = false;

  bool allStreamingColor = true;
  bool hboMaxColor = false;
  bool netflixColor = false;
  bool globoPlayColor = false;
  bool primeVideoColor = false;
  bool disneyColor = false;
  bool crunchyrollColor = false;
  bool pirateColor = false;
  bool othersColor = false;

  bool myAndFriends = true;
  bool onlyMy = false;
  bool onlyFriends = false;

  List watchUser = [];
  List tempWatchUser = []; 

  void requestFriend(int userRequestID, String userReceive) async {
  // URL do seu arquivo PHP
  // ignore: prefer_const_declarations
  //final url = 'http://192.168.5.159/requestUser.php';
  // ignore: prefer_const_declarations
  final url = 'https://entirely-welcome-jackal.ngrok-free.app/requestUser.php';

  // Corpo da requisição
  final response = await http.post(
    Uri.parse(url),
    body: {
      'ID_UserRequest': userRequestID.toString(),
      'userReceive': userReceive,
    },
  );

  // Verifique a resposta do servidor
  if (response.statusCode == 200) {
    print(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request send!')),
          );
    

    // ignore: non_constant_identifier_names
    

  } else {
    print("Erro na conexão: ${response.statusCode}");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Padding(
          padding: const EdgeInsets.only(left: 2.0),
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
                        
                        const Text(''),
                      ],
                    ),
                  );
                }).toList(),
              ),
        ),
        title: SizedBox(
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
        body: Column(
            children: [
              //* Friends Requests
              OverlayPortal(
                controller: overlayControllerRequests, 
                overlayChildBuilder: (context) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 200,
                      width: 420,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 351.0),
                              child: IconButton(
                                onPressed: () {
                                  overlayControllerRequests.hide();
                                }, icon: const Icon(Icons.close),
                                color: Colors.black,),
                            ),
                              Container(
                                width: 420,
                                height: 30,
                                // height:30
                                color: Colors.black,
                                alignment: Alignment.center,
                                child: Text(AppLocalizations.of(context)!.friendRequest,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20
                                ),
                                ),
                              ),
                              SizedBox(
                      height: 150,
                      child: ListView.builder(
                        itemCount: rowCount,
                        itemBuilder: (context, index) {
                         return ListTile(
                          title: Container(
                            color: Colors.blue,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    acceptFriend();
                                  }, icon: const Icon(Icons.check,
                                  color: Colors.black,),
                                  ),
                                Text(testeRequest,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15
                                ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    rejectFriend();
                                  }, icon: const Icon(Icons.close,
                                  color: Colors.black,),
                                  ),
                              ],
                            ),
                          )
                         );
                        },),
                    ),
                          ],
                        ),
                      ),
                    ),
                  );
                },),
                //* Friends 
              OverlayPortal(
          controller: overlayController, 
          overlayChildBuilder: (context) {
          return Align(
          alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              width: 420,
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                          IconButton(
                            onPressed: () {
                              overlayControllerRequests.show();
                              requestUsers();
                            }, icon: const Icon(Icons.group_add_outlined,
                            size: 30,
                            color: Colors.black,),
                            ),
                            Text('$rowCount',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16
                            ),),
                        Padding(
                          padding: const EdgeInsets.only(left: 300.0),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                overlayController.hide();
                              });
                            }, icon: const Icon(Icons.close,
                            color: Colors.black,)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:0.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (showTextField == false) {
                                  showTextField = true;
                                } else {
                                  showTextField = false;
                                  requestFriend(widget.userID, userReceive.text);
                                }
                              });
                            },
                            icon: showTextField ? const Icon(Icons.check,
                            color: Colors.black,
                            size: 25,)
                            : const Icon(Icons.add, color: Colors.black, size: 25)
                          ),
                          if (showTextField) ...[
                            Padding(
                              padding: const EdgeInsets.only(right: 0.0),
                              child: SizedBox(
                                height: 40,
                                width: 200,
                                child: TextField(
                                  controller: userReceive,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.black,
                                    labelText: AppLocalizations.of(context)!.inserthereuserFriend,
                                    labelStyle: const TextStyle(color: Colors.white),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    showTextField = false;
                                  });
                                }, icon: const Icon(Icons.close,
                                color: Colors.black,))
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 420,
                      height: 30,
                      // height:30
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context)!.friends,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        itemCount: rowCountFriend,
                        itemBuilder: (context, index) {
                         return ListTile(
                          title: Container(
                            color: Colors.blue,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context, MaterialPageRoute(
                                        builder: (context) => Profilefriend(
                                          selectedLanguage: _selectedLanguage,
                                          changeLanguage: widget.changeLanguage,
                                          userID: widget.userID, 
                                          friendID: int.parse(friendIDsList[index]),
                                          user: widget.user  // Converte o String para int
                                            ),
                                          ),
                                        );
                                      }, icon: const Icon(Icons.account_box_rounded,
                                  color: Colors.black,),
                                  ),
                                Text(usersFriend[index],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15
                                ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    String friendIDToDelete = friendIDsList[index].toString();
                                    deleteFriend(friendIDToDelete);
                                  }, icon: const Icon(Icons.remove,
                                  color: Colors.black,),
                                  ),
                                  IconButton(
                                  onPressed: () {
                                    
                                  }, icon: const Icon(Icons.block,
                                  color: Colors.black,),
                                  ),
                              ],
                            ),
                          )
                         );
                        },),
                    ),
                  ],
                ),
              ),
            ),
        );
      },
      ),
      SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 720,
                height: 40,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          allStreamingColor = true;
                          hboMaxColor = false;
                          netflixColor = false;
                          primeVideoColor = false;
                          crunchyrollColor = false;
                          disneyColor = false;
                          globoPlayColor = false;
                          pirateColor = false;
                          othersColor = false;
                          // Limpa a lista de plataformas selecionadas
                          selectedPlatforms.clear();
                          // Adiciona todas as plataformas à lista de selecionados
                          selectedPlatforms.addAll([
                            'HBO Max',
                            'Netflix',
                            'GloboPlay',
                            'PrimeVideo',
                            'Disney+',
                            'Crunchyroll',
                            'Pirata',
                            'Others'
                          ]);
                          updateWatchUser();
                        });
                      },
                      child: Text(AppLocalizations.of(context)!.all,
                        style: TextStyle(
                          color: allStreamingColor ? Colors.black : Colors.grey[600] // 8 é o total de plataformas
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          allStreamingColor = false;
                          hboMaxColor = !hboMaxColor;
                          if (hboMaxColor == false) {
                            selectedPlatforms.remove('HBO Max');
                            updateWatchUser();
                          } else if (allStreamingColor == false && selectedPlatforms.length == 8) {
                            selectedPlatforms.clear();
                            selectedPlatforms.add('HBO Max');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          } else if (allStreamingColor == false && selectedPlatforms.length < 8) {
                            selectedPlatforms.add('HBO Max');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          }
                        });
                      },
                      child: Text('HBO Max',
                        style: TextStyle(
                          color: hboMaxColor ? Colors.black : Colors.grey[600]
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          allStreamingColor = false;
                          netflixColor = !netflixColor;
                          if (netflixColor == false) {
                            selectedPlatforms.remove('Netflix');
                            updateWatchUser();
                         } else if (allStreamingColor == false && selectedPlatforms.length == 8) {
                            selectedPlatforms.clear();
                            selectedPlatforms.add('Netflix');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          } else if (allStreamingColor == false && selectedPlatforms.length < 8) {
                            selectedPlatforms.add('Netflix');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          }
                        });
                      },
                      child: Text('Netflix',
                        style: TextStyle(
                          color: netflixColor ? Colors.black : Colors.grey[600]
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          allStreamingColor = false;
                          globoPlayColor = !globoPlayColor;
                          if (globoPlayColor == false) {
                            selectedPlatforms.remove('GloboPlay');
                            updateWatchUser();
                          } else if (allStreamingColor == false && selectedPlatforms.length == 8) {
                            selectedPlatforms.clear();
                            selectedPlatforms.add('GloboPlay');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          } else if (allStreamingColor == false && selectedPlatforms.length < 8) {
                            selectedPlatforms.add('GloboPlay');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          }
                        });
                      },
                      child: Text('GloboPlay',
                        style: TextStyle(
                          color:globoPlayColor ? Colors.black : Colors.grey[600]
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          allStreamingColor = false;
                          primeVideoColor = !primeVideoColor;
                          if (primeVideoColor == false) {
                            selectedPlatforms.remove('PrimeVideo');
                            updateWatchUser();
                          } else if (allStreamingColor == false && selectedPlatforms.length == 8) {
                            selectedPlatforms.clear();
                            selectedPlatforms.add('PrimeVideo');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          } else if (allStreamingColor == false && selectedPlatforms.length < 8) {
                            selectedPlatforms.add('PrimeVideo');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          }
                        });
                      },
                      child: Text('PrimeVideo',
                        style: TextStyle(
                          color: primeVideoColor ? Colors.black : Colors.grey[600]
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          allStreamingColor = false;
                          disneyColor = !disneyColor;
                          if (disneyColor == false) {
                            selectedPlatforms.remove('Disney+');
                            updateWatchUser();
                          } else if (allStreamingColor == false && selectedPlatforms.length == 8) {
                            selectedPlatforms.clear();
                            selectedPlatforms.add('Disney+');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          } else if (allStreamingColor == false && selectedPlatforms.length < 8) {
                            selectedPlatforms.add('Disney+');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          }
                        });
                      },
                      child: Text('Disney+',
                        style: TextStyle(
                          color: disneyColor ? Colors.black : Colors.grey[600]
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          allStreamingColor = false;
                          crunchyrollColor = !crunchyrollColor;
                          if (crunchyrollColor == false) {
                            selectedPlatforms.remove('Crunchyroll');
                            updateWatchUser();
                          } else if (allStreamingColor == false && selectedPlatforms.length == 8) {
                            selectedPlatforms.clear();
                            selectedPlatforms.add('Crunchyroll');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          } else if (allStreamingColor == false && selectedPlatforms.length < 8) {
                            selectedPlatforms.add('Crunchyroll');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          }
                        });
                      },
                      child: Text('Crunchyroll',
                        style: TextStyle(
                          color: crunchyrollColor ? Colors.black : Colors.grey[600]
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          allStreamingColor = false;
                          pirateColor = !pirateColor;
                          if (pirateColor == false) {
                            selectedPlatforms.remove('Pirate');
                            updateWatchUser();
                          } else if (allStreamingColor == false && selectedPlatforms.length == 8) {
                            selectedPlatforms.clear();
                            selectedPlatforms.add('Pirate');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          } else if (allStreamingColor == false && selectedPlatforms.length < 8) {
                            selectedPlatforms.add('Pirate');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          }
                        });
                      },
                      child: Text(AppLocalizations.of(context)!.pirata,
                        style: TextStyle(
                          color: pirateColor ? Colors.black : Colors.grey[600]
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          allStreamingColor = false;
                          othersColor = !othersColor;
                          if (othersColor == false) {
                            selectedPlatforms.remove('Others');
                            updateWatchUser();
                          } else if (allStreamingColor == false && selectedPlatforms.length == 8) {
                            selectedPlatforms.clear();
                            selectedPlatforms.add('Others');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          } else if (allStreamingColor == false && selectedPlatforms.length < 8) {
                            selectedPlatforms.add('Others');
                            updateWatchUser();
                            print('$selectedPlatforms');
                          }
                        });
                      },
                      child: Text(AppLocalizations.of(context)!.others,
                        style: TextStyle(
                          color: othersColor ? Colors.black : Colors.grey[600]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                          filter = 'My and Friends';
                          myAndFriends = true;
                          onlyMy = false;
                          onlyFriends = false;
                          updateWatchUser();
                          seeWatch();
                        });
                      }, child: Text(AppLocalizations.of(context)!.myAndFriends,
                      style: TextStyle(
                        color: myAndFriends ? Colors.black : Colors.grey[600]
                      ),
                      ),
                      ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          filter = 'Only My';
                          myAndFriends = false;
                          onlyFriends = false;
                          onlyMy = true;
                          print('onlyMY ativo = $filter');
                          seeWatch();
                        });
                      }, child: Text(AppLocalizations.of(context)!.onlyMy,
                      style: TextStyle(
                        color: onlyMy ? Colors.black : Colors.grey[600]
                      ),)),
                      TextButton(
                      onPressed: () {
                        setState(() {
                          filter = 'Only Friends';
                          myAndFriends = false;
                          onlyMy = false;
                          onlyFriends = true;
                          print('onlyFriends ativo =  $filter');
                          seeWatch();
                        });
                      }, child: Text(AppLocalizations.of(context)!.onlyFriends,
                      style: TextStyle(
                        color: onlyFriends ? Colors.black : Colors.grey[600]
                      ),
                      ),
                      ),
                  ],
                ),
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
                      }, child: Text(AppLocalizations.of(context)!.movies,
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
                              childAspectRatio: 1 / 1.2, // Proporção de aspecto (largura/altura)
                            ),
                          itemBuilder: (context, index) {
                            final item = filteredWatchUser[index];
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
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
                                                IconButton(
                                                  onPressed: () {
                                                    if (filteredWatchUser[index]['ID_User'] == widget.userID) {
                                                        // Chamada ao backend para remover o item
                                                        print(filteredWatchUser[index]['Type']);
                                                        print(filteredWatchUser[index]['ID_User']);
                                                        
                                                        removeItem(filteredWatchUser[index]['Type'], filteredWatchUser[index]['ID_User']);
                                                      } else {
                                                        // Exibir um alerta ou mensagem que o item não pode ser removido
                                                        print('Você não pode remover este item. ID do user = ${widget.userID}\n ID do PHP ${item['ID_User']}');
                                                      }
                                                  }, icon: const Icon(Icons.remove,
                                                  size: 20,
                                                  color: Colors.white,))
                                          ],
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
    );
  }
}
