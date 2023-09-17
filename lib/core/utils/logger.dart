import 'package:logger/logger.dart';

/// Standard logger that follows the whole project
final logger = Logger(
  printer: PrettyPrinter(
    printTime: true,
  ),
);
