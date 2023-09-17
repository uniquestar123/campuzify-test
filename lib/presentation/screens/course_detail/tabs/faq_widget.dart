import 'package:flutter/material.dart';
import 'package:masterstudy_app/data/models/course/course_detail_response.dart';

class FaqWidget extends StatelessWidget {
  const FaqWidget(this.response) : super();

  final CourseDetailResponse response;

  @override
  Widget build(BuildContext context) {
    if (response.faq == null || response.faq!.isEmpty) {
      return const SizedBox();
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 20.0),
      itemCount: response.faq!.length,
      itemBuilder: (context, index) {
        var item = response.faq![index];
        return ExpansionTile(
          title: Text(
            item?.question ?? '',
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Color(0xFF273044),
              fontSize: 18,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Text(
                item?.answer ?? '',
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
