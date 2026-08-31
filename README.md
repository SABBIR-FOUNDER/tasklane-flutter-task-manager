# 🛣️ TaskLane by Sabbir Ahammed

### Plan. Track. Complete.

**TaskLane** is a Flutter-based task management application designed around a clear, status-driven workflow. It provides REST API authentication, persistent user sessions, task lifecycle management, profile management, and a polished mobile interface.

<p align="center">
  <strong>New → In Progress → Completed / Cancelled</strong>
</p>

---

## ✨ Features

### 🔐 Authentication
- User registration
- REST API login
- Token-based authentication
- Persistent sessions using `shared_preferences`
- Automatic session restoration
- Splash-screen authentication routing
- Secure logout and session clearing
- Form validation
- Password visibility controls
- Password recovery flow when supported by the API
- OTP/PIN verification when supported by the API
- Password reset when supported by the API

### ✅ Task Management
- Create tasks
- Retrieve tasks from the REST API
- View tasks by workflow status
- New tasks
- In-progress tasks
- Completed tasks
- Cancelled tasks
- View task details
- Edit tasks when supported by the API
- Update task status
- Delete tasks with confirmation
- Pull-to-refresh
- Dynamic task status counts

### 👤 Profile Management
- Display authenticated user information
- View profile details
- Update profile information when supported by the API
- Synchronize updated user data with local storage
- Change password when supported by the API

### 🎨 User Experience
- Modern responsive Flutter interface
- Custom SVG backgrounds and illustrations
- Reusable UI components
- Loading states
- Empty states
- Error states
- Offline-state presentation
- Confirmation dialogs
- User feedback messages
- Status-aware task presentation

---

## 🧰 Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** | Cross-platform application framework |
| **Dart** | Application language |
| **REST API** | Backend communication |
| **HTTP** | API request handling |
| **SharedPreferences** | Persistent local session storage |
| **Flutter SVG** | Scalable SVG assets |
| **JSON** | API request and response serialization |

TaskLane uses a REST API for authentication and application data. Firebase is not required.

---

## 🏗️ Project Structure

```text
lib/
│
├── main.dart
├── app.dart
│
├── core/
│   ├── app_urls.dart
│   ├── app_assets.dart
│   ├── app_colors.dart
│   └── app_theme.dart
│
├── models/
│   ├── api_response.dart
│   ├── user_model.dart
│   ├── task_model.dart
│   └── task_status_count_model.dart
│
├── services/
│   ├── api_client.dart
│   └── auth_service.dart
│
├── controllers/
│   └── auth_controller.dart
│
├── screens/
│   ├── auth/
│   ├── tasks/
│   └── profile/
│
└── widgets/
    ├── screen_background.dart
    ├── primary_button.dart
    ├── custom_text_field.dart
    ├── task_card.dart
    ├── task_count_card.dart
    ├── profile_header.dart
    └── empty_state.dart
```

The codebase separates application configuration, models, API communication, authentication state, screens, and reusable interface components.

---

## 🔄 Authentication Flow

```text
Application Launch
        ↓
   Splash Screen
        ↓
Read Stored Session
        ↓
 Authentication Token?
      ↙         ↘
    Yes          No
     ↓            ↓
Dashboard       Login
```

After successful authentication:

```text
Login Form
    ↓
Input Validation
    ↓
POST Login Request
    ↓
REST API
    ↓
JSON Response
    ↓
User Data + Token
    ↓
SharedPreferences
    ↓
Authenticated Application
```

---

## 📡 API Architecture

TaskLane centralizes HTTP communication through an API client instead of embedding networking logic throughout individual screens.

```text
Flutter Screen
      ↓
User Action
      ↓
Application Logic
      ↓
API Client
      ↓
HTTP Request
      ↓
REST API Server
      ↓
JSON Response
      ↓
Dart Model
      ↓
Application State
      ↓
Updated Interface
```

The networking layer supports API operations such as:

- `GET`
- `POST`
- `PUT`
- `DELETE`
- JSON encoding
- JSON decoding
- HTTP headers
- Authorization tokens
- HTTP status handling
- Network exception handling

Actual HTTP methods and endpoints depend on the configured backend API.

---

## 💾 Session Persistence

TaskLane uses `shared_preferences` to retain lightweight authentication state between application launches.

The application may persist:

- Authentication token
- Required authenticated user information

On startup, TaskLane checks the stored session and routes the user to the appropriate screen.

> Passwords are never stored in SharedPreferences.

---

## 📋 Task Workflow

Tasks are organized by status:

```text
             ┌─────────────┐
             │     New     │
             └──────┬──────┘
                    ↓
             ┌─────────────┐
             │ In Progress │
             └──────┬──────┘
                    ↓
             ┌─────────────┐
             │  Completed  │
             └─────────────┘

Tasks may also transition to:

             ┌─────────────┐
             │  Cancelled  │
             └─────────────┘
```

The exact allowed transitions are determined by the backend API.

---

## 📱 Application Screens

### Authentication
- Splash Screen
- Login
- Registration
- Forgot Password
- OTP/PIN Verification
- Reset Password

### Task Management
- Dashboard
- New Tasks
- In Progress
- Completed
- Cancelled
- Add Task
- Task Details
- Edit Task

### Account
- Profile
- Edit Profile
- Change Password

Availability of specific account and recovery features depends on the connected API.

---

## 🎨 Assets

TaskLane uses custom SVG assets for scalable interface graphics.

```text
assets/
└── images/
    ├── backgrounds/
    │   ├── auth_background.svg
    │   ├── dashboard_header.svg
    │   ├── soft_wave_top.svg
    │   └── profile_accent.svg
    │
    ├── illustrations/
    │   ├── forgot_password_envelope.svg
    │   ├── otp_shield.svg
    │   ├── reset_password_lock.svg
    │   ├── empty_tasks.svg
    │   └── no_internet.svg
    │
    └── icons/
        ├── task_logo.svg
        └── success_check.svg
```

---

## 📦 Dependencies

Core dependencies include:

```yaml
dependencies:
  flutter:
    sdk: flutter

  http:
  shared_preferences:
  flutter_svg:
```

See `pubspec.yaml` for the exact dependency versions used by the application.

---

## ⚙️ Installation

### Prerequisites

Install Flutter and verify the environment:

```bash
flutter doctor
```

### 1. Clone the repository

```bash
git clone https://github.com/SABBIR-FOUNDER/tasklane-flutter-task-manager.git
```

### 2. Enter the project directory

```bash
cd tasklane-flutter-task-manager
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Configure the API

Configure the REST API base URL in the application configuration.

Example:

```dart
class AppUrls {
  static const String baseUrl = 'YOUR_API_BASE_URL';
}
```

Do not commit private API keys, credentials, access secrets, or production-only configuration.

### 5. Run the application

```bash
flutter run
```

---

## 🖼️ Screenshots

Check the lib folder too see screenshots. 

## 🧩 Application States

API-driven screens account for multiple states:

| State | Description |
|---|---|
| **Loading** | Waiting for an API response |
| **Success** | Requested data is available |
| **Empty** | Request succeeded but no records are available |
| **Error** | Request or server operation failed |
| **Unauthorized** | Authentication is missing or invalid |
| **Offline** | Network connectivity is unavailable |

---

## 🔒 Security

TaskLane follows several basic application-security practices:

- Passwords are not persisted locally.
- Authentication tokens are attached only to protected requests.
- Stored session data is cleared during logout.
- Private credentials and API secrets should not be committed to source control.
- Client-side validation is treated as a usability measure, not a replacement for server-side validation.
- Authentication failures and expired sessions should be handled explicitly.

For applications with higher security requirements, platform-backed secure storage should be considered for sensitive authentication material.

---

## 🚀 Roadmap

Planned or potential enhancements include:

- [ ] Dark mode
- [ ] Task search
- [ ] Advanced filtering
- [ ] Task priorities
- [ ] Due dates
- [ ] Reminders
- [ ] Pagination
- [ ] Offline caching
- [ ] Secure token storage
- [ ] Unit testing
- [ ] Widget testing
- [ ] Integration testing
- [ ] Notifications
- [ ] Accessibility improvements

---

## 🤝 Contributing

Contributions, bug reports, and improvement proposals are welcome.

To contribute:

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Test the changes.
5. Open a pull request with a clear description.

For significant changes, consider opening an issue first to discuss the proposed implementation.

---

## 🐛 Issues

If you encounter a bug or unexpected behavior, open a GitHub issue with:

- A clear description
- Steps to reproduce
- Expected behavior
- Actual behavior
- Flutter/Dart version
- Platform/device information
- Relevant logs or screenshots

Please do not include passwords, API secrets, authentication tokens, or other sensitive information.

---

## 👨‍💻 Author

**SABBIR_AHAMMED**

- GitHub: `https://github.com/SABBIR-FOUNDER`
- LinkedIn: `https://www.linkedin.com/in/sabbir911/`

---

## 📄 License

TaskLane is available under the **MIT License**.

See the LICENSE file for the full license text.

---

## ⭐ TaskLane

**Plan. Track. Complete.**

If you find TaskLane useful, consider starring the repository.

### Suggested GitHub Topics

`flutter` · `dart` · `task-manager` · `task-management` · `flutter-app` · `rest-api` · `api-integration` · `authentication` · `shared-preferences` · `crud` · `mobile-app` · `http` · `json`
