import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:watch/screens/createWatch.dart';
import 'package:watch/screens/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:watch/screens/profileFriend.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) changeLanguage;
  final int userID;
  final String user;

  const Profile({
    required this.selectedLanguage,
    required this.changeLanguage,
    required this.userID,
    required this.user,
    super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

   Map<String, dynamic>? userInfo;

   late String _selectedLanguage;


  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
    requisitedUserInfo();
    requestCount();
    requestUsers();
    countFriends();
  }

  // Função para buscar as informações do usuário
  void requisitedUserInfo() async {
    // ignore: prefer_const_declarations
    //final url = 'http://192.168.5.159/selectInfo.php';
    // ignore: prefer_const_declarations
    final url = 'https://entirely-welcome-jackal.ngrok-free.app/selectInfo.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'ID_User': widget.userID.toString()},
      );

      if (response.statusCode == 200) {
        setState(() {
          userInfo = json.decode(response.body);
          // ignore: avoid_print
          print(json.decode(response.body));
        });
      } else {
        throw Exception('Falha ao carregar dados do usuário.');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro: $e');
    }
  }

  void deleteUser() async {
    // ignore: prefer_const_declarations
    //final url = 'http://192.168.5.159/deleteUser.php';
    // ignore: prefer_const_declarations
    final url = 'https://entirely-welcome-jackal.ngrok-free.app/deleteUser.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'ID_User': widget.userID.toString()},
      );

      if (response.statusCode == 200) {
        setState(() {
          Navigator.pushNamed(context, 'login');
          // ignore: avoid_print
          print(response.body);
        });
      } else {
        throw Exception('Falha ao carregar dados do usuário.');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro: $e');
    }
  }

  int rowCount = 0;
  int rowCountFriend = 0;
  List usersRequest = [];
  List usersFriend = [];
  String testeRequest = '';
  List idtesteRequest = [];
  List friendIDsList = []; 

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
    throw Exception('Falha ao carregar dados');
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
    throw Exception('Falha ao carregar dados');
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
            const SnackBar(content: Text('TUDO ERRADO!')),
          );
    throw Exception('Falha ao carregar dados');
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
    throw Exception('Falha ao carregar dados');
  }
}

   var overlayController = OverlayPortalController();
    TextEditingController userReceive = TextEditingController();
    bool showTextField = false;

    var overlayControllerRequests = OverlayPortalController();

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
    throw Exception('Falha ao carregar dados');
  }
}


  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  
   switch(selectedIndex){

    case 0:
    requestCount();
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
    // ignore: avoid_print
    print(response.body);
    

    // ignore: non_constant_identifier_names
    

  } else {
    // ignore: avoid_print
    print("Erro na conexão: ${response.statusCode}");
  }
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
                  user: widget.user),));
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                                    String friendIDToDelete = friendIDsList[index].toString();
                                    deleteFriend(friendIDToDelete);
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
                        '${AppLocalizations.of(context)!.email}: ${userInfo!['Email']}',
                        style: const TextStyle(color: Colors.white),
                      ),
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
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: 150,
                        child: TextButton(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            shape: WidgetStatePropertyAll(
                              LinearBorder(),
                            ),
                          ),
                          onPressed: () {
                            showDialog(context: context, 
                            builder: (context) {
                              return  AlertDialog(
                                backgroundColor: Colors.black,
                                title: Text(AppLocalizations.of(context)!.areyouSure,
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: TextButton(
                                          style: const ButtonStyle(
                                              backgroundColor: WidgetStatePropertyAll(
                                                Colors.white,
                                              ),
                                              shape: WidgetStatePropertyAll(
                                                LinearBorder(),
                                              ),
                                            ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }, child: Text(AppLocalizations.of(context)!.close,
                                          style: const TextStyle(
                                            color: Colors.black
                                          ),
                                          ),
                                          ),
                                      ),
                                        SizedBox(
                                          width: 100,
                                          child: TextButton(
                                          style: const ButtonStyle(
                                              backgroundColor: WidgetStatePropertyAll(
                                                Colors.white,
                                              ),
                                              shape: WidgetStatePropertyAll(
                                                LinearBorder(),
                                              ),
                                            ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            deleteUser();
                                          }, child: Text(AppLocalizations.of(context)!.delete,
                                          style: const TextStyle(
                                            color: Colors.black
                                          ),
                                          ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              );
                            },
                            );
                          }, child: Text(AppLocalizations.of(context)!.deleteAccount,
                          style: const TextStyle(
                            color: Colors.black
                          ),
                          ),
                          ),
                      ),
                      SizedBox(
                        width: 150,
                        child: TextButton(
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            shape: WidgetStatePropertyAll(
                              LinearBorder(),
                            ),
                          ),
                        onPressed: () {
                          Navigator.pushNamed(context, 'login');
                        }, child: Text(AppLocalizations.of(context)!.logout,
                        style: const TextStyle(
                          color: Colors.black
                        ),
                        ),
                        ),
                      ),
                    ],
                  )
                : const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}