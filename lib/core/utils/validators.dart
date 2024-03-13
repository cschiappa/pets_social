import 'package:pets_social/core/utils/utils.dart';

String? emptyField(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter this field.';
  }

  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter this field.';
  }
  return null;
}

String? usernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter this field.';
  }

  if (value.length >= 15) {
    return 'Username must be 15 characters or less.';
  }

  return null;
}

String? bioValidator(String? value) {
  if (value != null && value.length >= 150) {
    return 'Bio must be 150 characters or less.';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter this field.';
  }

  if (isPasswordValid(value) == false) {
    return 'Your password must contain a minimum of 5 letters, at least 1 upper case letter, 1 lower case letter, 1 numeric character and one special character.';
  }
  return null;
}

String? petTagValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter this field.';
  }

  if (value.length == 1) {
    return 'Please choose only one tag.';
  }

  return null;
}
