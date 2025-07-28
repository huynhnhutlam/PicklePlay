import 'package:flutter_test/flutter_test.dart';
import 'package:pickle_app/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    const testUserModel = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: 'https://example.com/photo.jpg',
      emailVerifiedAt: '2023-01-01T00:00:00.000Z',
      createdAt: '2023-01-01T00:00:00.000Z',
      updatedAt: '2023-01-01T00:00:00.000Z',
    );

    final testJson = {
      'id': '1',
      'email': 'test@example.com',
      'name': 'Test User',
      'photo_url': 'https://example.com/photo.jpg',
      'email_verified_at': '2023-01-01T00:00:00.000Z',
      'created_at': '2023-01-01T00:00:00.000Z',
      'updated_at': '2023-01-01T00:00:00.000Z',
    };

    test('should be a subclass of UserEntity', () {
      // Assert
      expect(testUserModel, isA<UserModel>());
    });

    test('fromJson should return a valid model', () {
      // Act
      final result = UserModel.fromJson(testJson);

      // Assert
      expect(result, testUserModel);
    });

    test('toJson should return a JSON map with proper data', () {
      // Act
      final result = testUserModel.toJson();

      // Assert
      expect(result, testJson);
    });

    test('toEntity should return a UserEntity with the same properties', () {
      // Act
      final entity = testUserModel.toEntity();

      // Assert
      expect(entity.id, testUserModel.id);
      expect(entity.email, testUserModel.email);
      expect(entity.name, testUserModel.name);
      expect(entity.photoUrl, testUserModel.photoUrl);
      expect(entity.emailVerifiedAt, testUserModel.emailVerifiedAt);
      expect(entity.createdAt, testUserModel.createdAt);
      expect(entity.updatedAt, testUserModel.updatedAt);
    });

    test('fromEntity should create a UserModel from UserEntity', () {
      // Arrange
      final entity = testUserModel.toEntity();

      // Act
      final result = UserModel.fromEntity(entity);

      // Assert
      expect(result, testUserModel);
    });
  });
}
