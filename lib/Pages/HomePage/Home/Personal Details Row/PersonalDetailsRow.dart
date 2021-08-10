import 'package:flutter/material.dart';

class PersonalDetailsRow extends StatelessWidget {
  PersonalDetailsRow({this.width, this.title, this.icon});
  final width;
  final title;
  final icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Icon(icon),
        ),
        SizedBox(
          width: width * 0.06,
        ),
        Container(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }
}
