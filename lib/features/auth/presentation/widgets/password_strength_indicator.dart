import 'package:flutter/material.dart';

enum PasswordStrength { weak, medium, strong, veryStrong }

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final bool showIndicator;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.showIndicator = true,
  });

  PasswordStrength _getPasswordStrength() {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length check
    if (password.length >= 8) score += 1;
    if (password.length >= 12) score += 1;

    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) score += 1;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 1;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 1;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score += 1;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 3) return PasswordStrength.medium;
    if (score <= 4) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  Color _getStrengthColor() {
    switch (_getPasswordStrength()) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.yellow;
      case PasswordStrength.veryStrong:
        return Colors.green;
    }
  }

  String _getStrengthText() {
    switch (_getPasswordStrength()) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  double _getStrengthPercentage() {
    switch (_getPasswordStrength()) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.medium:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!showIndicator || password.isEmpty) {
      return const SizedBox.shrink();
    }

    // final strength = _getPasswordStrength();
    final color = _getStrengthColor();
    final text = _getStrengthText();
    final percentage = _getStrengthPercentage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Text(
          _getPasswordHint(),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  String _getPasswordHint() {
    final hints = <String>[];

    if (password.length < 8) {
      hints.add('At least 8 characters');
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      hints.add('Lowercase letter');
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      hints.add('Uppercase letter');
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      hints.add('Number');
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      hints.add('Special character');
    }

    if (hints.isEmpty) {
      return 'Password meets all requirements';
    }

    return 'Add: ${hints.join(', ')}';
  }
}
