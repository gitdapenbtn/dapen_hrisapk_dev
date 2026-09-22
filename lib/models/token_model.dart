class TokenModel {
  final String accessToken;
  final String? refreshToken;

  TokenModel({required this.accessToken, this.refreshToken});

  factory TokenModel.fromJson(Map<String, dynamic> data) {
    return TokenModel(
      accessToken: data['access_token'],
      refreshToken: data['refresh_token'],
    );
  }
}
