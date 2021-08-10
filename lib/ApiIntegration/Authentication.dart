import 'dart:convert';

import 'package:http/http.dart' as http;

const ReadUrl = 'http://www.nkrtest.xyz/public/api/login';

class BackEndServiceAuthentication {
  Future<ProfileDetails> getAuthenticationDetails(username, password) async {
    var map = new Map<String, dynamic>();
    map['uname'] = username;
    map['pword'] = password;

    final response = await http.post(Uri.parse(ReadUrl), body: map);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        ProfileDetails _profileDetails = ProfileDetails(
            name: data['user']['Uname'],
            id: data['user']['member_id'],
            description: 'success');
        return _profileDetails;
      } else {
        ProfileDetails _profileDetails =
            ProfileDetails(name: 'error', id: 'error', description: 'error');
        return _profileDetails;
      }
    } else {
      ProfileDetails _profileDetails =
          ProfileDetails(name: 'error', id: 'error', description: 'error');
      return _profileDetails;
    }
  }
}

class ProfileDetails {
  String name;
  String id;
  String description;
  ProfileDetails(
      {required this.name, required this.id, required this.description});
}
