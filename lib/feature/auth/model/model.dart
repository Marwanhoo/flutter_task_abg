class RequestTokenResponseModel {
  final bool success;
  final String expiresAt;
  final String requestToken;

  RequestTokenResponseModel({
    required this.success,
    required this.expiresAt,
    required this.requestToken,
  });

  factory RequestTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RequestTokenResponseModel(
      success: json['success'] ?? false,
      expiresAt: json['expires_at'] ?? "",
      requestToken: json['request_token'] ?? "",
    );
  }
}


class ValidateTokenResponseModel {
  final bool success;
  final int statusCode;
  final String statusMessage;

  ValidateTokenResponseModel({
    required this.success,
    required this.statusCode,
    required this.statusMessage,
  });

  factory ValidateTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return ValidateTokenResponseModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      statusMessage: json['status_message'] ?? "",
    );
  }
}


class CreateSessionResponseModel {
  final bool success;
  final String sessionId;

  CreateSessionResponseModel({
    required this.success,
    required this.sessionId,
  });

  factory CreateSessionResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateSessionResponseModel(
      success: json['success'] ?? false,
      sessionId: json['session_id'] ?? "",
    );
  }
}

class AccountDetailsResponseModel {
  final int id;
  final String username;

  AccountDetailsResponseModel({
    required this.id,
    required this.username,
  });

  factory AccountDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return AccountDetailsResponseModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? "",
    );
  }
}