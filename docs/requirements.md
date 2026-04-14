# Requirements and Acceptance Criteria

## 1. Roles

The system supports three roles:

- manager
- emergency_dispatcher
- user

## 2. User Profile Fields

Required fields:

- private_name
- sur_name
- email
- phone_number
- residence_address
- work_address
- car_type
- car_plate_number

Acceptance criteria:

1. A user cannot be created without all required fields.
2. Email must be unique.
3. Role must be one of manager, emergency_dispatcher, user.

## 3. Event Model

Required fields:

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
- status
- assigned_users
- solved_by_user
- closed_by_user

Allowed status transitions:

1. opened -> assigned
2. assigned -> user_arrived_on_spot
3. user_arrived_on_spot -> solved
4. solved -> closed

Acceptance criteria:

1. Event creation must set initial status to opened.
2. Status transitions outside the allowed flow are rejected.
3. Only manager and emergency_dispatcher can create events.
4. Only manager and emergency_dispatcher can change status.

## 4. Event Visibility

Rules:

- manager: sees all events.
- emergency_dispatcher: sees all events.
- user: sees events within 50 km of current location.

Acceptance criteria:

1. Nearby events for user are filtered using great-circle distance.
2. Distance threshold is <= 50 km.
3. User can accept or decline visible events.

## 5. Event Chat

Chat becomes available after users are assigned to an event.

Message payload:

- title
- message
- optional ptt_voice_message_url
- optional location
- sender profile snapshot

Acceptance criteria:

1. Only assigned users, manager, and emergency_dispatcher can access event chat.
2. Chat supports text, optional voice, and optional location attachments.
3. Event details screen displays chat message count.

## 6. Mobile App Requirements

Technology requirements:

- Flutter + Dart
- BLoC + RxDart
- Multi-localization
- Deep-link open event screen from push notification payload

UI requirements:

1. Bottom navigation with 4 tabs:
   - user list
   - event list
   - ptt center
   - group list
2. Manager and emergency_dispatcher: create/edit/delete events.
3. Manager only: add/remove users.
4. Event details screen includes status dropdown and chat access.
5. Event chat screen lists messages for current event.

## 7. Non-Functional Requirements

1. Role checks enforced both UI-side and API-side.
2. Event and chat list pagination for performance.
3. Localization keys for all static text.
4. Push notification deep links must be idempotent and safe to repeat.
