# Daegri Application Installation Guide

## 1. Overview

This document provides instructions for setting up and running the Daegri application. The project consists of a Flutter frontend and a Flask backend.

## 2. Prerequisites

Before you begin, ensure you have the following installed:

*   **Flutter SDK:**
    *   Install the Flutter SDK from the [official Flutter website](https://flutter.dev/docs/get-started/install).
*   **Python:**
    *   Install Python 3.x from the [official Python website](https://www.python.org/downloads/).
    *   `pip` (Python package installer) is usually included with Python installations.
*   **Git:**
    *   Install Git to clone the repository. Instructions can be found on the [official Git website](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

## 3. Project Setup

Clone the repository to your local machine:
```bash
git clone https://github.com/daemind/daegri.git
```
Navigate into the cloned project directory:
```bash
cd daegri
```

## 4. Backend Setup (Flask - `backend_flask` directory)

1.  **Navigate to the backend directory:**
    ```bash
    cd backend_flask
    ```

2.  **Create a Python virtual environment:**
    It's recommended to use a virtual environment to manage dependencies.
    ```bash
    python3 -m venv venv
    ```
    (Use `python -m venv venv` if `python3` is not your default Python 3 command)

3.  **Activate the virtual environment:**
    *   On Linux/macOS:
        ```bash
        source venv/bin/activate
        ```
    *   On Windows:
        ```bash
        venv\Scripts\activate
        ```

4.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

5.  **Run the Flask development server:**
    ```bash
    flask run
    ```
    Alternatively, you can run `python app.py`.
    The backend API will typically be available at `http://127.0.0.1:5000`.

## 5. Frontend Setup (Flutter - `frontend_flutter` directory)

1.  **Navigate to the frontend directory:**
    (Assuming you are in the `daegri/backend_flask` directory from the previous step, go back one level and then into `frontend_flutter`)
    ```bash
    cd ../frontend_flutter 
    ```
    (If you are in the root `daegri` directory, use `cd frontend_flutter`)

2.  **Get Flutter packages:**
    This command fetches all the necessary Flutter dependencies defined in `pubspec.yaml`.
    ```bash
    flutter pub get
    ```

3.  **Run the Flutter application:**
    Ensure you have a connected device (emulator or physical) or a browser configured for Flutter web development (e.g., Chrome for Flutter web).
    ```bash
    flutter run
    ```
    *   This command will build and run the app.
    *   You can select a target device using `flutter run -d <deviceId>` if multiple are available. List available devices with `flutter devices`.
    *   To run on a web browser (if configured), you might use `flutter run -d chrome`.

## 6. Accessing the Application

*   **Frontend:** The Flutter application will launch on your selected device, emulator, or web browser.
*   **Backend API:** The Flask backend provides APIs. For example, the sample 'hello' endpoint can be reached at `http://127.0.0.1:5000/api/hello`. You can open this URL in a browser to test if the backend is running correctly.
