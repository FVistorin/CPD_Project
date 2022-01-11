import 'package:bananasplit/DataModels/GroupMember.dart';
import 'package:flutter/material.dart';
import 'package:bananasplit/homePage.dart' as homePage;
import 'package:intl/intl.dart';
import 'dart:developer' as Debug;

import '../DataBaseAdder.dart';

double popUpAmount;
List<String> owesIds = [];

class SingleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _singleView(context);
  }
}

Widget _singleView(BuildContext context) {
  var userList = [];

  var name = [];
  var amount = [];
  var indicator = [];

  List<GroupMember> friends = homePage.user.friendsList;
  friends.forEach((element) {
    if (element.overallAmountWithUser > 0) {
      name.add(element.name);
      amount.add(element.overallAmountWithUser);
      userList.add(element);

      indicator.add(Icon(
        Icons.remove,
        color: Colors.red,
      ));
    }
    if (element.overallAmountWithUser < 0) {
      name.add(element.name);
      amount.add((element.overallAmountWithUser * -1));
      userList.add(element);

      indicator.add(Icon(
        Icons.add,
        color: Colors.green,
      ));
    }
  });

  return ListView.builder(
    itemCount: name.length,
    itemBuilder: (context, index) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.grey[200],
        child: ListTile(
            title: Text(name[index], style: TextStyle(fontSize: 20)),
            trailing: Wrap(spacing: 30, children: [
              Text(
                NumberFormat.simpleCurrency(locale: 'eu')
                    .format(amount[index])
                    .toString(),
                style: TextStyle(fontSize: 20.0),
              ),
              indicator[index],
            ]),
            onTap: () {
              if (indicator[index].color == Colors.red) {
                popUpAmount = amount[index];
                owesIds = userList[index].oweIdsWithUserNotPaid;

                showDialog(
                    context: context,
                    builder: (_) {
                      return PaymentPopUp();
                    });
              }
            }),
      );
    },
  );
}

class Second extends StatefulWidget {
  TabController controller;

  Second(this.controller);
  @override
  SecondState createState() => new SecondState();
}

class SecondState extends State<Second> {
  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      setState(() {
        homePage.getData();
        widget.controller.index = 0;
        Future.delayed(Duration(milliseconds: 500), () {
          widget.controller.index = 1;
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
                    Expanded(
                        child: Divider(thickness: 1.5, color: Colors.black)),
                    SizedBox(width: 15),
                    Text(
                      "Deine Bilanz",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                        child: Divider(thickness: 1.5, color: Colors.black)),
                  ]),
                  SizedBox(height: 20),
                  Container(
                    height: 400,
                    child: RefreshIndicator(child: SingleView(), onRefresh: _handleRefresh),
                  ),
                ])));
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
          width: 400,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Schulden begleichen', textAlign: TextAlign.center),
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
                  Text(
                    'Betrag: ' +
                        NumberFormat.simpleCurrency(locale: 'eu')
                            .format(popUpAmount)
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
                        owesIds.forEach((element) {
                          DataBaseAdder.payOweToDB(element);
                        }),
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
