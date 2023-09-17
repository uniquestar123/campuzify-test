import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/data/models/assignment/assignment_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/assignment/assignment_bloc.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/widgets/choose_item_widget.dart';
import 'package:masterstudy_app/presentation/screens/lesson_types/assignment/widgets/file_item_widget.dart';
import 'package:masterstudy_app/presentation/widgets/custom_bottom_sheet.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/const_dimensions.dart';

class AssignmentDraftWidget extends StatefulWidget {
  const AssignmentDraftWidget(
    Key key,
    this.assignmentResponse,
    this.courseId,
    this.assignmentId,
    this.userAssignmentId,
  ) : super(key: key);

  final AssignmentResponse assignmentResponse;

  final int courseId;
  final int assignmentId;
  final int? userAssignmentId;

  @override
  State<StatefulWidget> createState() => AssignmentDraftWidgetState();
}

class AssignmentDraftWidgetState extends State<AssignmentDraftWidget> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();
  List<File> pickedFileList = [];
  FocusNode myFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
          child: Text(
            '${localizations.getLocalization('assignment_screen_title')} ' +
                widget.assignmentResponse.section!.index.toString(),
            textScaleFactor: 1.0,
            style: TextStyle(color: Color(0xFF273044)),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Assignment index
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    widget.assignmentResponse.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                // Title
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: TextFormField(
                    controller: _titleController,
                    maxLines: 1,
                    cursorColor: ColorApp.mainColor,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorApp.mainColor),
                      ),
                      labelStyle: TextStyle(color: myFocusNode.hasFocus ? ColorApp.mainColor : Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                      ),
                      labelText: widget.assignmentResponse.translations?.title,
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                //Content
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _textController,
                    maxLines: 8,
                    cursorColor: ColorApp.mainColor,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorApp.mainColor),
                      ),
                      labelStyle: TextStyle(color: myFocusNode.hasFocus ? ColorApp.mainColor : Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFFFFF)),
                      ),
                      labelText: widget.assignmentResponse.translations?.content,
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                // Button "Attach Files"
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    height: kButtonHeight,
                    width: 160.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorApp.secondaryColor,
                        shape: StadiumBorder(),
                      ),
                      onPressed: () {
                        showBaseModalBottomSheet(
                          context: context,
                          content: Column(
                            children: [
                              ChooseItemWidget(
                                iconData: Icons.camera_alt_outlined,
                                valueText: localizations.getLocalization('camera'),
                                iconColor: Colors.green,
                                onTap: () => _openCamera(),
                              ),
                              ChooseItemWidget(
                                iconData: Icons.photo,
                                valueText: localizations.getLocalization('photos'),
                                iconColor: Colors.orange,
                                onTap: () => _imagePicker(),
                              ),
                              ChooseItemWidget(
                                iconData: Icons.folder_copy_outlined,
                                valueText: localizations.getLocalization('files'),
                                iconColor: Colors.purple,
                                onTap: () => _uploadFile(),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: SvgPicture.asset(
                              IconPath.file,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            widget.assignmentResponse.translations?.files ??
                                localizations.getLocalization('attach_files'),
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: pickedFileList.length,
                  itemBuilder: (context, index) {
                    final item = pickedFileList[index];

                    String fileName = item.path.split('/').last;

                    return FileItemWidget(
                      valueText: fileName,
                      onDelete: () {
                        setState(() {
                          pickedFileList.removeAt(index);
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _uploadFile() async {
    FilePickerResult? filePickResult = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (filePickResult != null) {
      setState(() {
        pickedFileList = filePickResult.paths.map((path) => File(path!)).toList();
      });
    }
  }

  void _imagePicker() async {
    final List<XFile>? image = await picker.pickMultiImage();

    if (image != null && image.isNotEmpty) {
      setState(() {
        pickedFileList = image.map((path) => File(path.path)).toList();
      });
    }
  }

  void _openCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        pickedFileList.add(File(photo.path));
      });
    }
  }

  void addAssignment() {
    String content = _titleController.text + ' ' + _textController.text;

    BlocProvider.of<AssignmentBloc>(context).add(
      AddAssignmentEvent(
        widget.courseId,
        widget.assignmentId,
        widget.userAssignmentId!,
        content,
        pickedFileList,
      ),
    );
  }
}
