import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer' as Debug;
import 'homePage.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var authUserId = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserCredential user;

  final GlobalKey<FormState> _formKeyRegister = GlobalKey<FormState>();
  final TextEditingController _emailControllerRegister =
      TextEditingController();
  final TextEditingController _passwordControllerRegister =
      TextEditingController();
  bool _successRegister;
  String _userEmailRegister;

  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();
  final TextEditingController _emailControllerLogin = TextEditingController();
  final TextEditingController _passwordControllerLogin =
      TextEditingController();
  // variable wird benutzt
  // ignore: unused_field
  bool _successLogin;
  // variable wird benutzt
  // ignore: unused_field
  String _userEmailLogin;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    Debug.log("SignPage: auth: " + _auth.currentUser.toString());
    super.initState();
  }

  @override
  void dispose() {
    _emailControllerRegister.dispose();
    _passwordControllerRegister.dispose();
    _emailControllerLogin.dispose();
    _passwordControllerLogin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFECF0F1),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
            Container(
              height: MediaQuery.of(context).size.height /
                  2.5, //TODO: "2.5" durch 2 ersetzen
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                      height: 200.0,
                      width: 200.0,
                      image: new AssetImage('Assets/Logo.png'),
                      fit: BoxFit.fill),
                  Text("BananaSplit",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20))
                ],
              ),
            ),
            TabBar(
              indicatorColor: Color(0xFFFDD835),
              unselectedLabelColor: Colors.black,
              labelColor: Colors.black,
              //indicator: new BoxDecoration(color: Color(0xFFFDD835), borderRadius: BorderRadius.circular(18.0),
              // border: Border.all(color: Color(0xFF000000), width: 1)
              indicator: new BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xFFFDD835), width: 10)),
              ),

              tabs: [
                Tab(text: 'Anmelden', icon: Icon(Icons.login)),
                Tab(text: 'Registrieren', icon: Icon(Icons.assignment))
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            SizedBox(height: 10),
            Expanded(

              child: TabBarView(
                children: [
                  Form(
                    key: _formKeyLogin,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _emailControllerLogin,
                          decoration: new InputDecoration(
                            labelText: 'Email',
                            //  contentPadding: const EdgeInsets.all(20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(0xFF000000), width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(0xFF000000), width: 2.0),
                            ),
                          ),

                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Bitte etwas eingeben';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2),
                        TextFormField(
                          controller: _passwordControllerLogin,
                          decoration: new InputDecoration(
                            labelText: 'Passwort',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(0xFF000000), width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(0xFF000000), width: 2.0),
                            ),
                          ),

                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Bitte etwas eingeben';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),

                        Container(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            color: Color(0xFFFDD835),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Color(0xFF000000)),
                            ),
                            onPressed: () async {
                              if (_formKeyLogin.currentState.validate()) {
                                _signInWithEmailAndPasswort();
                              }
                            },
                            child: const Text('Anmelden'),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          alignment: Alignment.center,
                          
                          child: RaisedButton(
                            color: Color(0xFFFDD835),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: Color(0xFF000000)),
                            ),
                            onPressed: () {
                              _signInDebug();
                            },
                            child: Text('Anmelden mit Beispielkonto'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Form(
                    key: _formKeyRegister,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          
                          controller: _emailControllerRegister,
                          decoration: new InputDecoration(
                            labelText: "Enter Email",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color(0xFF000000),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(0xFF000000), width: 2.0),
                            ),
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Bitte etwas eingeben';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 2),
                        TextFormField(
                          controller: _passwordControllerRegister,
                          decoration: new InputDecoration(
                            labelText: 'Passwort',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(0xFF000000), width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color(0xFF000000),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Bitte etwas eingeben';
                            }
                            return null;
                          },
                        ),
                        Text('Passwort muss mindestens 6 Zeichen lang sein.'),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          alignment: Alignment.center,
                          child: RaisedButton(
                            color: Color(0xFFFDD835),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Color(0xFF000000)),
                            ),

                            onPressed: () async {
                              if (_formKeyRegister.currentState.validate()) {
                                _register();
                              }
                            },
                            child: const Text('Registrieren'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(_successRegister == null
                              ? ''
                              : (_successRegister
                                  ? 'Erfolgreich registriert ' +
                                      _userEmailRegister
                                  : 'Registrierung fehlgeschlagen')),
                        )
                      ],
                    ),
                  ),
                ],
                controller: _tabController,
              ),
           ),
          ],
        ),
      ),
    );
  }


  void _register() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailControllerRegister.text,
      password: _passwordControllerRegister.text,
    ))
        .user;
    if (user != null) {
      await addUserToDB(); //Add User To DB
      navigateToHomePage();
      setState(() {
        _successRegister = true;
        _userEmailRegister = user.email;
      });
    } else {
      setState(() {
        _successRegister = false;
      });
    }
  }

  Future<int> countUsersOnDB() async {
    int count;
    await databaseReference.child('/users').once().then((onValue) {
      List<dynamic> data = onValue.value;
      count = data.length;
    });
    return count;
  }

  addUserToDB() async {
    var nameOfUser = "";
    int counter = await countUsersOnDB();
    await createAlertDialog(context)
        .then((value) => nameOfUser = value.toString());

    await databaseReference.child('users/$counter').set({
      'id': _auth.currentUser.uid,
      'email': _auth.currentUser.email,
      'name': nameOfUser,
      'groupIds': ['G0'],
    });
  }

  Future<int> positionInDB() async {
    int tmpUserPosition;
    var dbRefAllUser = databaseReference.child('users/');
    List<dynamic> allUserDynamic;
    await dbRefAllUser
        .once()
        .then((snapshot) => {allUserDynamic = snapshot.value});
    int index = 0;
    allUserDynamic.forEach((element) {
      if (element["id"] == _auth.currentUser.uid.toString()) {
        tmpUserPosition = index;
      }
      index++;
    });
    return tmpUserPosition;
  }

  Future<bool> checkIfUserExistsOnDB() async {
    int position = await positionInDB();
    bool userOnDB = false;
    if (position != null) {
      userOnDB = true;
    }
    return userOnDB;
  }

  Future<bool> checkIfUserHasNameOnDB() async {
    bool tmpState = false;
    int position = await positionInDB();
    var dbRef = databaseReference.child('users/$position/name');
    await dbRef.once().then((value) => {
          if (value.value != null) {tmpState = true} else {tmpState = false}
        });
    return tmpState;
  }

//Creates Dialog to get name of user and add to db
  addNameOfUserToDB() async {
    var tmpUserName = "";
    await createAlertDialog(context)
        .then((value) => tmpUserName = value.toString());
    databaseReference.child('users/${positionInDB()}').update({
      'name': tmpUserName,
    });
  }

//Debug Login
  void _signInDebug() async {
    bool tmpExists = false;
    bool tmpHasName = false;

    final User user = (await _auth.signInWithEmailAndPassword(
      email: 'test.user@gmx.de',
      password: '123456',
    ))
        .user;
    if (user != null) {
      if (await checkIfUserExistsOnDB() == true) {
        print('user exists on DB');
        tmpExists = true;
        if (await checkIfUserHasNameOnDB() == false) {
          print('user has no name on DB');
          await addNameOfUserToDB();
          print('added name to user');
          tmpHasName = true;
        } else {
          print('user has name');
          tmpHasName = true;
        }
      } else if (await checkIfUserExistsOnDB() == false) {
        print('user does not exists on DB');
        await addUserToDB();
        tmpExists = true;
        tmpHasName = true;
      }

      setState(() {
        _successLogin = true;
        _userEmailLogin = user.email;
      });
      if (tmpExists && tmpHasName) {
        navigateToHomePage();
      }
    } else {
      setState(() {
        _successLogin = false;
      });
    }
  }

  void _signInWithEmailAndPasswort() async {
    bool tmpExists = false;
    bool tmpHasName = false;
    final User user = (await _auth.signInWithEmailAndPassword(
      email: _emailControllerLogin.text,
      password: _passwordControllerLogin.text,
    ))
        .user;
//Check if user exists on DB or has name
    if (user != null) {
      if (await checkIfUserExistsOnDB() == true) {
        print('user exists on DB');
        tmpExists = true;
        if (await checkIfUserHasNameOnDB() == false) {
          await addNameOfUserToDB();
          tmpHasName = true;
        } else {
          tmpHasName = true;
        }
      } else if (await checkIfUserExistsOnDB() == false) {
        print('user does not exists on DB');
        await addUserToDB();
        tmpExists = true;
        tmpHasName = true;
      }

      setState(() {
        _successLogin = true;
        _userEmailLogin = user.email;
      });
      if (tmpExists && tmpHasName) {
        navigateToHomePage();
      }
    } else {
      setState(() {
        _successLogin = false;
      });
    }
  }

  void navigateToHomePage() async {
    print("Currentuser: " + _auth.currentUser.toString());
    Navigator.pushReplacementNamed(context, '/homepage');
  }

//Creates Alert Dialog
  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    bool validate = false;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Welchen Namen möchten Sie verwenden?'),
            content: TextField(
              controller: userNameController,
              decoration: InputDecoration(
                labelText: 'Namen eingeben',
                errorText: validate ? null : 'Feld darf nicht leer sein!',
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 0.5,
                  child: Text('Bestätigen'),
                  onPressed: () {
                    print('${userNameController.text.isEmpty}');
                    print('${userNameController.text.isNotEmpty}');
                    setState(() {
                      userNameController.text.isEmpty
                          ? validate = false
                          : validate = true;
                    });
                    if (validate) {
                      Navigator.of(context)
                          .pop(userNameController.text.toString());
                    }
                  })
            ],
          );
        });
  }
}
