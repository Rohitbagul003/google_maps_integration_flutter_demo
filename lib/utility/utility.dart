import 'package:flutter/material.dart';

mixin Utility {
  void dismissKeyboard() => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

  SizedBox heightBox5() => const SizedBox(height: 5);
  SizedBox heightBox10() => const SizedBox(height: 10);
  SizedBox heightBox20() => const SizedBox(height: 20);
  SizedBox heightBox40() => const SizedBox(height: 40);
  SizedBox heightBox50() => const SizedBox(height: 50);

  SizedBox widthBox5() => const SizedBox(width: 5);
  SizedBox widthBox10() => const SizedBox(width: 10);
  SizedBox widthBox16() => const SizedBox(width: 16);
  SizedBox widthBox20() => const SizedBox(width: 20);
  SizedBox widthBox30() => const SizedBox(width: 30);
}
