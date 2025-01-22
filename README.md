# Projet-S9

# Teams :
1. Frontend : Dorian Peltier & Ilyas El Haddady
2. Backend : Ilyas Khiat & Paul Coulomb
3. Prologue : Paul Seckinger & Loïc Merret
   
# AVA - Artificial Life Assistant

## Overview
AVA (Artificial Life Assistant) is an innovative application designed to help users maintain a healthy lifestyle by providing personalized life rules and daily tasks. The application is divided into three main components: a frontend, a backend, and a rule-processing engine written in Prolog.

---

## Features
- **Personalized Health Management**: Tracks user-specific data such as height, weight, and other relevant health metrics.
- **Task Management**: Displays daily tasks and goals on an intuitive interface.
- **Rule-Based Analysis**: Implements and evaluates life rules using Prolog to ensure the user stays on track with their health goals.

---

## Architecture

### 1. Frontend
- **Technology**: Dart and Flutter
- **Functionality**: Provides an interactive interface for users to view and manage their daily tasks.
- **Key Features**:
  - Intuitive design for tracking progress.
  - Clear visualization of tasks and health goals.

### 2. Backend
- **Technology**: Dart and Firebase
- **Functionality**: Acts as a bridge between the frontend and the Prolog rule engine. It handles user data and ensures seamless synchronization between the components.
- **Key Features**:
  - Stores user data such as height, weight, and activity logs.
  - Communicates with the Prolog engine to fetch and process health rule evaluations.

### 3. Rule Processing Engine
- **Technology**: Prolog
- **Functionality**: Encodes and evaluates life rules to ensure the user’s health goals are met.
- **Key Features**:
  - Defines life rules (e.g., recommended sleep hours, physical activity).
  - Processes user data and determines compliance with the rules.
  - Sends results back to the backend for display on the frontend.

---

## How It Works
1. **Data Input**: Users input their health data (e.g., weight, height, sleep hours) through the frontend.
2. **Backend Communication**: The data is stored in Firebase and sent to the Prolog engine for rule evaluation.
3. **Rule Evaluation**: Prolog processes the data against predefined rules to determine compliance.
4. **Results Display**: The evaluation results are returned to the backend and displayed on the frontend for user feedback.

---

## Installation and Setup

### Prerequisites
- **Flutter SDK**
- **Dart**
- **Firebase account**
- **Prolog environment**

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/merretloic/AVA.git
   ```
2. Navigate to the project directory:
   ```bash
   cd AVA
   ```
3. Set up the Flutter frontend:
   ```bash
   flutter pub get
   flutter run
   ```
4. Configure Firebase:
   - Add your Firebase configuration file to the project.
   - Set up authentication and database services.
5. Run the backend service:
   ```bash
   dart backend.dart
   ```
6. Install and run the Prolog engine to process rules.

---

## Future Improvements
- Expand rule definitions to cover more aspects of health and wellness.
- Integrate AI models for dynamic rule generation and customization.
- Add gamification features to increase user engagement.

---

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your changes.

---

## License
This project is open-source and available under the MIT License.

---

## Contact
For questions or support, please contact The AVA team.
