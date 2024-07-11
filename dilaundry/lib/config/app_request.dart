class AppRequest {
  static Map<String, String> header([String? token]) {
    if (token == null) {
      return {
        'Accept': 'application/json',
      };
    }

    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
