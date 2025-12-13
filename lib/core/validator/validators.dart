import 'package:email_validator/email_validator.dart';

/// ===================== GLOBAL REGEX =====================

final RegExp _sqlKeywords = RegExp(
  r'\b(select|insert|update|delete|drop|truncate|union|exec|alter|create)\b',
  caseSensitive: false,
);

final RegExp _sqlLogic = RegExp(
  r'(\bor\b|\band\b)\s+\d+=\d+',
  caseSensitive: false,
);

final RegExp _sqlComments = RegExp(r'(--|/\*|\*/)', caseSensitive: false);

final RegExp _xssPattern = RegExp(
  r'(<script|</script>|javascript:|onerror=|onload=)',
  caseSensitive: false,
);

final RegExp _commandInjection = RegExp(r'(\||;|&&|\$\(|`)');

bool _isMalicious(String input) {
  return _sqlKeywords.hasMatch(input) ||
      _sqlLogic.hasMatch(input) ||
      _sqlComments.hasMatch(input) ||
      _xssPattern.hasMatch(input) ||
      _commandInjection.hasMatch(input);
}

/// ===================== TEXT (Names, General) =====================

String? validateName(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }

  final v = value.trim();

  if (v.length < 2 || v.length > 50) {
    return '$fieldName must be between 2 and 50 characters';
  }

  if (!RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$').hasMatch(v)) {
    return '$fieldName contains invalid characters';
  }

  if (_isMalicious(v)) {
    return '$fieldName contains forbidden content';
  }

  return null;
}

/// ===================== EMAIL =====================
String? validateEmail(
  String? input, {
  AuthFieldMode mode = AuthFieldMode.emailOnly,
}) {
  if (input == null || input.trim().isEmpty) {
    return 'This field is required';
  }

  final v = input.trim();

  if (v.length > 254) {
    return 'Input is too long';
  }

  if (_isMalicious(v)) {
    return 'Input contains invalid characters';
  }

  switch (mode) {
    case AuthFieldMode.emailOnly:
      if (!EmailValidator.validate(v)) {
        return 'Enter a valid email address';
      }
      break;

    case AuthFieldMode.phoneOnly:
      final phone = v.replaceAll(RegExp(r'[^\d]'), '');
      if (!RegExp(r'^\d{8,15}$').hasMatch(phone)) {
        return 'Enter a valid phone number';
      }
      break;

    case AuthFieldMode.emailOrPhone:
      final isEmail = EmailValidator.validate(v);
      final phone = v.replaceAll(RegExp(r'[^\d]'), '');
      final isPhone = RegExp(r'^\d{8,15}$').hasMatch(phone);

      if (!isEmail && !isPhone) {
        return 'Enter a valid email or phone number';
      }
      break;
  }

  return null;
}

/// ===================== PHONE =====================

String? validatePhone(String? phone) {
  if (phone == null || phone.trim().isEmpty) {
    return 'Phone number is required';
  }

  final clean = phone.replaceAll(RegExp(r'[^\d]'), '');

  if (!RegExp(r'^\d{8,15}$').hasMatch(clean)) {
    return 'Enter a valid phone number';
  }

  return null;
}

/// ===================== NATIONAL NUMBER =====================

String? validateNationalNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'National number is required';
  }

  if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
    return 'Invalid national number';
  }

  return null;
}

/// ===================== PASSWORD =====================

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  }

  if (password.contains(' ')) {
    return 'Password cannot contain spaces';
  }

  if (password.length < 10) {
    return 'Password must be at least 10 characters';
  }

  if (password.length > 128) {
    return 'Password is too long';
  }

  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return 'Password must contain an uppercase letter';
  }

  if (!RegExp(r'[a-z]').hasMatch(password)) {
    return 'Password must contain a lowercase letter';
  }

  if (!RegExp(r'\d').hasMatch(password)) {
    return 'Password must contain a number';
  }

  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
    return 'Password must contain a special character';
  }

  if (RegExp(r'(.)\1{3,}').hasMatch(password)) {
    return 'Password pattern is too weak';
  }

  const commonPasswords = {
    'password',
    'password123',
    '123456',
    'qwerty',
    'admin',
  };

  if (commonPasswords.contains(password.toLowerCase())) {
    return 'Password is too common';
  }

  return null;
}
enum AuthFieldMode {
  emailOnly,
  phoneOnly,
  emailOrPhone,
}
