import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String? email;
  final bool isEmailVerified;
  final String? displayName;

  const AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email,
        displayName: user.displayName,
        isEmailVerified: user.emailVerified,
      );
}
