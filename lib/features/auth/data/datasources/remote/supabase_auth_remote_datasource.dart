import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:pickle_app/core/error/exceptions.dart';
import 'package:pickle_app/core/network/supabase_client.dart' as core;
import 'package:pickle_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'auth_remote_datasource.dart';

@Injectable(as: AuthRemoteDataSource)
class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final supabase.SupabaseClient _supabaseClient;
  final supabase.GoTrueClient _authClient;

  SupabaseAuthRemoteDataSource()
    : _supabaseClient = core.SupabaseClient.client,
      _authClient = core.SupabaseClient.auth;

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      developer.log('Signing in with email: $email', name: 'SupabaseAuth');

      // Input validation
      if (email.isEmpty || password.isEmpty) {
        throw ServerException('Email and password are required');
      }

      if (!RegExp(r'^[^@]+@[^\s]+\.[^\s]+').hasMatch(email)) {
        throw ServerException('Please enter a valid email address');
      }

      // Sign in with Supabase
      final response = await _authClient.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      // Log successful sign in
      developer.log(
        'User signed in: ${response.user?.email}',
        name: 'SupabaseAuth',
      );

      if (response.user == null) {
        throw ServerException('No user data returned from Supabase');
      }

      // Get user profile from profiles table
      final userProfile = await _getUserProfile(response.user!.id);
      return UserModel.fromSupabaseUser(response.user!, userData: userProfile);
    } on supabase.AuthException catch (e) {
      String errorMessage = 'Authentication failed';

      // Map common Supabase auth errors to user-friendly messages
      switch (e.message) {
        case 'Invalid login credentials':
          errorMessage = 'Incorrect email or password';
          break;
        case 'Email not confirmed':
          errorMessage = 'Please verify your email before signing in';
          break;
        case 'User not found':
          errorMessage = 'No account found with this email';
          break;
        case 'Network error':
          errorMessage =
              'Unable to connect to the server. Please check your internet connection';
          break;
      }

      print('❌ [Supabase] AuthException: ${e.message}');
      throw ServerException(errorMessage);
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      print('❌ [Supabase] Unexpected error: $e');
      print('📜 Stack trace: $stackTrace');
      throw ServerException(
        'An unexpected error occurred. Please try again later.',
      );
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    // try {
    developer.log(
      'Creating new user account for: $email',
      name: 'SupabaseAuth',
    );

    // Create user in Auth
    final response = await _authClient.signUp(
      email: email.trim(),
      password: password,
      emailRedirectTo: 'io.supabase.pickleapp://login-callback',
      data: {
        'name': name.trim(),
        'avatar_url': '',
        'updated_at': DateTime.now().toIso8601String(),
      },
    );
    print(response.user?.toJson());
    if (response.user == null) {
      throw ServerException('Failed to create user account');
    }

    // Create user profile in database
    await _createUserProfile(
      userId: response.user!.id,
      email: email,
      name: name,
    );

    developer.log(
      'User account created: ${response.user!.email}',
      name: 'SupabaseAuth',
    );

    return UserModel.fromSupabaseUser(response.user!);
    // } on supabase.PostgrestException catch (e) {
    //   developer.log(
    //     'Database error during sign up: ${e.message}',
    //     error: e,
    //     name: 'SupabaseAuth',
    //   );
    //   throw ServerException('Failed to create user profile');
    // } on supabase.AuthException catch (e) {
    //   developer.log(
    //     'Auth error during sign up: ${e.message}',
    //     error: e,
    //     name: 'SupabaseAuth',
    //   );
    //   throw ServerException(_mapAuthError(e.message));
    // } catch (e, stackTrace) {
    //   developer.log(
    //     'Unexpected error during sign up',
    //     error: e,
    //     stackTrace: stackTrace,
    //     name: 'SupabaseAuth',
    //   );
    //   throw ServerException('An unexpected error occurred');
    // }
  }

  // @override
  // Future<UserModel> signInWithGoogle() async {
  //   try {
  //     final response = await authClient.signInWithOAuth(
  //       supabase.Provider.google,
  //       redirectTo: 'io.supabase.pickleapp://login-callback',
  //     );

  //     if (response.user == null) {
  //       throw  ServerException('Failed to sign in with Google');
  //     }

  //     return UserModel.fromSupabaseUser(response.user!);
  //   } on supabase.AuthException catch (e) {
  //     throw ServerException(e.message);
  //   } catch (e) {
  //     throw  ServerException('Failed to sign in with Google');
  //   }
  // }

  // @override
  // Future<UserModel> signInWithApple() async {
  //   try {
  //     final response = await authClient.signInWithOAuth(
  //       supabase.Provider.apple,
  //       redirectTo: 'io.supabase.pickleapp://login-callback',
  //     );

  //     if (response.user == null) {
  //       throw  ServerException('Failed to sign in with Apple');
  //     }

  //     return UserModel.fromSupabaseUser(response.user!);
  //   } on supabase.AuthException catch (e) {
  //     throw ServerException(e.message);
  //   } catch (e) {
  //     throw  ServerException('Failed to sign in with Apple');
  //   }
  // }

  @override
  Future<void> signOut() async {
    try {
      await _authClient.signOut();
      developer.log('User signed out', name: 'SupabaseAuth');
    } on supabase.AuthException catch (e) {
      developer.log(
        'Error during sign out: ${e.message}',
        error: e,
        name: 'SupabaseAuth',
      );
      throw ServerException(_mapAuthError(e.message));
    } catch (e, stackTrace) {
      developer.log(
        'Unexpected error during sign out',
        error: e,
        stackTrace: stackTrace,
        name: 'SupabaseAuth',
      );
      throw ServerException('Failed to sign out');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;

      // Get the latest user data
      final response = await _authClient.getUser();
      if (response.user == null) return null;

      // Get user profile
      final userProfile = await _getUserProfile(response.user!.id);

      return UserModel.fromSupabaseUser(response.user!, userData: userProfile);
    } on supabase.AuthException catch (e) {
      developer.log(
        'Error getting current user: ${e.message}',
        error: e,
        name: 'SupabaseAuth',
      );
      rethrow;
    } catch (e, stackTrace) {
      developer.log(
        'Unexpected error getting current user',
        error: e,
        stackTrace: stackTrace,
        name: 'SupabaseAuth',
      );
      throw ServerException('Failed to get current user');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authClient.resetPasswordForEmail(email);
    } on supabase.AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to send password reset email');
    }
  }

  // Helper method to get user profile from database
  Future<Map<String, dynamic>?> _getUserProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response as Map<String, dynamic>?;
    } on supabase.PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // No rows returned
        return null;
      }
      rethrow;
    }
  }

  // Helper method to create user profile in database
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    required String name,
    String? avatarUrl,
  }) async {
    await _supabaseClient.from('profiles').upsert({
      'id': userId,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // Map Supabase auth errors to user-friendly messages
  String _mapAuthError(String message) {
    switch (message) {
      case 'Invalid login credentials':
        return 'Incorrect email or password';
      case 'Email not confirmed':
        return 'Please verify your email before signing in';
      case 'User not found':
        return 'No account found with this email';
      case 'Network error':
        return 'Unable to connect to the server. Please check your internet connection';
      case 'User already registered':
        return 'An account with this email already exists';
      case 'Weak password':
        return 'Please choose a stronger password';
      case 'Email rate limit exceeded':
        return 'Too many attempts. Please try again later';
      default:
        return message.isNotEmpty
            ? message
            : 'An authentication error occurred';
    }
  }

  @override
  Future<UserModel> refreshToken(String refreshToken) async {
    try {
      final response = await _authClient.refreshSession();

      if (response.user == null) {
        throw ServerException('Failed to refresh token');
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on supabase.AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Failed to refresh token');
    }
  }
}
