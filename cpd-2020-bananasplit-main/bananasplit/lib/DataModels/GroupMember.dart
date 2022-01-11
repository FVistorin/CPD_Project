class GroupMember {
  String id;
  String name;
  String email;
  bool isCheck = false;

  //for second page (if groupMember is friend). Only owes that are not paid
  double overallAmountWithUser = 0;
  List<String> oweIdsWithUserNotPaid = [];

  //for third page
  double plusAmountInGroup = 0;
  double minusAmountInGroup = 0;
  double creditorAmount = 0;

  GroupMember(String id, String name, String email) {
    this.id = id;
    this.name = name;
    this.email = email;
  }

  factory GroupMember.fromJson(dynamic json) {
    return GroupMember(
        json['id'] as String, json['name'] as String, json['email']);
  }
}
