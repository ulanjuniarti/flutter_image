import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.10.24.130/flutter_image/";

  static Future<String> uploadImage(File imageFile, String description) async {
    try {
      final uri = Uri.parse(baseUrl + 'upload_image.php');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path))
        ..fields['description'] = description;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      //print('Response Status Code: ${response.statusCode}');
      //print('Response Body: $responseBody');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(await response.stream.bytesToString());
        return jsonResponse['message'];
      } else {
        return 'Failed to upload image. Status Code: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error uploading image: $e';
    }
  }
}
