import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CVListItem extends StatelessWidget {
  final Map<String, dynamic> cvData;

  CVListItem({required this.cvData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cvData['name']),
      subtitle: Text(cvData['email']),
      trailing: IconButton(
        icon: Icon(Icons.download),
        onPressed: () async {
          String downloadURL = cvData['downloadURL'];
          // Implement the logic to download the CV using the downloadURL
        },
      ),
    );
  }
}
