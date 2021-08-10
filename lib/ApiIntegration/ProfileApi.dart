import 'dart:convert';

import 'package:http/http.dart' as http;

const personalReadUrl = 'http://www.nkrtest.xyz/public/api/profile/';

class ProfileInfo {
  int id;
  String name;
  String phone;
  String nic;
  String dob;
  String createdAt;
  String isActive;
  String lastMembership;

  ProfileInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.createdAt,
    required this.dob,
    required this.isActive,
    required this.nic,
    required this.lastMembership,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      id: json["id"] as int,
      name: json["Mname"] as String,
      phone: json["Mcontact"] as String,
      createdAt: json["Create_at"] as String,
      dob: json["Mdob"] as String,
      isActive: json["is_active"] as String,
      nic: json["Mnic"] as String,
      lastMembership: json["last_membership"],
    );
  }
}

class MembershipInfo {
  int id;
  String memberId;
  String from;
  String to;
  String registeredBy;
  String createdAt;

  MembershipInfo({
    required this.id,
    required this.createdAt,
    required this.memberId,
    required this.from,
    required this.registeredBy,
    required this.to,
  });

  factory MembershipInfo.fromJson(Map<String, dynamic> json) {
    return MembershipInfo(
      id: json["id"] as int,
      memberId: json["member_id"] as String,
      from: json["from"] as String,
      to: json["to"] as String,
      registeredBy: json["r_by"] as String,
      createdAt: json["Create_at"] as String,
    );
  }
}

class BackEndServiceProfile {
  List<ProfileInfo> detailsFromJson(String jsonString) {
    final data = json.decode(jsonString);
    List<ProfileInfo> profileInfo = [];
    try {
      ProfileInfo _profileInfo = ProfileInfo(
        id: data["member"]["id"],
        name: data["member"]["Mname"],
        phone: data["member"]["Mcontact"],
        createdAt: data["member"]["Create_at"],
        dob: data["member"]["Mdob"],
        isActive: data["member"]["is_active"],
        nic: data["member"]["Mnic"],
        lastMembership: data["last_membership"],
      );

      profileInfo.add(_profileInfo);
    } catch (e) {
      return profileInfo;
    }
    return profileInfo;
  }

  Future getPersonalDetails(int memberId) async {
    final response =
        await http.get(Uri.parse(personalReadUrl + memberId.toString()));
    if (response.statusCode == 200) {
      List<ProfileInfo> list = detailsFromJson(response.body);
      return list;
    } else {
      List<ProfileInfo> list = [];
      return list;
    }
  }

  List<MembershipInfo> membershipFromJson(String jsonString) {
    final data = json.decode(jsonString);

    List<MembershipInfo> membershipInfo = [];
    try {
      for (int i = 0; i < 20; i++) {
        MembershipInfo _membership = MembershipInfo(
          id: data["memberships"][i]["id"],
          memberId: data["memberships"][i]["member_id"],
          from: data["memberships"][i]["from"],
          to: data["memberships"][i]["to"],
          registeredBy: data["memberships"][i]["r_by"],
          createdAt: data["memberships"][i]["Create_at"],
        );
        membershipInfo.add(_membership);
      }
    } catch (e) {
      return membershipInfo;
    }
    return membershipInfo;
  }

  Future getMembershipInfo(int memberId) async {
    final response =
        await http.get(Uri.parse(personalReadUrl + memberId.toString()));
    if (response.statusCode == 200) {
      List<MembershipInfo> list = membershipFromJson(response.body);
      return list;
    } else {
      List<MembershipInfo> list = [];
      return list;
    }
  }
}
