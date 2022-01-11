import 'package:bananasplit/DataModels/FeedData.dart';
import 'package:bananasplit/DataModels/GroupMember.dart';
import 'Group.dart';
import 'Owe.dart';
import 'package:bananasplit/homePage.dart' as homePage;
import 'dart:developer' as Debug;

class User {
  String id;
  String name;
  String email;

  List<GroupMember> friendsList;

  List<String> groupIds = List<String>();
  List<Group> groupsList = List<Group>();

  List<Owe> owesList = List<Owe>();
  FeedData userFeed = FeedData();

  double plusAmount = 0;
  double plusAmountdone = 0;
  int plusAmountBalancePercent = 100;
  double minusAmount = 0;
  double minusAmountdone = 0;
  int minusAmountBalancePercent = 100;

  double overallAmount;

  User(String id, String name, String email, List<String> groupIds) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.groupIds = groupIds;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['id'] as String,
        json['name'] as String,
        json['email'] as String,
        List<String>.from(json["groupIds"].map((x) => x)));
  }

  //selektierung aus homePage.allGroups
  getUserGroups() async {
    homePage.allGroups.forEach((element) {
      for (int i = 0; i < groupIds.length; i++) {
        if (element.id.toString() == groupIds[i].toString()) {
          element.getGroupMembers();
          element.getGroupOwes();
          groupsList.add(element);
        }
      }
    });
  }

  getUserOwes() async {
    userFeed.userFeedElements = [];
    groupsList.forEach((element) {
      element.groupOwes.forEach((element) {
        if (element.debtor.id == id || element.creditor.id == id) {
          owesList.add(element);
          userFeed.addUserFeedElement(element);
        }
      });
    });
  }

  getFriends() async {
    friendsList = List<GroupMember>();
    List<String> friendsIds = [];

    groupsList.forEach((group) {
      group.groupMemberIds.forEach((memberId) {
        if (!friendsIds.contains(memberId)) {
          friendsIds.add(memberId);
        }
      });
    });

    homePage.allUsers.forEach((user) {
      GroupMember member = GroupMember(user.id, user.name, user.email);
      if (friendsIds.contains(user.id) && !friendsList.contains(member)) {
        friendsList.add(member);
      }
    });

    friendsList.forEach((friend) {
      homePage.allOwes.forEach((owe) {
        if (!friend.oweIdsWithUserNotPaid.contains(owe.id) &&
            !owe.isPaid &&
            ((owe.creditor.id == friend.id) || (owe.debtor.id == friend.id))) {
          friend.oweIdsWithUserNotPaid.add(owe.id);
        }
      });
    });

    //delete own person out of friendsList
    for (int i = 0; i < friendsList.length; i++) {
      if (homePage.user.name == friendsList[i].name) {
        friendsList.removeAt(i);
      }
    }
  }

  calculateAmounts() async {
    owesList.forEach((element) {
      if (element.creditor.id == id) {
        plusAmount += element.amountOverall;

        for (int i = 0; i < friendsList.length; i++) {
          if (element.debtor.id == friendsList[i].id && !element.isPaid) {
            friendsList[i].overallAmountWithUser -= element.amountOverall;
          }
        }

        if (element.isPaid == true) {
          plusAmountdone += element.amountOverall;
        }
      }
      if (element.debtor.id == id) {
        minusAmount += element.amountOverall;

        for (int i = 0; i < friendsList.length; i++) {
          if (element.creditor.name == friendsList[i].name && !element.isPaid) {
            friendsList[i].overallAmountWithUser += element.amountOverall;
          }
        }

        if (element.isPaid == true) {
          minusAmountdone += element.amountOverall;
        }
      }
    });

    if (plusAmount != 0) {
      plusAmountBalancePercent = ((plusAmountdone / plusAmount) * 100).toInt();
    }
    if (minusAmount != 0) {
      minusAmountBalancePercent =
          ((minusAmountdone / minusAmount) * 100).toInt();
    }
    overallAmount = plusAmount - minusAmount;

    Debug.log("User: +" +
        plusAmount.toString() +
        "; -" +
        minusAmount.toString() +
        " --> Overall:" +
        overallAmount.toString() +
        " PlusBilanz:" +
        plusAmountBalancePercent.toString() +
        " MinusBilanz:" +
        minusAmountBalancePercent.toString());
  }
}
