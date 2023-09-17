import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterstudy_app/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/models/lesson/lesson_response.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/presentation/bloc/lesson_materials/lesson_materials_bloc.dart';
import 'package:masterstudy_app/presentation/widgets/flutter_toast.dart';
import 'package:masterstudy_app/presentation/widgets/loader_widget.dart';
import 'package:masterstudy_app/theme/app_color.dart';

class LessonMaterialsWidget extends StatefulWidget {
  const LessonMaterialsWidget({
    super.key,
    required this.lessonResponse,
    this.darkMode = false,
  });

  final LessonResponse lessonResponse;
  final bool? darkMode;

  @override
  State<LessonMaterialsWidget> createState() => _LessonMaterialsWidgetState();
}

class _LessonMaterialsWidgetState extends State<LessonMaterialsWidget> {
  late LessonResponse lessonResponse;

  @override
  void initState() {
    lessonResponse = widget.lessonResponse;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LessonMaterialsBloc(),
      child: BlocListener<LessonMaterialsBloc, LessonMaterialsState>(
        listener: (context, state) {
          if (state is ErrorMaterialState) {
            showFlutterToast(title: state.message ?? 'Unknown Error');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              lessonResponse.materials?.isNotEmpty ?? false
                  ? Text(
                      localizations.getLocalization('materials'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: widget.darkMode ?? false ? ColorApp.white : Colors.black,
                      ),
                    )
                  : const SizedBox(),

              const SizedBox(height: 10.0),

              ListView.builder(
                shrinkWrap: true,
                itemCount: lessonResponse.materials?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext ctx, int index) {
                  final item = lessonResponse.materials![index];
                  return BlocBuilder<LessonMaterialsBloc, LessonMaterialsState>(
                    builder: (context, state) {
                      return MaterialItemWidget(
                        state: state,
                        onDownload: state is LoadingMaterialsState
                            ? null
                            : () async {
                                BlocProvider.of<LessonMaterialsBloc>(context).add(
                                  LoadMaterialsEvent(
                                    url: item!.url,
                                    fileName: item.label,
                                  ),
                                );
                              },
                        title: item!.label,
                        materialsType: item.type,
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MaterialItemWidget extends StatelessWidget {
  const MaterialItemWidget({
    super.key,
    required this.onDownload,
    required this.title,
    required this.materialsType,
    required this.state,
  });

  final VoidCallback? onDownload;
  final String title;
  final MaterialsType materialsType;
  final LessonMaterialsState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: ColorApp.mainColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset(
              materialsFormatterIcon[materialsType],
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: ColorApp.white,
                fontSize: 12.0,
              ),
            ),
          ),
          InkWell(
            onTap: onDownload,
            child: state is LoadingMaterialsState
                ? LoaderWidget()
                : Icon(
                    Icons.download_outlined,
                    color: ColorApp.white,
                  ),
          ),
        ],
      ),
    );
  }
}

Map<MaterialsType, dynamic> materialsFormatterIcon = {
  MaterialsType.audio: IconPath.audio,
  MaterialsType.avi: IconPath.avi,
  MaterialsType.doc: IconPath.doc,
  MaterialsType.docx: IconPath.docx,
  MaterialsType.gif: IconPath.gif,
  MaterialsType.jpeg: IconPath.jpeg,
  MaterialsType.jpg: IconPath.jpg,
  MaterialsType.mov: IconPath.mov,
  MaterialsType.mp3: IconPath.mp3,
  MaterialsType.mp4: IconPath.mp4,
  MaterialsType.pdf: IconPath.pdf,
  MaterialsType.png: IconPath.png,
  MaterialsType.ppt: IconPath.ppt,
  MaterialsType.pptx: IconPath.pptx,
  MaterialsType.psd: IconPath.psd,
  MaterialsType.txt: IconPath.txt,
  MaterialsType.xls: IconPath.xls,
  MaterialsType.xlsx: IconPath.xlsx,
  MaterialsType.zip: IconPath.zip,
};
