# 💻 Water Quality Frontend - Flutter 🌐📱

This is the frontend of the Water Quality Monitoring System, developed using Flutter for Web and Android.

## Getting Started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio)

### Installation

1. Clone the repository:

   ```bash
   git clone git@github.com:Emmanueloz/frontend_water_quality.git
   ```

2. Install the dependencies:

   ```bash
   cd frontend_water_quality.git
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

## 🗂️ Project Structure

```plaintext
lib/
│
├── core/
│   ├── constants/         # Global constants used throughout the app.
│   ├── enums/             # Enums to manage fixed sets of values.
│   ├── errors/            # Custom error handling.
│   ├── interface/         # Abstract classes or contracts for implementation.
│   ├── theme/             # App-wide theme configuration (colors, fonts, etc.).
│   └── utils/             # Utility functions and extensions.
│
├── domain/
│   ├── models/            # Data models for entities (e.g., User, Workspace).
│   └── repositories/      # Abstract definitions of data sources (interfaces).
│
├── presentation/
│   ├── pages/             # App screens (login, dashboard, etc.).
│   ├── providers/         # State management using Provider.
│   └── widgets/
│       ├── common/        # Reusable shared widgets. Using atomic design principles.
│       │   ├── atoms/     # Basic building blocks (buttons, inputs).
│       │   ├── molecules/ # Combinations of atoms (card, form).
│       │   └── organisms/ # Complex components (header, footer).
│       ├── layout/        # Layout-specific widgets (headers, navigation).
│       └── specific/      # Feature-specific widgets. Using atomic design principles.
│
└── routes/                # App routing and navigation logic.
```

## 🌿 Branching Strategy

| Branch            | Description                            | Allowed commit types                 |
| ----------------- | -------------------------------------- | ------------------------------------ |
| `main`            | Main stable branch                     | Only `merge` and tags (`vX.X.X`)     |
| `feature/<name>`  | Adds new functionalities               | `feat`, `test`, `docs`, `style`      |
| `hotfix/<name>`   | Urgent fix in production               | `fix`, `style`, `chore`              |
| `bugfix/<name>`   | Non-urgent bug fix                     | `fix`, `test`                        |
| `refactor/<name>` | Code improvements without logic change | `refactor`, `style`, `docs`, `chore` |
| `docs/<name>`     | Documentation updates                  | `docs`                               |

## ✍️ Commit types (Conventional Commits)

We use the [Conventional Commits](https://www.conventionalcommits.org/) format to improve readability of history.

| Type       | Main usage                                            | Example                                            |
| ---------- | ----------------------------------------------------- | -------------------------------------------------- |
| `feat`     | New functionality or endpoint                         | `feat: add meter registration endpoint`            |
| `fix`      | Bug fix                                               | `fix: correct firebase auth payload error`         |
| `refactor` | Internal code improvement (without changing behavior) | `refactor: optimize alert notification generation` |
| `docs`     | Documentation updates                                 | `docs: update README with OneFlow structure`       |
| `test`     | Add or modify tests                                   | `test: add unit tests for user service`            |
| `style`    | Code formatting or styling (no logic changes)         | `style: apply black formatting`                    |
| `chore`    | Maintenance tasks that do not affect code logic       | `chore: update requirements.txt`                   |
| `build`    | Build tools or dependencies updates                   | `build: add configuration android build`           |
| `release`  | Release version preparation                           | `release: v1.0.0`                                  |

## 🚀 Output

This app builds for both:

- 📱 **Android** using `flutter build apk`
- 🌐 **Web** using `flutter build web`
