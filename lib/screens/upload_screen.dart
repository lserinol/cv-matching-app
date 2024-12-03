import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('cvs/$fileName');
      UploadTask uploadTask = ref.putFile(File(filePath));

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      await uploadTask.whenComplete(() async {
        String downloadURL = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('cvs').add({
          'fileName': fileName,
          'downloadURL': downloadURL,
          'uploadedAt': Timestamp.now(),
        });

        setState(() {
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CV uploaded successfully!')),
        );
      });
    }
  }

  void _startMatchingProcess() {
    // Implement the matching process initiation logic here
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
