class CV {
  final String id;
  final String fileName;
  final String downloadURL;
  final DateTime uploadedAt;
  final Map<String, dynamic> extractedInfo;

  CV({
    required this.id,
    required this.fileName,
    required this.downloadURL,
    required this.uploadedAt,
    required this.extractedInfo,
  });

  factory CV.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CV(
      id: doc.id,
      fileName: data['fileName'],
      downloadURL: data['downloadURL'],
      uploadedAt: (data['uploadedAt'] as Timestamp).toDate(),
      extractedInfo: data['extractedInfo'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fileName': fileName,
      'downloadURL': downloadURL,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'extractedInfo': extractedInfo,
    };
  }
}
