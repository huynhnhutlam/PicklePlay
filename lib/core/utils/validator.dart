import 'package:formz/formz.dart';

// Email validation
enum EmailValidationError { invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  static final _emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?$",
  );

  @override
  EmailValidationError? validator(String? value) {
    return _emailRegex.hasMatch(value ?? '')
        ? null
        : EmailValidationError.invalid;
  }
}

// Password validation
enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  static const _minPasswordLength = 6;

  @override
  PasswordValidationError? validator(String? value) {
    return (value ?? '').length >= _minPasswordLength
        ? null
        : PasswordValidationError.invalid;
  }
}

// Required field validation
enum RequiredFieldValidationError { empty }

class RequiredField<T> extends FormzInput<T, RequiredFieldValidationError> {
  const RequiredField.pure() : super.pure('' as T);
  const RequiredField.dirty([T? value]) : super.dirty(value as T);

  @override
  RequiredFieldValidationError? validator(T? value) {
    if (value == null) return RequiredFieldValidationError.empty;
    if (value is String && value.trim().isEmpty) {
      return RequiredFieldValidationError.empty;
    }
    if (value is List && value.isEmpty) {
      return RequiredFieldValidationError.empty;
    }
    if (value is Map && value.isEmpty) {
      return RequiredFieldValidationError.empty;
    }
    return null;
  }
}

// Name validation
enum NameValidationError { invalid }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);

  static const _minNameLength = 2;

  @override
  NameValidationError? validator(String? value) {
    final trimmedValue = (value ?? '').trim();
    return trimmedValue.length >= _minNameLength
        ? null
        : NameValidationError.invalid;
  }
}

// Phone number validation
enum PhoneNumberValidationError { invalid }

class PhoneNumber extends FormzInput<String, PhoneNumberValidationError> {
  const PhoneNumber.pure() : super.pure('');
  const PhoneNumber.dirty([String value = '']) : super.dirty(value);

  static final _phoneRegex = RegExp(
    r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$',
  );

  @override
  PhoneNumberValidationError? validator(String? value) {
    return _phoneRegex.hasMatch(value ?? '')
        ? null
        : PhoneNumberValidationError.invalid;
  }
}

// Validation error messages
extension ValidationMessages on String {
  static String get email => 'Please enter a valid email address';
  static String get password => 'Password must be at least 6 characters long';
  static String get required => 'This field is required';
  static String get phone => 'Please enter a valid phone number';
  static String get name => 'Name must be at least 2 characters long';
}
