import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiManager {
  final String url;

  ApiManager({required this.url}) {
    isUrlActive(url);
  }

  String baseUrl = "https://us2002.pythonanywhere.com";

  void isUrlActive(String a) async {
    try {
      final response = await http.get(Uri.parse(a));
      if (response.statusCode == 200) {
        baseUrl = a;
      } else {
        baseUrl = "https://us2002.pythonanywhere.com";
      }
    } catch (e) {
      baseUrl = "https://us2002.pythonanywhere.com";
    }
  }

  Future<void> sendAudio(File audioFile) async {
    // print("Sending Audio");
    final url = Uri.parse('$baseUrl/process_audio');
    final request = http.MultipartRequest('POST', url);
    request.headers['ngrok-skip-browser-warning'] = '69420';
    request.files
        .add(await http.MultipartFile.fromPath('file', audioFile.path));

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to send audio');
    } else {}
  }

  Future<String> getReplyText() async {
    // print("Getting Text Response");
    final response = await http.get(Uri.parse('$baseUrl/get_reply'));
    response.headers['ngrok-skip-browser-warning'] = '69420';

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // print(jsonResponse['text']);
      return jsonResponse['text'] as String;
    } else {
      throw Exception('Failed to get reply text');
    }
  }
}
