import 'dart:convert';
import 'dart:ui';
import 'package:bananasplit/DataModels/FeedData.dart';
import 'package:bananasplit/DataModels/GroupMember.dart';
import 'package:bananasplit/DataModels/Owe.dart';
import 'dart:developer' as Debug;
import 'package:bananasplit/homePage.dart' as homePage;
import 'package:flutter/material.dart';

class Group {
  String name;
  String id;
  Color color;
  Icon icon;

  List<String> groupMemberIds;
  List<GroupMember> groupMember = List<GroupMember>();

  List<String> groupOweIds;
  List<Owe> groupOwes = List<Owe>();
  List<Owe> optimizedOweList = List<Owe>();

  double overallAmount = 0;
  double overallAmountdone = 0;
  double overallAmountBalance = 1;

  FeedData groupFeed = FeedData();

  getGroupFeed() async {
    groupOwes.forEach((element) {
      groupFeed.addUserFeedElement(element);
    });
  }

  Group(String id, String name, List<String> groupMemberIds,
      List<String> groupOweIds, int colorHex, Icon icon) {
    this.id = id;
    this.name = name;
    this.color = Color(colorHex);
    this.groupMemberIds = groupMemberIds;
    this.groupOweIds = groupOweIds;
    this.icon = icon;
  }

  void getGroupMembers() {
    homePage.allUsers.forEach((element) {
      for (int i = 0; i < groupMemberIds.length; i++) {
        if (element.id == groupMemberIds[i]) {
          GroupMember member =
              GroupMember(element.id, element.name, element.email);
          groupMember.add(member);
        }
      }
    });
  }

  void getGroupOwes() {
    homePage.allOwes.forEach((element) {
      for (int i = 0; i < groupOweIds.length; i++) {
        if (element.id == groupOweIds[i]) {
          groupOwes.add(element);

          //set MemberAmounts that are not paid
          if (!element.isPaid) {
            groupMember.forEach((member) {
              if (member.id == element.creditor.id) {
                member.plusAmountInGroup += element.amountOverall;
              }
              if (member.id == element.debtor.id) {
                member.minusAmountInGroup += element.amountOverall;
              }
              member.oweIdsWithUserNotPaid.add(element.id);
            });
          }

          //set all MemberAmounts
          groupMember.forEach((member) {
            if (member.id == element.creditor.id) {
              member.creditorAmount += element.amountOverall;
            }
          });
        }
      }
    });
    getGroupOverallAmount();
    getGroupFeed();
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    int iconHex = int.parse(json["icon"]);
    Icon icon = Icon(Icons.airplay_sharp);

    switch (iconHex) {
      case 59870:
        icon = Icon(Icons.shopping_cart);
        break;
      case 60048:
        icon = Icon(Icons.train);
        break;
      case 59168:
        icon = Icon(Icons.fastfood);
        break;
      case 58940:
        icon = Icon(Icons.card_travel);
        break;
    }

    return Group(
        json['id'] as String,
        json['name'] as String,
        List<String>.from(json["membersId"].map((x) => x)),
        List<String>.from(json["owesId"].map((x) => x)),
        int.parse(json['color'], radix: 16) + 0xFF000000,
        icon);
  }

  void getGroupOverallAmount() {
    overallAmount = 0;
    overallAmountdone = 0;
    groupOwes.forEach((owe) {
      overallAmount += owe.amountOverall;
      if (owe.isPaid) {
        overallAmountdone += owe.amountOverall;
      }
    });
    if (overallAmount != 0) {
      overallAmountBalance = (overallAmountdone / overallAmount);
    }
  }
}
