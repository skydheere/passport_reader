import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl =
      'https://api.openai.com/v1/engines/gpt-4/completions';

  static Future<Map<String, dynamic>> processPassportImage(
      File imageFile, String apiKey) async {
    try {
      final base64Image = base64Encode(await imageFile.readAsBytes());

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      };

      final body = jsonEncode({
        "model": "gpt-4o",
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text":
                    "Extract provided passport image information and output as json format. eg. {name:'',mother_name:'',nationality:'',dob:'',gender:'',passport_no:''.}"
              },
              {
                "type": "image_url",
                "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
              }
            ]
          }
        ],
        "max_tokens": 300
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return {
          'success': true,
          'data': decodedResponse['choices'][0]['message']['content'] ?? {},
        };
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {
          'success': false,
          'error': 'Failed to process image',
        };
      }
    } catch (e) {
      print('Exception occurred: $e');
      return {
        'success': false,
        'error': 'An error occurred: $e',
      };
    }
  }
}
