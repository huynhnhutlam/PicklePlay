import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  bool get isEmailVerified => emailVerifiedAt != null;

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    photoUrl,
    emailVerifiedAt,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, isEmailVerified: $isEmailVerified)';
  }
}
