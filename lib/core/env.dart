import 'package:html_unescape/html_unescape.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

ImagePicker picker = ImagePicker();

final unescape = HtmlUnescape();

late SharedPreferences preferences;
