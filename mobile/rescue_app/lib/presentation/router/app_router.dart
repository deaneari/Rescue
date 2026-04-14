class AppRoutePaths {
  const AppRoutePaths._();

  static const String users = '/users';
  static const String events = '/events';
  static const String ptt = '/ptt';
  static const String groups = '/groups';
  static const String createEvent = '/events/create';
  static const String eventDetails = '/events/details';
  static const String eventChat = '/events/chat';
  static const String userManagement = '/users/manage';
}

class EventDeepLink {
  const EventDeepLink({required this.eventId});

  final String eventId;

  static EventDeepLink? tryParse(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Supported format example: rescue://events/123
    if (uri.host == 'events' && uri.pathSegments.isNotEmpty) {
      return EventDeepLink(eventId: uri.pathSegments.first);
    }

    // Supported format example: https://app.rescue/events/123
    if (uri.pathSegments.length >= 2 && uri.pathSegments.first == 'events') {
      return EventDeepLink(eventId: uri.pathSegments[1]);
    }

    return null;
  }
}
