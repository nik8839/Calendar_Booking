# Calendar Booking Application

## Overview
The Calendar Booking Application is a full-stack project designed to manage bookings efficiently. It consists of a backend built with Node.js and Express, and a frontend web application built using Flutter. The application allows users to create, view, and manage bookings with ease.

## Features
### Backend
- **Create Booking**: Users can create a booking by providing user ID, start time, and end time.
- **View Booking by ID**: Fetch details of a specific booking using its ID.
- **View All Bookings**: Retrieve a list of all bookings.

### Frontend
- **User-Friendly Interface**: A Flutter-based web app with an intuitive UI.
- **Date and Time Pickers**: Allows users to select start and end times for bookings.
- **Real-Time Clock**: Displays the current time in the app.
- **Error Handling**: Provides feedback for invalid inputs or server errors.

## Prerequisites
- **Backend**:
  - Node.js (v14 or higher)
  - npm (Node Package Manager)
- **Frontend**:
  - Flutter SDK
  - Android Studio or Visual Studio Code (for development)

## How to Run
### Backend
1. Navigate to the `backend` directory:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the server:
   ```bash
   npm start
   ```
   The server will run on `http://localhost:5000` by default.

### Frontend
1. Navigate to the `calendar_booking_app` directory:
   ```bash
   cd calendar_booking_app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```
   The app will launch on a connected device or emulator.

## API Endpoints
### Base URL
`http://localhost:5000`

### Endpoints
- **POST /bookings**: Create a new booking.
- **GET /bookings/:id**: Fetch a booking by ID.
- **GET /bookings**: Retrieve all bookings.

## Technologies Used
- **Backend**: Node.js, Express, dotenv
- **Frontend**: Flutter, Dart

## Future Enhancements
- Add user authentication.
- Implement notifications for upcoming bookings.
- Enhance UI with additional themes and animations.

