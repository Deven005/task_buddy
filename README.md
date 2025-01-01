# Task Buddy - Flutter Task Management App

## Overview

Task Buddy is a simple and intuitive Task Management App built with **Flutter**, featuring robust
task management capabilities, seamless data persistence with **SQLite** and **Hive**, and a clean
and responsive UI. The app allows users to add, edit, delete, and manage tasks, and it also provides
options for theme customization, task prioritization, and more.

## Features

### 1. **Task Management**

- Add, edit, delete, and view tasks.
- Mark tasks as "Completed" or "Pending."
- Prioritize tasks (Low, Medium, High).
- Filter tasks by priority and due date.

### 2. **Data Storage**

- **SQLite** for storing **task details** (task name, description, due date, priority, etc.).
- **Hive** for storing **user preferences** (theme, notification settings, etc.).

### 3. **State Management**

- **Riverpod** for state management.
- Efficient management of task data and user preferences.

### 4. **MVVM Architecture**

- The app follows the **MVVM (Model-View-ViewModel)** architecture for a clean code structure:
    - **Model**: Data models for tasks and user preferences.
    - **ViewModel**: Contains business logic to interact with the database and manage state.
    - **View**: The UI, built with Flutter widgets.

### 5. **Responsive Design**

- Adapts seamlessly for both **mobile** and **tablet** devices.
- Mobile layout displays tasks in a list format.
- Tablet layout features a split view showing the task list and task details side-by-side.

### 6. **Theme Customization**

- Dark and Light themes supported.
- Themes are stored in **Hive** for persistence across app sessions.

### 7. **Optional Features**

- Task reminder notifications.
- Search and filter functionality for tasks.

## Tech Stack

- **Flutter** (Dart)
- **Riverpod** for state management
- **SQLite** for persistent task storage
- **Hive** for storing app settings and preferences
- **Material Design** for UI components

## Installation

To get started with Task Buddy, clone the repository and run the app locally.

### Clone the Repository

```bash
git clone https://github.com/yourusername/task_buddy.git
cd task_buddy
flutter pub get
dart run build_runner watch
flutter run