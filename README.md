# CV Matching Application

This project is a web-based application that allows users to upload their CVs and matches them with similar CVs using advanced machine learning techniques. The application is built using Flutter and Firebase.

## Features

- Upload CVs in PDF or text format
- Display uploaded CVs
- Initiate the matching process
- Display matching results in a user-friendly format
- Search and filter matching results
- Download matching results
- Responsive design for compatibility with different devices and screen sizes

## Setup

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase project: [Create a Firebase project](https://firebase.google.com/)

### Setting up the Flutter project

1. Clone the repository:

```bash
git clone https://github.com/githubnext/workspace-blank.git
cd workspace-blank
```

2. Install dependencies:

```bash
flutter pub get
```

### Setting up Firebase

1. Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).

2. Add a web app to your Firebase project and copy the Firebase configuration.

3. In the Flutter project, create a `web/index.html` file and add the Firebase configuration:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>CV Matching Application</title>
    <script src="https://www.gstatic.com/firebasejs/8.6.8/firebase-app.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.6.8/firebase-firestore.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.6.8/firebase-storage.js"></script>
    <script>
      // Your Firebase configuration
      var firebaseConfig = {
        apiKey: "YOUR_API_KEY",
        authDomain: "YOUR_AUTH_DOMAIN",
        projectId: "YOUR_PROJECT_ID",
        storageBucket: "YOUR_STORAGE_BUCKET",
        messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
        appId: "YOUR_APP_ID"
      };
      // Initialize Firebase
      firebase.initializeApp(firebaseConfig);
    </script>
  </head>
  <body>
    <script src="main.dart.js"></script>
  </body>
</html>
```

4. Initialize Firebase in your Flutter project by adding the following code to `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Matching Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UploadScreen(),
    );
  }
}
```

### Setting up SQLite Database

1. Install SQLite:

```bash
sudo apt-get install sqlite3
```

2. Create the SQLite database file:

```bash
sqlite3 cv.db
```

3. Create the `cv` table in the database:

```sql
CREATE TABLE cv (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fileName TEXT NOT NULL,
    downloadURL TEXT NOT NULL,
    uploadedAt TEXT NOT NULL,
    extractedInfo TEXT
);
```

### Running the application

1. Run the Flutter web application:

```bash
flutter run -d chrome
```

2. Open the application in your web browser:

```
http://localhost:8000
```

You should now be able to upload CVs, initiate the matching process, and view the matching results.
