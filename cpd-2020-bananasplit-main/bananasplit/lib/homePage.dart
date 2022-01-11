import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import './Screens/FirstPage.dart' as first;
import './Screens/SecondPage.dart' as second;
import './Screens/ThirdPage.dart' as third;
import 'package:bananasplit/DataModels/Owe.dart';
import 'DataBaseAdder.dart';
import 'DataModels/FeedData.dart';
import 'DataModels/Group.dart';
import 'DataModels/GroupMember.dart';
import 'DataModels/User.dart';
import 'dart:developer' as Debug;
import 'dart:convert';
import './SignPage.dart' as signPage;
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'SignPage.dart';

final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

User user;
final dbRef = signPage.databaseReference;
List<String> groupNames = [];
List<String> groupMember = [];

List<User> allUsers = List<User>();
List<Map<String, dynamic>> mapAllUsers = List<Map<String, dynamic>>();

List<Group> allGroups = List<Group>();

List<Map<String, dynamic>> mapAllGroups = List<Map<String, dynamic>>();

List<Owe> allOwes = List<Owe>();
List<Map<String, dynamic>> mapAllOwes = List<Map<String, dynamic>>();

List<Group> userGroups;

FeedData feedData = FeedData();

//DEBUG
List<GroupMember> debugDebtorList = List<GroupMember>();

Future<bool> getData() async {
  if (allGroups.isNotEmpty) {
    allGroups.removeRange(0, allGroups.length);
    mapAllGroups.removeRange(0, mapAllGroups.length);
  }
  var dbRefAllGroups = databaseReference.child('groups/');
  List<dynamic> allGroupsDynamic;
  await dbRefAllGroups.once().then((value) => {
        allGroupsDynamic = value.value,
      });
  allGroupsDynamic.forEach((value) {
    mapAllGroups.add(Map<String, dynamic>.from(value));
  });
  mapAllGroups.forEach((element) {
    allGroups.add(Group.fromJson(element));
  });

  if (allOwes.isNotEmpty) {
    if (allOwes.length == 1) {
      allOwes.removeAt(0);
      mapAllOwes.remove(0);
    } else {
      allOwes.removeRange(0, allOwes.length);
      mapAllOwes.removeRange(0, mapAllOwes.length);
    }
  }
  var dbRefAllOwes = databaseReference.child('owes/');
  List<dynamic> allOwesDynamic;
  await dbRefAllOwes.once().then((value) => {
        allOwesDynamic = value.value,
      });
  allOwesDynamic.forEach((value) {
    mapAllOwes.add(Map<String, dynamic>.from(value));
  });
  mapAllOwes.forEach((element) {
    allOwes.add(Owe.fromJson(element));
  });

  if (allUsers.isNotEmpty) {
    mapAllUsers.removeRange(0, mapAllUsers.length);
    allUsers.removeRange(0, allUsers.length);
  }
  var dbRefAllUser = databaseReference.child('users/');
  List<dynamic> allUserDynamic;
  await dbRefAllUser.once().then((value) => {
        allUserDynamic = value.value,
      });
  allUserDynamic.forEach((value) {
    mapAllUsers.add(Map<String, dynamic>.from(value));
  });

  mapAllUsers.forEach((element) {
    allUsers.add(User.fromJson(element));
  });

  //make login the active user
  allUsers.forEach((element) {
    if (element.id == _auth.currentUser.uid.toString()) {
      user = element;
    }
  });

  await user.getUserGroups();
  await user.getUserOwes();
  await user.getFriends();
  await user.calculateAmounts();
  groupNames = [];
  groupMember = [];
  user.groupsList.forEach((group) {
    groupNames.add(group.name);
    group.groupMember.forEach((element) {
      groupMember.add(element.name);
    });
  });

  Debug.log("Alle Daten sind geladen.");

  //DEBUG
  debugDebtorList.add(user.friendsList[1]);

  return true;
}

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    print("called initState");
    controller = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    print("called dispose");
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Scaffold(
                appBar: new AppBar(
                  centerTitle: true,
                  title: new Text(
                    "BananaSplit",
                    style: TextStyle(color: Color(0xFFFBC02D)),
                  ),
                  backgroundColor: Colors.grey, //
                  actions: <Widget>[
                    new IconButton(
                      icon: Icon(Icons.settings),
                      color: Color(0xFFFBC02D),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settings()));
                      },
                    ),
                  ],
                  leading: Image(image: AssetImage('Assets/Logo.png')),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Ausgabe();
                        });
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Color(0xFFFBC02D),
                ),
                bottomNavigationBar: Container(
                  color: Colors.grey,
                  child: new TabBar(
                      controller: controller,
                      indicatorColor: Color(0xFFFBC02D),
                      tabs: <Tab>[
                        new Tab(
                            icon:
                                new Icon(Icons.home, color: Color(0xFFFBC02D))),
                        new Tab(
                            icon: new Icon(Icons.person,
                                color: Color(0xFFFBC02D))),
                        new Tab(
                            icon: new Icon(Icons.group,
                                color: Color(0xFFFBC02D))),
                      ]),
                ),
                body: new TabBarView(
                  controller: controller,
                  children: <Widget>[
                    new first.First(controller),
                    new second.Second(controller),
                    new third.Third(controller)
                  ],
                ));
          } else {
            return Container(
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                          image: AssetImage('Assets/Logo.png'),
                          height: 300,
                          width: 300),
                      new Text('laden ...',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold))
                    ]));
          }
        });
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Settings", style: TextStyle(color: Color(0xFFFBC02D))),
        backgroundColor: Color(0x00000000),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: new SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(children: [
                ExpansionTile(
                  title: Text('AGBs'),
                  children: <Widget>[
                    Text(
                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.   Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.   Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.   Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl'),
                  ],
                ),
              ]),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(children: [
                ExpansionTile(
                  title: Text('Impressum'),
                  children: <Widget>[
                    Text(
                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.   Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.   Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.   Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl'),
                  ],
                ),
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () {
                  logoutAndNavigateToSignIn();
                },
                child: const Text('Abmelden'),
              ),
            ),
          ]))),
    );
  }

  void logoutAndNavigateToSignIn() async {
    /* //Kann nicht gefunden werden weil in Signpage die nächste View mit pushReplacementNamed geladen wird um nicht zurück navigieren zu können
    await _auth.signOut().whenComplete(
        () => Navigator.of(context).popUntil(ModalRoute.withName('/')));
    */
    await _auth
        .signOut()
        .whenComplete(() => Navigator.of(context).pushReplacementNamed('/'));
  }
}

class Ausgabe extends StatefulWidget {
  @override
  _AusgabeState createState() => new _AusgabeState();
}

class _AusgabeState extends State<Ausgabe> {
  String dropdownValue = groupNames[0];
  String holder = '';
  bool mem = true;

  bool calculateOwnAmountInOwe = true;

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  final ausgabeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ausgabeController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: Container(
          width: 420,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Ausgabe hinzufügen', textAlign: TextAlign.center),
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () => {
                      Navigator.pop(context),
                    })
          ]),
        ),
        content: Container(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.group),
                      SizedBox(
                        width: 20,
                      ),
                      new DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        onChanged: (String data) {
                          setState(() {
                            dropdownValue = data;
                          });
                        },
                        items: groupNames
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]),
                    TextField(
                      controller: ausgabeController,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.money,
                          color: Colors.black,
                        ),
                        labelText: 'Betrag',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    new CheckboxListTile(
                      activeColor: Color(0xFFFBC02D),
                      checkColor: Colors.black,
                      title: Text("Eigenanteil inbegriffen"),
                      value: calculateOwnAmountInOwe,
                      onChanged: (value) {
                        setState(() {
                          calculateOwnAmountInOwe = value;
                        });
                        build(context);
                      },
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            Text("Speichern", style: TextStyle(fontSize: 20)),
                        onPressed: () => {
                          getDropDownItem(),
                          user.groupsList.forEach((element) {
                            if (holder == element.name) {
                              DataBaseAdder.addOweToDB(
                                  double.parse(ausgabeController.text),
                                  element,
                                  calculateOwnAmountInOwe);
                              return;
                            }
                          }),
                          Navigator.pop(context),
                        },
                        color: Color(0xFFFBC02D),
                        textColor: Colors.black,
                      )
                    ]),
                  ]),
            )));
  }
}
