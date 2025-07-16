# SpyGlass

Self-Destructing Encrypted Notes Platform
=========================================

SpyGlass is a secure, open-source platform for creating, sharing, and managing self-destructing encrypted notes. It consists of a Django REST API backend and a modern Flutter frontend, providing a seamless, privacy-first experience for sharing sensitive information.

---

## Table of Contents
- [Features](#features)
- [Architecture](#architecture)
  - [Backend (Django)](#backend-django)
  - [Frontend (Flutter)](#frontend-flutter)
- [Security & Encryption](#security--encryption)
- [AI-Powered Features](#ai-powered-features)
- [Setup Instructions](#setup-instructions)
  - [Backend Setup](#backend-setup)
  - [Frontend Setup](#frontend-setup)
- [API Documentation](#api-documentation)
- [Contributing](#contributing)
- [License](#license)
- [Credits](#credits)

---

## Features
- **End-to-end encrypted notes**: Notes are encrypted client-side and can only be decrypted with the correct key.
- **Self-destructing**: Notes expire after a set time or number of views.
- **AI-powered security**: Gemini AI suggests optimal security settings and improves encryption key hints.
- **Access logging**: Track access attempts, including IP and user agent.
- **Modern, cross-platform UI**: Flutter app for web, mobile, and desktop.
- **Screenshot protection**: Prevents screenshots and screen recording on supported devices.
- **QR code sharing**: Easily share note links securely.

---

## Architecture

### Backend (Django)
- **Framework**: Django 4.2 + Django REST Framework
- **App**: `notes` (core logic for notes, encryption, AI, and access logs)
- **Database**: SQLite (default, can be swapped for Postgres/MySQL)
- **Key Components**:
  - `Note` model: Stores encrypted content, expiry, view limits, and metadata.
  - `NoteAccess` model: Logs each access attempt.
  - `ai_service.py`: Integrates with Gemini AI for content analysis and hint improvement.
  - `middleware.py`: Tracks real client IP for logging.
  - API endpoints: CRUD for notes, AI analysis, access logs, and status.
  - Auto-generated API docs (Swagger/Redoc).

### Frontend (Flutter)
- **Framework**: Flutter 3.8+
- **State Management**: Provider, Injectable, GetIt
- **Key Components**:
  - `core/`: Encryption, API client, security, logging utilities.
  - `domains/notes/`: Data models, providers, repositories for notes.
  - `presentaion/pages/`: UI for creating, viewing, and managing notes.
  - `routing/`: AutoRoute-based navigation.
  - **Security**: Screenshot protection, immersive mode, secure content display.
  - **AI Integration**: UI for AI-powered suggestions and hint improvements.

---

## Security & Encryption
- **Client-side encryption**: Notes are encrypted in the Flutter app using AES-256 (CBC mode, PKCS7 padding). The encryption key is derived from the user password using SHA-256 with salt and 1000 iterations.
- **No plaintext storage**: The backend never sees or stores unencrypted note content or user keys.
- **Self-destruction**: Notes are deleted after expiry or max views, enforced server-side.
- **Access control**: Each note access is logged with IP and user agent. Suspicious patterns can be analyzed by AI.
- **Screenshot protection**: The app prevents screenshots and screen recording on Android/iOS.

---

## AI-Powered Features
- **Content Security Analysis**: Gemini AI analyzes note content and suggests optimal expiry and view settings based on sensitivity.
- **Key Hint Improvement**: AI generates more secure, memorable hints for encryption keys.
- **Access Log Analysis**: AI can detect suspicious access patterns (brute force, repeated failures, etc.).

---

## Setup Instructions

### Backend Setup
1. **Clone the repo**:
   ```bash
   git clone <repo-url>
   cd SPYGLASS/spyglass
   ```
2. **Create a virtual environment**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```
3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```
4. **Set environment variables**:
   - Create a `.env` file with your Gemini API key:
     ```
     GEMINI_API_KEY=your-gemini-api-key
     ```
5. **Run migrations**:
   ```bash
   python manage.py migrate
   ```
6. **Run the server**:
   ```bash
   python manage.py runserver
   ```
   The API will be available at `http://localhost:8000/`.

### Frontend Setup
1. **Navigate to the frontend directory**:
   ```bash
   cd ../spyglass-frontend/spyglass
   ```
2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   - For web:
     ```bash
     flutter run -d chrome
     ```
   - For mobile:
     ```bash
     flutter run
     ```
   - For desktop:
     ```bash
     flutter run -d macos # or windows/linux
     ```

---

## API Documentation
- **Swagger UI**: [http://localhost:8000/swagger/](http://localhost:8000/swagger/)
- **Redoc**: [http://localhost:8000/redoc/](http://localhost:8000/redoc/)
- **Key Endpoints**:
  - `POST /api/notes/` — Create a new note
  - `GET /api/notes/{id}/` — Retrieve and decrypt a note
  - `GET /api/notes/{id}/status/` — Get note status (without incrementing views)
  - `GET /api/notes/{id}/access_logs/` — Get access logs for a note
  - `POST /api/notes/ai_analyze_content/` — AI content security analysis
  - `POST /api/notes/ai_improve_hint/` — AI key hint improvement

---

## Contributing
1. Fork the repo and create a feature branch.
2. Follow best practices for code style (PEP8 for Python, Dart/Flutter lints).
3. Write clear commit messages and document your code.
4. Submit a pull request with a detailed description.


---

## Credits
- **Core Developer**: Kshitij Moghe
- **AI Integration**: Google Gemini
- **Frameworks**: Django, Django REST Framework, Flutter
- **UI/UX**: Material Design, AutoRoute

---

For questions or support, open an issue or contact the maintainer. 
