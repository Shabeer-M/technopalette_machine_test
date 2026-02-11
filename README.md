# TechnoPalette Machine Test - Flutter App

A robust Flutter application built to demonstrate Clean Architecture, BLoC state management, and modern UI practices.

## Features

- **Authentication**: Login, Registration, Forgot Password, and Logout using Firebase Auth.
- **Profile Management**: View, Edit, and detail view of user profiles with Hive caching for offline support.
- **Search**: Advanced search functionality with filtering (Gender, Height, Weight, Location) and caching.
- **Responsive UI**: Custom design with consistent theming, animations (Hero, Fade), and responsive layouts.

## Architecture

This project follows **Clean Architecture** principles, separating the codebase into three main layers:

1.  **Domain Layer** (Inner-most):
    -   **Entities**: Pure Dart objects representing business data.
    -   **Use Cases**: Encapsulate business logic and interact with repositories.
    -   **Repository Interfaces**: Abstract definitions of data operations.
    -   *Pure Dart, no Flutter dependencies.*

2.  **Presentation Layer** (Outer):
    -   **BLoCs**: Manage state using `flutter_bloc`. They receive events from UI => execute Use Cases => emit States.
    -   **Pages/Widgets**: UI components built with Material 3.
    -   **Navigation**: Handled by `go_router`.

3.  **Data Layer** (Outer):
    -   **Repositories**: Implementations of domain repository interfaces.
    -   **Data Sources**:
        -   *Remote*: Firebase (Firestore, Auth, Storage).
        -   *Local*: Hive (for caching search results and profiles).
    -   **Models**: Data Transfer Objects (DTOs) with JSON serialization.

### Project Structure
The code is organized to reflect the architecture:
```
lib/
├── core/           # Cross-cutting concerns (DI, Routes, Utils, Constants)
├── domain/         # Inner-most layer: Entities, UseCases, Repo Interfaces
├── data/           # Outer layer: Repositories Impl, Data Sources (API/DB), Models
├── presentation/   # UI layer: BLoCs, Pages, Widgets
└── main.dart       # App entry point & initialization
```

### State Management
- **BLoC (Business Logic Component)** pattern is used for predictable state management.
- `Equatable` is used for value equality in States and Events.

### Dependency Injection
- `get_it` is used for service locator pattern, decoupled setup in `lib/core/di/service_locator.dart`.

## Setup & Running

### Prerequisites
- Flutter SDK 3.10.4 or higher
- Dart SDK 3.0.0 or higher
- **Critical**: You must add the Firebase configuration files from your Firebase Console:
    - Android: `android/app/google-services.json`
    - iOS: `ios/Runner/GoogleService-Info.plist`

### Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd technopalette_machine_test
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

## Testing

The project includes comprehensive Unit and BLoC tests.

To run all tests:
```bash
flutter test
```

To run a specific test file:
```bash
flutter test test/search/search_bloc_test.dart
```

## Tools & Packages
- `flutter_bloc`: State Management
- `go_router`: Navigation
- `firebase_core/auth/cloud_firestore`: Backend
- `hive`: Local Database
- `equatable`: Value Comparison
- `get_it`: Dependency Injection
- `dartz`: Functional Programming (Either)
- `mocktail`: Testing

## Code Quality
- **Linting**: Uses `flutter_lints` with 0 warnings.
- **Formatting**: Code is formatted according to Dart standards.
- **Structure**: Strict adherence to Feature-first / Layer-first Clean Architecture.
