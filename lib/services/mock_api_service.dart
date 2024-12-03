import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MockApiService {
  final String baseUrl;

  MockApiService({required this.baseUrl});

  Future<void> uploadCV(File file) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/cvs'));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      // Handle the response data if needed
    } else {
      throw Exception('Failed to upload CV');
    }
  }

  Future<void> storeMetadata(String fileName, String downloadURL) async {
    var response = await http.post(
      Uri.parse('$baseUrl/api/cvs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'fileName': fileName,
        'downloadURL': downloadURL,
        'uploadedAt': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to store metadata');
    }
  }

  Future<List<Map<String, dynamic>>> retrieveMatchingResults() async {
    final response = await http.get(Uri.parse('$baseUrl/api/matching_results'));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(json.decode(response.body));
      return results;
    } else {
      throw Exception('Failed to load matching results');
    }
  }

  Future<void> addMatchingResults(Map<String, dynamic> matchingResults) async {
    var response = await http.post(
      Uri.parse('$baseUrl/api/matching_results'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(matchingResults),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add matching results');
    }
  }
}
