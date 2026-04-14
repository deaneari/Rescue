# Rescue Emergency Platform

This repository contains the product and technical foundation for a rescue and emergency dispatch platform with three roles:

1. Manager
2. Emergency dispatcher
3. User

The mobile client is planned in Flutter (Dart) with BLoC + RxDart, deep-link event opening, and full localization support.

## Core Requirements

### User details

- private_name
- sur_name
- email
- phone_number
- residence_address
- work_address
- car_type
- car_plate_number

### Roles and authorizations

- Manager:
	- add users
	- set user roles
	- create events
	- add users to events
	- modify events
	- change event status
	- delete events
	- see all events
- Emergency dispatcher:
	- create events
	- change event status
	- add users to events
	- see all events
- User:
	- see all events within 50 km from current location
	- accept events
	- decline events

### Event lifecycle

Event status values:

1. opened
2. assigned
3. user_arrived_on_spot
4. solved
5. closed

### Event payload

- title
- detail
- location
- customer details:
	- private_name
	- sur_name
	- mobile_number
	- car_plate_number
	- car_type
	- car_color
	- car_description
	- notes
- assigned users list
- solved_by_user
- closed_by_user

### Event chat payload

- title
- message
- ptt voice messages
- location
- sender user details (same schema as user details)

## Mobile Application

### Technology

- Flutter + Dart
- BLoC and RxDart for state management
- Multi-localization
- Deep-link support to open event details from push notifications

### Screens

- 4-tab bottom navigation:
	- user list
	- event list
	- center PTT screen (top 40% groups list, bottom 60% PTT button)
	- group list
- manager + emergency dispatcher:
	- create event
	- edit event
	- delete event
- manager only:
	- add user
	- remove user
- event details:
	- full event data
	- open chat button with message count
	- status dropdown
- event chat screen:
	- messages list by event

## Repository Structure

- docs/requirements.md: full product requirements and acceptance criteria
- docs/authorization-matrix.md: role-to-capability matrix
- mobile/rescue_app/lib/domain: entities, enums, permissions
- mobile/rescue_app/lib/application: BLoC placeholders and contracts
- mobile/rescue_app/lib/presentation: routing, localization, screen placeholders

## Next Steps

1. Generate a Flutter project in mobile/rescue_app and wire these files into the generated structure.
2. Add API client and DTO mapping for auth, users, events, and chat modules.
3. Implement role guards, 50 km nearby-event filtering, and event chat transport.
