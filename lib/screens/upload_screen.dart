import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _uploadCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null) {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      PlatformFile file = result.files.first;
      String fileName = file.name;
      String filePath = file.path!;

      var request = http.MultipartRequest('POST', Uri.parse('http://localhost:3000/api/cvs'));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        setState(() {
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CV uploaded successfully!')),
        );
      } else {
        setState(() {
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload CV')),
        );
      }
    }
  }

  void _startMatchingProcess() async {
    final response = await http.post(Uri.parse('http://localhost:3000/api/matching_results'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Matching process started successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start matching process')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload CV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadCV,
              child: Text('Upload CV'),
            ),
            if (_isUploading)
              Column(
                children: [
                  SizedBox(height: 16.0),
                  LinearProgressIndicator(value: _uploadProgress),
                  SizedBox(height: 8.0),
                  Text('${(_uploadProgress * 100).toStringAsFixed(2)}%'),
                ],
              ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _startMatchingProcess,
              child: Text('Start Matching Process'),
            ),
          ],
        ),
      ),
    );
  }
}
