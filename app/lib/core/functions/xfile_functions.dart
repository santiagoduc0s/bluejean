import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

Future<XFile?> xFileFromUrl(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return null;

    final tempDir = await getTemporaryDirectory();
    final randomName = DateTime.now().millisecondsSinceEpoch.toString();
    final file = File('${tempDir.path}/$randomName');
    await file.writeAsBytes(response.bodyBytes);
    return XFile(file.path);
  } catch (e, s) {
    AppLoggerHelper.error(e.toString(), stackTrace: s);
    return null;
  }
}
