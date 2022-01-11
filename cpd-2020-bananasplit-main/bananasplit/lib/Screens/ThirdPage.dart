import 'package:bananasplit/DataModels/Group.dart';
import 'package:bananasplit/DataModels/GroupMember.dart';
import 'package:flutter/material.dart';
import 'package:bananasplit/homePage.dart' as homePage;
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:developer' as Debug;
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../DataBaseAdder.dart';
import 'Indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bananasplit/DataModels/User.dart';

List<Group> userGroups;
List<GroupMember> friendsList;
List<String> groupMember = [];
List<String> addMember = [];
User user = homePage.user;
Group actualGroup;
List<String> groupFeedTitlesDate = [];
List<double> groupFeedTitlesAmount = [];
List<Icon> groupFeedTitlesPayIcon = [];
List<String> groupFeedTitlesName = [];
List<String> groupFeedTitlesGroup = [];
List<Color> groupFeedGroupColor = [];
List<GroupMember> memberChecked = List<GroupMember>();

List<String> icon = ['shopping_cart', 'train', 'fastfood', 'card_travel'];
int iconInt = 0xe9de;
List<int> iconInts = [0xe9de, 0xea90, 0xe720, 0xe63c];

List<int> color = [0xFFEF5350, 0xFF81D4FA, 0xFFA5D6A7, 0xFFBA68C8];

Future<bool> getData() async {
  userGroups = homePage.user.groupsList;
  friendsList = homePage.user.friendsList;
  groupMember = [];
  user.groupsList.forEach((group) {
    group.groupMember.forEach((element) {
      groupMember.add(element.name);
      addMember.add(element.name);
    });
  });

  //addMember.removeWhere((element) => addMember == friendsList);

  return true;
}

class Third extends StatefulWidget {
  TabController controller;
  Third(this.controller);

  @override
  ThirdState createState() => new ThirdState();
}

class ThirdState extends State<Third> {
  Future<Null> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      setState(() {
        homePage.getData();
        widget.controller.index = 0;
        Future.delayed(Duration(milliseconds: 500), () {
          widget.controller.index = 2;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x00000000),
      body: Container(
          padding: EdgeInsets.all(20),
          color: Color(0x00000000),
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(children: <Widget>[
                  Expanded(child: Divider(thickness: 1.5, color: Colors.black)),
                  SizedBox(width: 15),
                  Text(
                    "Deine Gruppen",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(width: 15),
                  Expanded(child: Divider(thickness: 1.5, color: Colors.black)),
                ]),
                SizedBox(height: 20),
                Container(
                  child: GroupAddElementCard(),
                ),
                Expanded(
                  child: RefreshIndicator(
                    child: GroupListView(),
                    onRefresh: _handleRefresh,
                  ),
                ),
              ])),
    );
  }
}

class AddGroup extends StatefulWidget {
  @override
  _AddGroupState createState() => new _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  int colordropdownValue = color[0];
  String icondropdownValue = icon[0];
  int colorholder;
  String iconholder = '';
  bool mem = false;

  void getColorDropDownItem() {
    setState(() {
      colorholder = colordropdownValue;
    });
  }

  void getIconDropDownItem() {
    setState(() {
      iconholder = icondropdownValue;
    });
  }

  List<bool> distinctMemberisChecked;

  final gruppenname = TextEditingController();

  @override
  void dispose() {
    gruppenname.dispose();
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
            Text('Gruppe hinzufügen', textAlign: TextAlign.center),
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
                  TextField(
                    controller: gruppenname,
                    decoration: InputDecoration(
                      icon: Icon(Icons.group),
                      labelText: 'Gruppenname',
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.category, color: Colors.grey),
                      SizedBox(width: 15),
                      new DropdownButton<String>(
                        value: icondropdownValue,
                        items: icon.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontFamily: 'MaterialIcons'),
                            ),
                          );
                        }).toList(),
                        onChanged: (String newicon) {
                          setState(() {
                            icondropdownValue = newicon;

                            switch (newicon) {
                              case "shopping_cart":
                                iconInt = 0xe9de;
                                break;
                              case "train":
                                iconInt = 0xea90;
                                break;
                              case "fastfood":
                                iconInt = 0xe720;
                                break;
                              case "card_travel":
                                iconInt = 0xe63c;
                                break;
                            }
                          });
                        },
                      ),
                      SizedBox(width: 15),
                      Icon(Icons.color_lens, color: Colors.grey),
                      SizedBox(width: 15),
                      new DropdownButton<int>(
                        value: colordropdownValue,
                        items: color.map((int value) {
                          return new DropdownMenuItem<int>(
                              value: value,
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(color: Color(value)),
                                child: Text(
                                  '',
                                  style: TextStyle(color: Color(value)),
                                ),
                              ));
                        }).toList(),
                        onChanged: (int newcolor) {
                          setState(() {
                            colordropdownValue = newcolor;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 250,
                    child: ListView.builder(
                        itemCount: friendsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Card(
                              child: new Container(
                                  width: 100,
                                  padding:
                                      new EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Column(children: <Widget>[
                                    new CheckboxListTile(
                                      activeColor: Color(0xFFFBC02D),
                                      checkColor: Colors.black,
                                      title: Text(friendsList[index].name),
                                      value: friendsList[index].isCheck,
                                      onChanged: (value) {
                                        setState(() {
                                          friendsList[index].isCheck = value;
                                        });
                                        build(context);
                                      },
                                    )
                                  ])));
                        }),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Mitglied einladen',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Speichern", style: TextStyle(fontSize: 20)),
                      onPressed: () => {
                        if (memberChecked.length != 0)
                          {
                            memberChecked.clear(),
                          },
                        friendsList.forEach((element) {
                          if (element.isCheck) {
                            memberChecked.add(element);
                          }
                        }),
                        getIconDropDownItem(),
                        memberChecked.add(GroupMember(homePage.user.id,
                            homePage.user.name, homePage.user.email)),
                        DataBaseAdder.addGroupToDB(gruppenname.text, iconInt,
                            Color(colordropdownValue), memberChecked),
                        Navigator.pop(context)
                      },
                      color: Color(0xFFFBC02D),
                      textColor: Colors.black,
                    )
                  ]),
                ],
              ),
            )));
  }
}

class AddGroupMember extends StatefulWidget {
  @override
  _AddGroupMemberState createState() => new _AddGroupMemberState();
}

class _AddGroupMemberState extends State<AddGroupMember> {
  List<GroupMember> memberNotInGroup = List<GroupMember>();

  initState() {
    super.initState();

    actualGroup.groupMember.forEach((element) {
      element.isCheck = false;
    });

    friendsList.forEach((element) {
      if (!memberNotInGroup.contains(element) &&
          !actualGroup.groupMemberIds.contains(element.id)) {
        memberNotInGroup.add(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: Container(
          width: 420,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Mitglieder hinzufügen', textAlign: TextAlign.center),
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
                  Container(
                    height: 250,
                    child: ListView.builder(
                        itemCount: memberNotInGroup.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Card(
                              child: new Container(
                                  width: 100,
                                  padding:
                                      new EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Column(children: <Widget>[
                                    new CheckboxListTile(
                                      activeColor: Color(0xFFFBC02D),
                                      checkColor: Colors.black,
                                      title: Text(memberNotInGroup[index].name),
                                      value: memberNotInGroup[index].isCheck,
                                      onChanged: (value) {
                                        setState(() {
                                          memberNotInGroup[index].isCheck =
                                              value;
                                        });
                                        build(context);
                                      },
                                    )
                                  ])));
                        }),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Mitglied einladen',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Speichern", style: TextStyle(fontSize: 20)),
                      onPressed: () => {
                        memberNotInGroup.forEach((member) {
                          if (member.isCheck) {
                            DataBaseAdder.addUserToGroupToDB(
                                actualGroup, member);
                          }
                        }),
                        Navigator.pop(context),
                        homePage.getData(),
                      },
                      color: Color(0xFFFBC02D),
                      textColor: Colors.black,
                    )
                  ]),
                ],
              ),
            )));
  }
}

class GroupListView extends StatefulWidget {
  @override
  GroupListViewState createState() => new GroupListViewState();
}

class GroupListViewState extends State<GroupListView> {
  @override
  Widget build(BuildContext context) {
    return _groupListView(context);
  }
}

Widget _groupListView(BuildContext context) {
  return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: userGroups.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: userGroups[index].color,
                  child: ListTile(
                    title: Text(
                      userGroups[index].name,
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      actualGroup = userGroups[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SpecificGroup()));
                    },
                  ),
                );
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      });
}

class GroupAddElementCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _groupAddElementCard(context);
  }
}

Widget _groupAddElementCard(BuildContext context) {
  return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color(0xFFFBC02D),
      child: ListTile(
        title: Wrap(alignment: WrapAlignment.center, children: [
          Text('    Gruppe   ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Icon(Icons.group_add_rounded),
          Text('   hinzufügen',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
        ]),
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return AddGroup();
              });
        },
      ));
}

class MemberAddElementCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _memberAddElementCard(context);
  }
}

Widget _memberAddElementCard(BuildContext context) {
  return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white60,
      child: ListTile(
        title: Wrap(alignment: WrapAlignment.center, children: [
          Text('    Mitglied   ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Icon(Icons.person_add_rounded),
          Text('   hinzufügen',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
        ]),
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return AddGroupMember();
              });
        },
      ));
}

class SpecificGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(actualGroup.name,
              style: TextStyle(color: Color(0xFFFBC02D))),
          backgroundColor: Color(0x00000000),
        ),
        backgroundColor: actualGroup.color,
        body: Container(
          padding: EdgeInsets.all(20),
          color: Color(0x00000000),
          child: new SingleChildScrollView(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 40,
                                      child: Icon(actualGroup.icon.icon,
                                          size: 38, color: Colors.black)),
                                  new Text(actualGroup.name)
                                ]),
                            SizedBox(width: 10),
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 30),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: Colors.green),
                                    SizedBox(width: 10),
                                    Text(
                                        'Bezahlt von:' +
                                            '  ' +
                                            (NumberFormat.simpleCurrency(
                                                    locale: 'eu')
                                                .format(
                                                    actualGroup.overallAmount)
                                                .toString()),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))
                                  ],
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.all(1),
                                        child: new LinearPercentIndicator(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150,
                                          animation: true,
                                          lineHeight: 25.0,
                                          animationDuration: 2500,
                                          percent:
                                              actualGroup.overallAmountBalance,
                                          center: Text((NumberFormat
                                                  .simpleCurrency(locale: 'eu')
                                              .format(
                                                  actualGroup.overallAmountdone)
                                              .toString())),
                                          linearStrokeCap:
                                              LinearStrokeCap.roundAll,
                                          progressColor: Colors.green,
                                        )),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ])
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Row(children: <Widget>[
                      Expanded(
                          child: Divider(thickness: 1.5, color: Colors.black)),
                      SizedBox(width: 15),
                      Text(
                        "Schulden",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: Divider(thickness: 1.5, color: Colors.black)),
                    ]),
                    Container(height: 200, child: groupFeed(context)),
                    Row(children: <Widget>[
                      Expanded(
                          child: Divider(thickness: 1.5, color: Colors.black)),
                      SizedBox(width: 15),
                      Text(
                        "Mitglieder",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: Divider(thickness: 1.5, color: Colors.black)),
                    ]),
                    Container(
                      child: MemberAddElementCard(),
                    ),
                    Container(height: 200, child: friendsList(context)),
                    Row(children: <Widget>[
                      Expanded(
                          child: Divider(thickness: 1.5, color: Colors.black)),
                      SizedBox(width: 30),
                      Text(
                        "Statistik",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: Divider(thickness: 1.5, color: Colors.black)),
                    ]),
                    Container(height: 250, child: barChart()),
                    SizedBox(width: 40),
                    Row(children: <Widget>[
                      Expanded(
                          child: Divider(thickness: 1.5, color: Colors.black)),
                      SizedBox(width: 30),
                      Text(
                        "Ausgabenverteilung",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: Divider(thickness: 1.5, color: Colors.black)),
                    ]),
                    Container(height: 250, child: PieChartGraph()),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  List<charts.Series> memberListGraph = List<charts.Series>();

  static List<charts.Series<GraphBarItem, String>> _createGraphData() {
    List<GraphBarItem> graphBarData = [];
    actualGroup.groupMember.forEach((member) {
      if (member.plusAmountInGroup == 0) {
        member.plusAmountInGroup = 1;
      }
      if (member.minusAmountInGroup == 0) {
        member.minusAmountInGroup = 1;
      }
      graphBarData.add(GraphBarItem(
          member.name, member.plusAmountInGroup, member.minusAmountInGroup));
    });

    return [
      charts.Series<GraphBarItem, String>(
        id: 'Mitglieder',
        domainFn: (GraphBarItem graphBarItem, _) => graphBarItem.name,
        measureFn: (GraphBarItem graphBarItem, _) => graphBarItem.plusAmount,
        data: graphBarData,
        fillColorFn: (GraphBarItem graphBarItem, _) {
          return charts.MaterialPalette.green.shadeDefault;
        },
      ),
      charts.Series<GraphBarItem, String>(
        id: 'Mitglieder',
        domainFn: (GraphBarItem graphBarItem, _) => graphBarItem.name,
        measureFn: (GraphBarItem graphBarItem, _) => graphBarItem.minusAmount,
        data: graphBarData,
        fillColorFn: (GraphBarItem graphBarItem, _) {
          return charts.MaterialPalette.red.shadeDefault;
        },
      )
    ];
  }

  Future<bool> getSpecificGroupData() async {
    //feed
    groupFeedTitlesDate = [];
    groupFeedTitlesName = [];
    groupFeedTitlesAmount = [];
    groupFeedTitlesPayIcon = [];
    groupFeedTitlesGroup = [];
    groupFeedGroupColor = [];

    actualGroup.groupFeed.userFeedElements.forEach((element) {
      String datetext = element.createDateDayMonthYear + "  ";
      String nametext = element.debtor.name + " an " + element.creditor.name;
      Icon payIcon;
      String grouptext;
      Color groupColor;

      if (element.isPaid) {
        payIcon = Icon(Icons.monetization_on, color: Colors.green);
      } else {
        payIcon = Icon(Icons.monetization_on, color: Colors.grey[300]);
      }

      groupColor = element.groupColor;
      groupFeedTitlesDate.add(datetext);
      groupFeedTitlesName.add(nametext);
      groupFeedTitlesAmount.add(element.amount);
      groupFeedTitlesPayIcon.add(payIcon);
      groupFeedTitlesGroup.add(grouptext);
      groupFeedGroupColor.add(groupColor);
    });

    //barGraph
    memberListGraph = _createGraphData();

    return true;
  }

  Widget groupFeed(BuildContext context) {
    return FutureBuilder(
        future: getSpecificGroupData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: groupFeedTitlesDate.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.grey[200],
                  child: ListTile(
                      title: Wrap(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(groupFeedTitlesDate[index],
                                  style: TextStyle(fontSize: 12.0)),
                              groupFeedTitlesPayIcon[index]
                            ],
                          ),
                          Column(children: [
                            Text(groupFeedTitlesName[index],
                                style: TextStyle(fontSize: 18.0))
                          ]),
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 20,
                        children: [
                          Text(
                            NumberFormat.simpleCurrency(locale: 'eu')
                                .format(groupFeedTitlesAmount[index])
                                .toString(),
                            style: TextStyle(fontSize: 20.0),
                          )
                        ],
                      )),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  //member
  Widget friendsList(BuildContext context) {
    return ListView.builder(
      itemCount: actualGroup.groupMember.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.grey[200],
          child: ListTile(
            title: Text(actualGroup.groupMember[index].name +
                "                                     " +
                actualGroup.groupMember[index].email),
          ),
        );
      },
    );
  }

  barChart() {
    return charts.BarChart(
      memberListGraph,
      animate: true,
      animationDuration: Duration(milliseconds: 3000),
      vertical: false,
      barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
        strokeWidthPx: 1.0,
      ),
    );
  }
}

class GraphBarItem {
  final String name;
  final double plusAmount;
  final double minusAmount;

  GraphBarItem(this.name, this.plusAmount, this.minusAmount);
}

class PieChartGraph extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State {
  int touchedIndex;

  static List<Widget> _createPieDataIndicator() {
    List<Widget> pieDataIndicator = [];
    int index = 0;
    actualGroup.groupMember.forEach((member) {
      Color _color;
      switch (index) {
        case 0:
          _color = Color(0xff0293ee);
          index++;
          break;
        case 1:
          _color = Color(0xff845bef);
          index++;
          break;
        case 2:
          _color = Color(0xff13d38e);
          index++;
          break;
        case 3:
          _color = Color(0xfff8b250);
          index = 0;
          break;
      }
      Indicator indicator =
          Indicator(text: member.name, isSquare: true, color: _color);
      SizedBox sizedBox = SizedBox(height: 4);
      pieDataIndicator.add(indicator);
      pieDataIndicator.add(sizedBox);
    });

    return pieDataIndicator;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        if (pieTouchResponse.touchInput is FlLongPressEnd ||
                            pieTouchResponse.touchInput is FlPanEnd) {
                          touchedIndex = -1;
                        } else {
                          touchedIndex = pieTouchResponse.touchedSectionIndex;
                        }
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections()),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _createPieDataIndicator(),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> sectionList = List<PieChartSectionData>();
    int index = 0;

    actualGroup.groupMember.forEach((member) {
      if (member.creditorAmount == 0) {
        return;
      }
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      Color _color;
      switch (index) {
        case 0:
          _color = Color(0xff0293ee);
          break;
        case 1:
          _color = Color(0xff845bef);
          break;
        case 2:
          _color = Color(0xff13d38e);
          break;
        case 3:
          _color = Color(0xfff8b250);
          break;

        default:
          _color = Color(0xff0293ee);
          break;
      }
      String percent =
          (((member.creditorAmount / actualGroup.overallAmount) * 100).toInt())
                  .toString() +
              "%";

      sectionList.add(PieChartSectionData(
        color: _color,
        value: member.creditorAmount / actualGroup.overallAmount,
        title: isTouched
            ? percent
            : NumberFormat.simpleCurrency(locale: 'eu')
                .format(member.creditorAmount)
                .toString(),
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      ));
      index++;
    });
    return sectionList;
  }
}
