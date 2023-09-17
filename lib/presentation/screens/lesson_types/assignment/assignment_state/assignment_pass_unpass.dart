import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/assignment/assignment_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/assignment/assignment_bloc.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/assignment_parts/assignment_info.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class AssignmentPassUnpassWidget extends StatelessWidget {
  const AssignmentPassUnpassWidget(
    this.assignmentResponse,
    this.courseId,
    this.assignmentId,
    this.authorAvatar,
    this.authorName,
  ) : super();

  final AssignmentResponse assignmentResponse;
  final int courseId;
  final int assignmentId;
  final String authorAvatar;
  final String authorName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0, right: 7.0, bottom: 10.0, left: 7.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFEEF1F7),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: assignmentResponse.status == 'passed' ? ColorApp.secondaryColor : Color(0xFFF44336),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            assignmentResponse.status == 'passed' ? Icons.check : Icons.close,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(right: 10.0),
                  ),
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
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5.0, left: 7.0, right: 7.0),
          child: Html(
            data: assignmentResponse.comment!.isNotEmpty ? assignmentResponse.comment : '',
            style: {
              'body': Style(
                fontSize: FontSize(13.0),
              )
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 7.0, right: 7.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                child: CachedNetworkImage(
                  width: 45.0,
                  imageUrl: authorAvatar,
                  placeholder: (context, url) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LoaderWidget(
                      loaderColor: ColorApp.mainColor,
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return SizedBox(
                      width: 100.0,
                      child: Image.asset(ImagePath.logo),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizations.getLocalization('teacher'),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Text(
                    authorName,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: ColorApp.mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Divider(
          height: 20.0,
          thickness: 2,
          color: Color(0xFFE2E5EB),
        ),
        assignmentResponse.status == 'unpassed'
            ? BlocBuilder<AssignmentBloc, AssignmentState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
                    child: MaterialButton(
                      height: 50,
                      color: ColorApp.mainColor,
                      onPressed: state is LoadingStartAssignmentState
                          ? null
                          : () {
                              BlocProvider.of<AssignmentBloc>(context).add(
                                StartAssignmentEvent(courseId, assignmentId),
                              );
                            },
                      child: state is LoadingStartAssignmentState
                          ? LoaderWidget()
                          : Text(
                              localizations.getLocalization('retake_assignment'),
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  );
                },
              )
            : const SizedBox(),
        AssignmentInfoWidget(assignmentResponse)
      ],
    );
  }
}
