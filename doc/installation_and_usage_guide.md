# Installation and usage guide

This guide will help you set up and run the CV Matching Application, which includes both the backend API and the frontend Flutter application. Follow the steps below to create the environment and run the application smoothly.

## Prerequisites

* Install Python 3.8 or higher
* Install SQLite
* Install Dart SDK
* Install Flutter SDK

## Backend setup

1. Clone the repository:

```bash
git clone https://github.com/lserinol/cv-matching-app.git
cd cv-matching-app
```

2. Create a virtual environment and activate it:

```bash
python -m venv venv
source venv/bin/activate  # On Windows use `venv\Scripts\activate`
```

3. Install the required Python packages:

```bash
pip install fastapi uvicorn
```

4. Initialize the SQLite database:

```bash
python -c "from api.database import initialize_db; initialize_db()"
```

5. Run the FastAPI server:

```bash
uvicorn api.main:app --reload
```

## Frontend setup

1. Navigate to the `flutter` directory:

```bash
cd flutter
```

2. Install Flutter dependencies:

```bash
flutter pub get
```

3. Run the Flutter application:

```bash
flutter run -d chrome
```

## Usage

1. Open the application in your web browser at `http://localhost:8000`.
2. Upload CVs using the upload button on the main screen.
3. Start the matching process by clicking the "Start Matching Process" button.
4. View the matching results on the results screen.

## Additional information

* The backend API is implemented using FastAPI and SQLite. The database schema is defined in `api/database.py`.
* The frontend is built using Flutter. The main entry point is `lib/main.dart`.
* The application uses HTTP requests to communicate between the frontend and backend. The upload functionality is implemented in `lib/screens/upload_screen.dart`.

For more details, refer to the code and comments in the respective files.
