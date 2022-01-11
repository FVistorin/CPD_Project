import 'dart:ui';
import 'package:bananasplit/DataModels/GroupMember.dart';
import 'package:bananasplit/DataModels/Group.dart';
import 'package:bananasplit/SignPage.dart' as signPage;
import 'dart:developer' as Debug;
import 'package:flutter/material.dart';
import 'package:bananasplit/homePage.dart' as homePage;

import 'DataModels/Owe.dart';

class DataBaseAdder {
  //ADD GROUPS

  static void addGroupToDB(
      String name, int iconCode, Color color, List<GroupMember> members) async {
    int groupCount = await countGroupsOnDB();
    List<String> membersString = List<String>();
    members.forEach((element) {
      membersString.add(element.id);
    });

    String groupId = "G" + (groupCount + 1).toString();

    String hexColorSixDigits =
        0.toString() + (color.value - 0xFF000000).toRadixString(16).padLeft(5);
    String hexIconSixDigits = "0x" + (iconCode).toRadixString(16);

    //set group in DB
    await signPage.databaseReference.child('/groups/$groupCount').set({
      'color': hexColorSixDigits,
      'id': groupId,
      'membersId': membersString,
      'name': name,
      'owesId': ["O0"],
      'icon': hexIconSixDigits,
    });

    //set groups in each user in DB
    members.forEach((element) async {
      int positionInDb = await userPositionOnDB(element.id);
      int userGroupsCount = await countUserGroupsOnDB(element.id);

      await signPage.databaseReference
          .child('/users/$positionInDb/groupIds/')
          .update({
        '$userGroupsCount': groupId,
      });
    });
  }

  static Future<int> countGroupsOnDB() async {
    int count;
    await signPage.databaseReference.child('/groups').once().then((onValue) {
      List<dynamic> data = onValue.value;
      count = data.length;
    });
    return count;
  }

  static Future<int> countUserGroupsOnDB(String memberId) async {
    int count;
    int userPositionInDb = await userPositionOnDB(memberId);
    await signPage.databaseReference
        .child('/users/$userPositionInDb/groupIds')
        .once()
        .then((onValue) {
      List<dynamic> data = onValue.value;
      count = data.length;
    });
    return count;
  }

  static Future<int> userPositionOnDB(String memberId) async {
    int tmpUserPosition;
    var dbRefAllUser = signPage.databaseReference.child('users/');
    List<dynamic> allUserDynamic;
    await dbRefAllUser
        .once()
        .then((snapshot) => {allUserDynamic = snapshot.value});
    int index = 0;
    allUserDynamic.forEach((element) {
      if (element["id"] == memberId) {
        tmpUserPosition = index;
      }
      index++;
    });
    return tmpUserPosition;
  }
  //////////////////////////////////////////////////////////////////////////////

  //ADD OWES

  static void addOweToDB(
      double amount, Group group, bool calculateOwnAmountInOwe) async {
    String hexGroupColorSixDigits =
        (group.color.value - 0xFF000000).toRadixString(16).padLeft(5);
    int groupPositionInDb = await groupPositionOnDB(group.id);
    int groupOweCountInDb = await countGroupOwesOnDB(group);
    int oweCount = await countOwesOnDB();
    double amountSet;

    if (!calculateOwnAmountInOwe) {
      amountSet = amount / (group.groupMember.length - 1);
    } else {
      amountSet = (amount - (amount / group.groupMember.length)) /
          (group.groupMember.length - 1);
    }

    group.groupMember.forEach((element) async {
      if (element.id != homePage.user.id) {
        String oweId = "O" + (oweCount + 1).toString();

        //set owe in DB (/owes)
        signPage.databaseReference.child('/owes/$oweCount').set({
          'amount': amountSet,
          'creditorEmail': homePage.user.email,
          'creditorId': homePage.user.id,
          'creditorName': homePage.user.name,
          'debtorEmail': element.email,
          'debtorId': element.id,
          'debtorName': element.name,
          'groupColor': hexGroupColorSixDigits,
          'groupId': group.name,
          'id': oweId,
          'initDate': DateTime.now().toString(),
          'isPaid': false,
        });
        Debug.log("set in /owes");

        //set owe in DB (/groups)
        signPage.databaseReference
            .child('/groups/$groupPositionInDb/owesId/')
            .update({
          '$groupOweCountInDb': oweId,
        });
        Debug.log("set in /groups");
        groupOweCountInDb++;
        oweCount++;
      }
    });
  }

  static Future<int> countOwesOnDB() async {
    int count;
    await signPage.databaseReference.child('/owes').once().then((onValue) {
      List<dynamic> data = onValue.value;
      count = data.length;
    });
    return count;
  }

  static Future<int> owePositionOnDb(String oweId) async {
    int tmpOwePosition;
    var dbRefAllUser = signPage.databaseReference.child('owes/');
    List<dynamic> allOwesDynamic;
    await dbRefAllUser
        .once()
        .then((snapshot) => {allOwesDynamic = snapshot.value});
    int index = 0;
    allOwesDynamic.forEach((element) {
      if (element["id"] == oweId) {
        tmpOwePosition = index;
      }
      index++;
    });
    return tmpOwePosition;
  }

  static Future<int> groupPositionOnDB(String groupId) async {
    int tmpGroupPosition;
    var dbRefAllUser = signPage.databaseReference.child('groups/');
    List<dynamic> allUserDynamic;
    await dbRefAllUser
        .once()
        .then((snapshot) => {allUserDynamic = snapshot.value});
    int index = 0;
    allUserDynamic.forEach((element) {
      if (element["id"] == groupId) {
        tmpGroupPosition = index;
      }
      index++;
    });
    return tmpGroupPosition;
  }

  static Future<int> countGroupOwesOnDB(Group group) async {
    int count;
    int groupPositionOnDb = await groupPositionOnDB(group.id);
    await signPage.databaseReference
        .child('/groups/$groupPositionOnDb/owesId')
        .once()
        .then((onValue) {
      List<dynamic> data = onValue.value;
      count = data.length;
    });
    return count;
  }

  static Future<int> countUserOwesOnDB(String userId) async {
    int count;
    int userPositionOnDb = await userPositionOnDB(userId);
    await signPage.databaseReference
        .child('/users/$userPositionOnDb/owesId')
        .once()
        .then((onValue) {
      List<dynamic> data = onValue.value;
      count = data.length;
    });
    return count;
  }
////////////////////////////////////////////////////////////////////////////////

  //ADD MEMBER TO GROUP

  static void addUserToGroupToDB(Group group, GroupMember member) async {
    int groupPositionInDb = await groupPositionOnDB(group.id);
    int groupMemberCount = await countGroupsMemberOnDB(group);

    int memberPositionInDb = await userPositionOnDB(member.id);
    int memberGroupsCount = await countUserGroupsOnDB(member.id);

    //set member in DB (/groups)
    await signPage.databaseReference
        .child('/groups/$groupPositionInDb/membersId/')
        .update({
      '$groupMemberCount': member.id,
    });

    //set group in DB (/users)
    await signPage.databaseReference
        .child('/users/$memberPositionInDb/groupIds/')
        .update({
      '$memberGroupsCount': group.id,
    });
  }

  static Future<int> countGroupsMemberOnDB(Group group) async {
    int count;
    int groupPositionInDb = await groupPositionOnDB(group.id);

    await signPage.databaseReference
        .child('/groups/$groupPositionInDb/membersId')
        .once()
        .then((onValue) {
      List<dynamic> data = onValue.value;
      count = data.length;
    });
    return count;
  }

////////////////////////////////////////////////////////////////////////////////

  //PAY OWE

  static void payOweToDB(String oweId) async {
    int owePositionInDb = await owePositionOnDb(oweId);

    //set isPaid=true in (/owes)
    await signPage.databaseReference.child('/owes/$owePositionInDb').update({
      'isPaid': true,
    });
  }
}
