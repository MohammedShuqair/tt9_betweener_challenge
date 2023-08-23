class ApiSettings {
  static const String baseUrl = 'https://betweener.gsgtt.tech/api/';
  static const String login = '${baseUrl}login';
  static const String register = '${baseUrl}register';
  static const String links = '${baseUrl}links';
  static const String search = '${baseUrl}search';
  static const String follow = '${baseUrl}follow';
  static const String editLink = '${baseUrl}links/{id}';
  static const String deleteLink = '${baseUrl}links/{id}';
  static const String updateLocation = '${baseUrl}update/{id}';
  static const String activeSharing = '${baseUrl}activeShare/{id}';
  static const String nearestSender = '${baseUrl}activeShare/nearest/{id}';
}
