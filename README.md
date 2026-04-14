# Rescue App

The Rescue App is a Flutter application that implements a BLoC + RxDart architecture for managing emergency events. 

## Features
- Role-based UI and navigation with a 4-tab bottom navigation (Users, Events, PTT, Groups).
- Covers localization (English and Hebrew).
- Dio-based API client with JWT for authentication and API calls.
- Deep link routing to open event details from links.

## APIs Used
- `POST /api/token/`: Obtain JWT token.
- `POST /api/token/refresh/`: Refresh JWT token.
- `GET /api/user/profile/`: Fetch user profile.
- `GET /api/user/location/`: Fetch user location.
- `GET /api/alerts/`: Fetch alerts.
- `GET /api/alerts/nearby/`: Fetch nearby alerts.
- `GET /api/group/`: Fetch user groups.
- `GET /api/message/`: Fetch messages.

## Data



## Running the Project
1. Clone the repository.
2. Navigate to the `mobile/rescue_app` directory.
3. Install the Flutter dependencies.
4. Run the app using `flutter run`.
