import 'dart:convert';
import 'dart:io';

void main() async {
  final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDLizsyZEzr3q6jwejXDRc62eg88_qH78E');
  final request = await HttpClient().postUrl(url);
  request.headers.set('Content-Type', 'application/json');
  request.add(utf8.encode(json.encode({
    'email': 'antigravitytest2@fashion.com',
    'password': 'password123',
    'returnSecureToken': true
  })));
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  print('Status Code: ${response.statusCode}');
  print('Response Body: $responseBody');
}
