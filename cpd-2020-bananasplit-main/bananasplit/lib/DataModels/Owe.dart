import 'dart:ui';
import 'package:bananasplit/DataModels/GroupMember.dart';
import 'dart:developer' as Debug;

class Owe {
  String id;
  GroupMember creditor;
  GroupMember debtor;

  //for Feed
  String group;
  Color groupColor;

  double amountOverall;

  Image icon;

  DateTime oweCreateDate;
  String oweCreateDateDayMonthYear;

  DateTime owePaidDate;
  bool isPaid = false;

  Owe(
      String id,
      String creditorId,
      String creditorEmail,
      String creditorName,
      String debtorId,
      String debtorEmail,
      String debtorName,
      double amount,
      int groupColorHex,
      String group,
      String oweCreateDate,
      bool isPaid) {
    this.id = id;
    this.creditor = creditor;
    this.debtor = debtor;
    this.amountOverall = amount;
    groupColor = Color(groupColorHex);
    this.group = group;
    this.oweCreateDate = DateTime.tryParse(oweCreateDate);
    oweCreateDateDayMonthYear = this.oweCreateDate.day.toString() +
        "." +
        this.oweCreateDate.month.toString() +
        "." +
        this.oweCreateDate.year.toString();
    this.icon = getIcon();
    this.isPaid = isPaid;

    creditor = GroupMember(creditorId, creditorName, creditorEmail);
    debtor = GroupMember(debtorId, debtorName, debtorEmail);
  }

  factory Owe.fromJson(Map<String, dynamic> json) {
    return Owe(
        json['id'] as String,
        json['creditorId'] as String,
        json['creditorEmail'] as String,
        json['creditorName'] as String,
        json['debtorId'] as String,
        json['debtorEmail'] as String,
        json['debtorName'] as String,
        json['amount'].toDouble(),
        int.parse(json['groupColor'], radix: 16) + 0xFF000000,
        json['groupId'] as String,
        json['initDate'] as String,
        json['isPaid'] as bool);
  }

  void pay() {
    owePaidDate = DateTime.now();
    isPaid = true;
  }

  Image getIcon() {
    Image image;
    /*switch (category) {
      case OweCategory.Bildung:
        {
          // statements;
        }
        break;
      case OweCategory.Einkaufen:
        {
          // statements;
        }
        break;
      case OweCategory.Lebensmittel:
        {
          // statements;
        }
        break;
      case OweCategory.Party:
        {
          // statements;
        }
        break;
      case OweCategory.Reisen:
        {
          // statements;
        }
        break;
      case OweCategory.Restaurant:
        {
          // statements;
        }
        break;
      case OweCategory.Verkehrsmittel:
        {
          // statements;
        }
        break;

      default:
        {
          //statements;
        }
        break;
    } */
    return image;
  }
}

enum OweCategory {
  Reisen,
  Restaurant,
  Einkaufen,
  Lebensmittel,
  Party,
  Verkehrsmittel,
  Bildung
}
enum PaidStatus { None, Partially, Done }
