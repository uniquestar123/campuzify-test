import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:masterstudy_app/data/models/assignment/assignment_response.dart';

class AssignmentInfoWidget extends StatelessWidget {
  const AssignmentInfoWidget(this.assignmentResponse) : super();

  final AssignmentResponse assignmentResponse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 7.0),
            child: Text(
              assignmentResponse.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: Color(0xFF273044),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 7.0, left: 7.0),
            child: Html(
              data: assignmentResponse.content,
            ),
          ),
        ],
      ),
    );
  }
}
