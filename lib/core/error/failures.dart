import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure(String message, {String? code}) : super(message, code: code);
}

class CacheFailure extends Failure {
  const CacheFailure(String message, {String? code}) : super(message, code: code);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(String message) : super(message);
}

// Auth failures
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure() : super('Email already in use');
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure() : super('Invalid email');
}

class UserDisabledFailure extends AuthFailure {
  const UserDisabledFailure() : super('User disabled');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('User not found');
}

class WrongPasswordFailure extends AuthFailure {
  const WrongPasswordFailure() : super('Wrong password');
}

// Booking failures
class BookingFailure extends Failure {
  const BookingFailure(String message) : super(message);
}

class SlotNotAvailableFailure extends BookingFailure {
  const SlotNotAvailableFailure() : super('Selected slot is not available');
}

// Profile failures
class ProfileFailure extends Failure {
  const ProfileFailure(String message) : super(message);
}

// Venue failures
class VenueFailure extends Failure {
  const VenueFailure(String message) : super(message);
}
