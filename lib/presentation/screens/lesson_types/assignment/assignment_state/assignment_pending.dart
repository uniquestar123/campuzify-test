import 'package:flutter/material.dart';
import 'package:masterstudy_app/data/models/assignment/assignment_response.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_parts/assignment_info.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/widgets/file_item_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class AssignmentPendingWidget extends StatelessWidget {
  const AssignmentPendingWidget(this.assignmentResponse) : super();

  final AssignmentResponse assignmentResponse;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFEEF1F7),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: ColorApp.mainColor),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      assignmentResponse.label ?? '',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        color: Color(0xFF273044),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Divider(
          height: 20.0,
          color: Color(0xFFE2E5EB),
          thickness: 2,
        ),
        AssignmentInfoWidget(assignmentResponse),
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: assignmentResponse.files?.length,
            itemBuilder: (context, index) {
              FilesBean item = assignmentResponse.files![index];

              return FileItemWidget(
                valueText: item.data?.name,
              );
            },
          ),
        ),
      ],
    );
  }
}
