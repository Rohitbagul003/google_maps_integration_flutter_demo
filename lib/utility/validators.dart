import 'package:flutter/material.dart';

import 'enum.dart';

class TValidator {
  static String? Function(String?)? buildValidators(BuildContext context, ChoiceEnum choice) {
    String? emailValidators(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty".toLowerCase();
      }
      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
        return "Invalid Name".toLowerCase();
      }

      if (!value.startsWith(RegExp(r'[A-Za-z]'))) {
        return "Invalid Email".toLowerCase();
      }
      if (value.length > 32) {
        return "Email must be less than 32 letters".toLowerCase();
      }
      if (value.length < 6) {
        return "Email is too short".toLowerCase();
      }
      return null;
    }

    String? nameValidators(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty".toLowerCase();
      }
      if (value.length > 32) {
        return "Name must be less than 32 letters".toLowerCase();
      }
      if (!value.startsWith(RegExp(r'[A-za-z]'))) {
        return "Invalid Name".toLowerCase();
      }
      if (value.length < 6) {
        return "Name Should be atleast 3 letters".toLowerCase();
      }
      // if (value.contains(RegExp(r'[0-9]'))) {
      //   return "invalid_name".tr().toLowerCase();
      // }
      if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(value)) {
        return "Invalid Name".toLowerCase();
      }
      return null;
    }

    String? phoneValidtors(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty".toLowerCase();
      }
      if (value.length < 10) {
        return "Number can't be less than 10 digits".toLowerCase();
      }
      if (value.contains(RegExp(r'[A-Z]')) || value.contains(RegExp(r'[a-z]')) || value.contains(".com")) {
        return "Phone Number must only contain Digits".toLowerCase();
      }
      if (value.length > 10) {
        return "Invalid Phone Number".toLowerCase();
      }
      if (!RegExp(r"[0-9]{10}").hasMatch(value)) {
        return "Invalid Phone Number".toLowerCase();
      }
      if (!value.startsWith(RegExp(r"[0-9]"))) {
        return "Invalid Phone Number".toLowerCase();
      }
      return null;
    }

    String? passwordValidators(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty".toLowerCase();
      }
      return null;
    }

    String? confirmPasswordValidators(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty".toLowerCase();
      } else if (value.length < 8) {
        return "Password can't be less than 8 letters".toLowerCase();
      }

      return null;
    }

    String? textValidator(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty".toLowerCase();
      }

      return null;
    }

    String? addressValidator(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty".toLowerCase();
      }
      if (value.length > 46) {
        return "Text can't be more than 46 characters".toLowerCase();
      }

      return null;
    }

    String? forgotPasswordValidators(String? value) {
      if (value!.isEmpty) {
        return "This field can't be empty".toLowerCase();
      }
      //For Number
      if (value.startsWith(RegExp(r"[0-9]"))) {
        if (!RegExp(r"^[0-9]{10}").hasMatch(value)) {
          return "Invalid Phone Number".toLowerCase();
        }
        if (value.length < 10) {
          return "Number can't be less than 10 digits".toLowerCase();
        }
        if (value.length > 10) {
          return "Invalid Phone Number".toLowerCase();
        }

        if (value.contains(RegExp(r'[A-Z]')) || value.contains(RegExp(r'[a-z]')) || value.contains(".com")) {
          return "Phone Number must only contain Digits".toLowerCase();
        }

        return null;
      }

      //for email
      if (!value.startsWith(RegExp(r'[A-Z][a-z]'))) {
        if (!RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$").hasMatch(value)) {
          return "Invalid Email".toLowerCase();
        }
        if (value.length > 32) {
          return "Email must be less than 32 letters".toLowerCase();
        }
        if (value.length < 6) {
          return "Email is too short".toLowerCase();
        }

        return null;
      }

      return null;
    }

    if (choice == ChoiceEnum.name) return nameValidators;
    if (choice == ChoiceEnum.email) return emailValidators;
    if (choice == ChoiceEnum.password) return passwordValidators;
    if (choice == ChoiceEnum.phone) return phoneValidtors;
    if (choice == ChoiceEnum.confirmPassword) return confirmPasswordValidators;
    if (choice == ChoiceEnum.reset) return forgotPasswordValidators;
    if (choice == ChoiceEnum.text) return textValidator;
    if (choice == ChoiceEnum.address) return addressValidator;

    return nameValidators;
  }
}
