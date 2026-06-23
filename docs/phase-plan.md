# Emora — Project Phase Plan

### IS4110 Capstone Project
### Group 01 – Sabaragamuwa University of Sri Lanka

---

## Project Overview

**Emora** is an AI-powered emotion-based music recommendation mobile application developed using Flutter, Firebase, Flask, DeepFace, and the YouTube Data API. The project is divided into six development phases to ensure systematic implementation, testing, and integration of all components.

---

## Phase 1 – User Authentication System

**Responsible Member:** Niruban

### Objective

Develop a secure user authentication system for account creation, login, and session management.

### Activities

- Create Firebase project
- Configure Flutter-Firebase integration
- Enable Email/Password Authentication
- Enable Google Sign-In Authentication
- Implement user registration
- Implement user login
- Implement logout functionality
- Handle authentication errors

### Deliverables

- Firebase project configuration
- Registration screen
- Login screen
- Google sign-in functionality
- Authentication service implementation

### Expected Outcome

Users can securely create accounts, log in, and access the application.

---

## Phase 2 – Database Management System

**Responsible Member:** Wathsiluni

### Objective

Develop the cloud database structure required to store user information, emotion history, and playlist data.

### Activities

- Configure Cloud Firestore
- Design database collections
- Create security rules
- Implement CRUD operations
- Store user profile information
- Retrieve user data

### Deliverables

- Firestore database structure
- Database service functions
- Security rules implementation
- User profile management module

### Expected Outcome

Application data is securely stored and retrieved through Firestore.

---

## Phase 3 – Emotion Detection Backend

**Responsible Member:** Geethma

### Objective

Develop an AI-powered backend service capable of detecting user emotions from uploaded images.

### Activities

- Set up Flask backend environment
- Configure Python virtual environment
- Install and configure DeepFace dependencies
- Implement image upload and processing functionality
- Integrate DeepFace emotion recognition model
- Develop emotion detection API endpoints
- Generate structured JSON responses
- Implement exception and error handling
- Optimize emotion detection performance
- Prepare backend deployment configuration

### Deliverables

- Flask backend application
- DeepFace emotion recognition module
- Emotion detection API
- Image processing functionality
- API documentation
- Backend deployment configuration

### Expected Outcome

The system successfully identifies emotions from facial images.

---

## Phase 4 – Music Recommendation Service

**Responsible Member:** Dinithi

### Objective

Develop a recommendation engine that suggests music according to detected emotions.

### Activities

- Configure YouTube Data API
- Store API credentials securely
- Create recommendation endpoint
- Map emotions to music genres
- Retrieve relevant YouTube videos
- Handle API exceptions

### Deliverables

- Recommendation API
- Emotion-to-music mapping module
- YouTube integration service

### Expected Outcome

Users receive suitable music recommendations based on detected emotions.

---

## Phase 5 – Frontend Integration

**Responsible Member:** Hafsa

### Objective

Integrate all backend services with the Flutter mobile application.

### Activities

- Create API service layer
- Integrate Emotion Detection API
- Integrate Music Recommendation API
- Implement image upload functionality
- Display recommendation results
- Store emotion history
- Handle network errors

### Deliverables

- Fully integrated Flutter application
- API communication services
- Recommendation interface
- Emotion history module

### Expected Outcome

Users can upload images, detect emotions, and receive music recommendations through a seamless interface.

---

## Phase 6 – Administration & Analytics Module

**Responsible Member:** Team Collaboration

### Objective

Develop an administrative dashboard to monitor application usage and system activity.

### Activities

- Create admin dashboard
- Develop administrative APIs
- Generate system statistics
- Implement access control
- Create monitoring features
- Implement activity logging

### Deliverables

- Admin dashboard
- User management module
- Analytics reports
- System monitoring tools

### Expected Outcome

Administrators can effectively monitor users, application performance, and system activities.

---

## Project Timeline

| Phase | Description | Responsible Member |
|---------|-------------|-------------------|
| Phase 1 | User Authentication System | Niruban |
| Phase 2 | Database Management System | Wathsiluni |
| Phase 3 | Emotion Detection Backend | Geethma |
| Phase 4 | Music Recommendation Service | Dinithi |
| Phase 5 | Frontend Integration | Hafsa |
| Phase 6 | Administration & Analytics Module | Team Collaboration |

---

## Final Project Deliverables

- Flutter Mobile Application
- Firebase Authentication System
- Cloud Firestore Database
- Flask Backend API
- DeepFace Emotion Detection Module
- YouTube Music Recommendation Engine
- Admin Dashboard
- Testing Documentation
- User Documentation
- Final Project Report

---

## Conclusion

The Emora project follows a structured phase-based development approach that ensures all major components are developed, integrated, and validated systematically. Each phase contributes to the successful completion of the final system while promoting clear responsibility allocation among team members.
