import 'dart:convert';
import 'package:http/http.dart' as http;
import '../database/database_helper.dart';

class ApiService {
  static const String apiUrl =
      "https://api.ezuite.com/api/External_Api/Mobile_Api/Invoke";

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final Map<String, dynamic> requestBody = {
      "API_Body": [
        {"Unique_Id": "", "Pw": password}
      ],
      "Api_Action": "GetUserData",
      "Company_Code": username,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['Status_Code'] == 200) {
          await DatabaseHelper.saveUserData(responseData['Response_Body']);
          return {'success': true, 'userData': responseData['Response_Body']};
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    return {'success': false};
  }
}
