import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pickle_app/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    required String? name,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UserModel;

  // Factory method to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Create UserModel from UserEntity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photoUrl: entity.photoUrl,
      emailVerifiedAt: entity.emailVerifiedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convert to UserEntity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      emailVerifiedAt: emailVerifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Factory method to create from Supabase user
  factory UserModel.fromSupabaseUser(
    dynamic user, {
    Map<String, dynamic>? userData,
  }) {
    final metadata = user.userMetadata ?? <String, dynamic>{};

    // If we have userData from the profiles table, use that as the source of truth
    if (userData != null && userData.isNotEmpty) {
      return UserModel(
        id: user.id,
        email: userData['email'] ?? user.email ?? '',
        name:
            userData['full_name'] as String? ??
            metadata['full_name'] as String?,
        photoUrl:
            userData['avatar_url'] as String? ??
            metadata['avatar_url'] as String?,
        emailVerifiedAt: user.emailConfirmedAt,
        createdAt: userData['created_at'] as String? ?? user.createdAt,
        updatedAt: userData['updated_at'] as String? ?? user.updatedAt,
      );
    }

    // Fall back to auth user metadata if no userData provided
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: metadata['full_name'] as String?,
      photoUrl: metadata['avatar_url'] as String?,
      emailVerifiedAt: user.emailConfirmedAt,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}
