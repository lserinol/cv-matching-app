import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadCV(FilePickerResult result) async {
    if (result != null) {
      PlatformFile file = result.files.first;
      String fileName = file.name;
      String filePath = file.path!;

      Reference ref = _storage.ref().child('cvs/$fileName');
      UploadTask uploadTask = ref.putFile(File(filePath));

      await uploadTask.whenComplete(() async {
        String downloadURL = await ref.getDownloadURL();
        await _firestore.collection('cvs').add({
          'fileName': fileName,
          'downloadURL': downloadURL,
          'uploadedAt': Timestamp.now(),
        });
      });
    }
  }

  Future<void> storeMetadata(String fileName, String downloadURL) async {
    await _firestore.collection('cvs').add({
      'fileName': fileName,
      'downloadURL': downloadURL,
      'uploadedAt': Timestamp.now(),
    });
  }

  Future<List<Map<String, dynamic>>> retrieveMatchingResults() async {
    QuerySnapshot querySnapshot = await _firestore.collection('matching_results').get();
    List<Map<String, dynamic>> results = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    return results;
  }
}
