# Hackathon Admin Panel

A modern, responsive web admin panel for hackathon management built with Flutter.

## Features

### 🎯 Core Functionality
- **Dashboard Analytics** - Real-time metrics and insights
- **Hackathon Management** - Create, edit, and manage hackathons
- **Multi-step Wizard** - Intuitive hackathon creation process
- **Participant Management** - User registration and team management
- **Event Timeline** - Schedule and milestone tracking

### 🎨 Modern Design
- **Custom Design System** - Beautiful, modern UI components
- **Responsive Layout** - Perfect on mobile, tablet, and desktop
- **Dark/Light Theme** - Automatic theme switching
- **Smooth Animations** - Fluid micro-interactions
- **Glass Morphism** - Modern translucent effects

### 🏗️ Architecture
- **State Management** - Flutter Bloc/Cubit pattern
- **Navigation** - GoRouter for declarative routing
- **Dependency Injection** - GetIt service locator
- **Clean Architecture** - Modular and scalable codebase

## Quick Start

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run -d chrome --web-port 3000

# Build for production
flutter build web
```

## Project Structure

```
lib/
├── core/                   # Core functionality
│   ├── di/                # Dependency injection
│   └── constants/         # App constants
├── shared/                # Shared components
│   ├── theme/            # Custom theme system
│   ├── widgets/          # Reusable UI components
│   ├── utils/            # Utility functions
│   └── services/         # Core services
├── features/             # Feature modules
│   ├── auth/            # Authentication
│   ├── dashboard/       # Main dashboard
│   ├── hackathons/      # Hackathon management
│   └── wizard/          # Creation wizard
└── main.dart            # App entry point
```

## Configuration

Update `lib/config/app_config.dart` with your API settings:

```dart
class AppConfig {
  static const String baseUrl = 'https://your-api.com/api';
  static const String apiKey = 'your-api-key';
  static const bool isDevelopment = true;
}
```

## Responsive Breakpoints

- **Mobile**: < 600px
- **Tablet**: 600px - 1024px  
- **Desktop**: > 1024px

## Tech Stack

- **Flutter 3.8+** - UI framework
- **Dart 3.0+** - Programming language
- **Flutter Bloc** - State management
- **GoRouter** - Navigation
- **Dio** - HTTP client
- **GetIt** - Dependency injection

## Development

The app is designed to work fully offline with mock data. Simply add your API configuration when ready to connect to a backend.

## License

This project is licensed under the MIT License.
