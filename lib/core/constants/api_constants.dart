class ApiConstants {
  // Ako testiraš na Android emulatoru, localhost je 10.0.2.2
  // Primer: http://10.0.2.2:8000/api
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';
  static const String products = '/products';
  static const String orders = '/orders';
}