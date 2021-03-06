import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String uid,
    required String email,
    required String displayName,
    required String photoURL,
    required String accessToken,
  }) = _User;
}
