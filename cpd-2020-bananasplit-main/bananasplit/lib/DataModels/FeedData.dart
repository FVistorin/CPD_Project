import 'package:bananasplit/DataModels/GroupMember.dart';
import 'package:flutter/material.dart';

import 'Owe.dart';
import 'Group.dart';
import 'dart:developer' as Debug;
import 'package:bananasplit/homePage.dart' as homePage;
import 'package:bananasplit/Screens/FirstPage.dart' as FirstPage;

class FeedData {
  List<UserFeedElement> userFeedElements = List<UserFeedElement>();

  void addUserFeedElement(Owe owe) {
    UserFeedElement element = UserFeedElement(owe);
    userFeedElements.add(element);
  }
}

class FeedElement {
  String group;
  Color groupColor;
  GroupMember creditor;
  GroupMember debtor;
  double amount;
  bool isPaid;
  String oweId;

  String createDateDayMonthYear;

  FeedElement(Owe owe) {
    group = owe.group;
    groupColor = owe.groupColor;
    creditor = owe.creditor;
    debtor = owe.debtor;
    amount = owe.amountOverall;
    isPaid = owe.isPaid;
    createDateDayMonthYear = owe.oweCreateDateDayMonthYear;
    oweId = owe.id;
  }
}

class UserFeedElement extends FeedElement {
  PayDirection direction = PayDirection.Minus;
  UserFeedElement(Owe owe) : super(owe) {
    if (owe.creditor.id == homePage.user.id) {
      direction = PayDirection.Plus;
    }
  }
}

enum PayDirection { Plus, Minus }
