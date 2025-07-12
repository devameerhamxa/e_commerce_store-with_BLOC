import 'package:equatable/equatable.dart';

class AuthResponseModel extends Equatable {
  final String token;

  const AuthResponseModel({required this.token});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }

  @override
  List<Object?> get props => [token];
}
