import 'package:bananasplit/DataBaseAdder.dart';
import 'package:bananasplit/DataModels/FeedData.dart';
import 'package:bananasplit/DataModels/User.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as Debug;
import 'package:bananasplit/homePage.dart' as homePage;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

List<UserFeedElement> userFeedElements =
    homePage.user.userFeed.userFeedElements;
User user = homePage.user;

List<String> userFeedTitlesDate = [];
List<double> userFeedTitlesAmount = [];
List<Icon> userFeedTitlesIcon = [];
List<String> userFeedTitlesName = [];
List<String> userFeedTitlesGroup = [];
List<Color> userFeedGroupColor = [];
List<Icon> userFeedTitlesPayIcon = [];
List<String> userFeedOweIds = [];
List<bool> userFeedOweIsPaid = [];
double paymentAmount;

int pressedFeedElementIndex;

class GroupFeedLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myGroupView(context);
  }
}

Widget _myGroupView(BuildContext context) {
  final titles = [
    'Schulden aktualisiert',
    'Schulden beglichen',
    'Schulden aktualisiert',
  ];

  return ListView.builder(
    itemCount: titles.length,
    itemBuilder: (context, index) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.grey[200],
        child: ListTile(
          title: Text(titles[index]),
        ),
      );
    },
  );
}

class FeedLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myFeedView(context);
  }
}

Future<bool> getUserFeed() async {
  userFeedTitlesDate = [];
  userFeedTitlesAmount = [];
  userFeedTitlesIcon = [];
  userFeedTitlesName = [];
  userFeedTitlesGroup = [];
  userFeedGroupColor = [];
  userFeedTitlesPayIcon = [];
  userFeedOweIds = [];
  userFeedOweIsPaid = [];

  userFeedElements = homePage.user.userFeed.userFeedElements;

  userFeedElements.forEach((element) {
    String datetext = element.createDateDayMonthYear + "  ";
    String nametext;
    Icon indicator;
    String grouptext;
    Color groupColor;
    Icon payIndicator;

    if (element.debtor.id == homePage.user.id) {
      indicator = Icon(
        Icons.remove,
        color: Colors.red,
      );
    } else {
      indicator = Icon(
        Icons.add,
        color: Colors.green,
      );
    }
    if (element.debtor.id == homePage.user.id) {
      nametext = element.creditor.name + " ";
    } else {
      nametext = element.debtor.name.toString();
    }

    if (element.isPaid) {
      payIndicator = Icon(Icons.monetization_on, color: Colors.green);
    } else {
      payIndicator = Icon(Icons.monetization_on, color: Colors.grey[300]);
    }

    grouptext = element.group;
    groupColor = element.groupColor;

    userFeedTitlesDate.add(datetext);
    userFeedTitlesName.add(nametext);
    userFeedTitlesAmount.add(element.amount);
    userFeedTitlesIcon.add(indicator);
    userFeedTitlesGroup.add(grouptext);
    userFeedGroupColor.add(groupColor);
    userFeedTitlesPayIcon.add(payIndicator);
    userFeedOweIds.add(element.oweId);
    userFeedOweIsPaid.add(element.isPaid);
  });
  return true;
}

Widget _myFeedView(BuildContext context) {
  return FutureBuilder(
      future: getUserFeed(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: userFeedTitlesDate.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.grey[200],
                child: ListTile(
                    onTap: () {
                      if (userFeedOweIsPaid[index] == false &&
                          userFeedElements[index].creditor.id !=
                              homePage.user.id) {
                        pressedFeedElementIndex = index;
                        paymentAmount = userFeedTitlesAmount[index];
                        showDialog(
                            context: context,
                            builder: (_) {
                              return PaymentPopUp();
                            });
                      }
                    },
                    title: Wrap(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userFeedTitlesDate[index],
                              style: TextStyle(fontSize: 12.0),
                            ),
                            userFeedTitlesPayIcon[index],
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userFeedTitlesName[index],
                                  style: TextStyle(fontSize: 18.0)),
                              Text(
                                userFeedTitlesGroup[index],
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: userFeedGroupColor[index]),
                              ),
                            ])
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 30,
                      children: [
                        Text(
                          NumberFormat.simpleCurrency(locale: 'eu')
                              .format(userFeedTitlesAmount[index])
                              .toString(),
                          style: TextStyle(fontSize: 20.0),
                        ),
                        userFeedTitlesIcon[index],
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

Future<bool> getUserData() async {
  userFeedElements = homePage.user.userFeed.userFeedElements;
  user = homePage.user;

  return true;
}

Widget _userInfo(BuildContext context) {
  return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Image.asset('Assets/User.png', height: 80, width: 80),
                    //moin
                    new Text(user.name)
                  ]),
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.green),
                      SizedBox(width: 10),
                      Text(
                          'Dir wird geschuldet: ' +
                              NumberFormat.simpleCurrency(locale: 'eu')
                                  .format(user.plusAmount)
                                  .toString(),
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
                            width: MediaQuery.of(context).size.width - 150,
                            animation: true,
                            lineHeight: 15.0,
                            animationDuration: 2500,
                            percent: user.plusAmountBalancePercent / 100,
                            center: Text(
                              NumberFormat.simpleCurrency(locale: 'eu')
                                  .format(user.plusAmountdone)
                                  .toString(),
                            ),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.green,
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.remove, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        'Du schuldest: ' +
                            NumberFormat.simpleCurrency(locale: 'eu')
                                .format(user.minusAmount)
                                .toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(1),
                          child: new LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 150,
                            animation: true,
                            lineHeight: 15.0,
                            animationDuration: 2500,
                            percent: user.minusAmountBalancePercent / 100,
                            center: Text(
                              NumberFormat.simpleCurrency(locale: 'eu')
                                  .format(user.minusAmountdone)
                                  .toString(),
                            ),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.red,
                          )),
                    ],
                  ),
                ],
              ),
            ]),
          ]);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      });
}

class First extends StatefulWidget {
  TabController controller;
  First(this.controller);
  @override
  FirstState createState() => new FirstState();
}

class FirstState extends State<First> {
  Future<Null> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      setState(() {
        homePage.getData();
        widget.controller.index = 2;
        Future.delayed(Duration(milliseconds: 500), () {
          widget.controller.index = 0;
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
                  child: _userInfo(context),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Row(children: <Widget>[
                      Expanded(
                          child: Divider(thickness: 1.5, color: Colors.black)),
                      SizedBox(width: 15),
                      Text(
                        "Feed",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: Divider(thickness: 1.5, color: Colors.black)),
                    ]),
                    Container(
                        height: 450,
                        child: RefreshIndicator(
                          child: FeedLayout(),
                          onRefresh: _handleRefresh,
                        )),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class PaymentPopUp extends StatefulWidget {
  @override
  _PaymentPopUpState createState() => new _PaymentPopUpState();
}

class _PaymentPopUpState extends State<PaymentPopUp> {
  int radioValue = 0;

  void _handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: Container(
          width: 350,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Schulden begleichen', textAlign: TextAlign.center),
            IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () => {
                      Navigator.pop(context),
                    })
          ]),
        ),
        content: Container(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Betrag: ' +
                        NumberFormat.simpleCurrency(locale: 'eu')
                            .format(paymentAmount)
                            .toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text("Kreditkarte"),
                    leading: Icon(Icons.payment),
                    trailing: Radio(
                        activeColor: Colors.black,
                        value: 0,
                        groupValue: radioValue,
                        onChanged: _handleRadioValueChanged),
                  ),
                  ListTile(
                    title: Text("PayPal"),
                    leading: Icon(Icons.book_online),
                    trailing: Radio(
                        activeColor: Colors.black,
                        value: 1,
                        groupValue: radioValue,
                        onChanged: _handleRadioValueChanged),
                  ),
                  ListTile(
                    title: Text("In Bar"),
                    leading: Icon(Icons.money),
                    trailing: Radio(
                        activeColor: Colors.black,
                        value: 2,
                        groupValue: radioValue,
                        onChanged: _handleRadioValueChanged),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Bezahlen", style: TextStyle(fontSize: 20)),
                      onPressed: () => {
                        DataBaseAdder.payOweToDB(
                            userFeedOweIds[pressedFeedElementIndex]),
                        Navigator.pop(context),
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
