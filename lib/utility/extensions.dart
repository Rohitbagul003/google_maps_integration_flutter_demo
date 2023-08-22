import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String capitalizeWords() {
    if (length <= 1) {
      return toUpperCase();
    }

    // Split string into multiple words
    final List<String> words = split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    // Join/Merge all words back to one String
    return capitalizedWords.join(' ');
  }

  String removeAllWhitespace() {
    return replaceAll(RegExp(r"\\\s+"), "");
  }

  String removeHSPFromString() {
    return replaceAll("\ ", "");
  }

  String removeLSEPFromString() {
    return replaceAll(" ", "");
  }

  String removeEscapeCharacterFromString() {
    return replaceAll("\n", " ");
  }
}

extension PaddingHelper on Widget {
  /// set symmetric padding of 16
  Padding get p16 => Padding(padding: const EdgeInsets.all(16), child: this);

  Padding get p10 => Padding(padding: const EdgeInsets.all(10), child: this);

  /// Set all side padding according to `value`
  Padding p(double value) => Padding(padding: EdgeInsets.all(value), child: this);

  /// Set horizontal padding according to `value`
  Padding pH(double value) => Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);

  /// Set vertical padding according to `value`
  Padding pV(double value) => Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);

  /// Horizontal Padding 16
  Padding get hP4 => Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: this);
  Padding get hP8 => Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: this);
  Padding get hP16 => Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: this);
  Padding get hP10 => Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: this);
  Padding get hP20 => Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: this);

  /// Vertical Padding 16
  Padding get vP30 => Padding(padding: const EdgeInsets.symmetric(vertical: 30), child: this);
  Padding get vP16 => Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: this);
  Padding get vP10 => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: this);
  Padding get vP8 => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: this);
  Padding get vP4 => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: this);

  /// Set right side padding according to `value`
  Padding pR(double value) => Padding(padding: EdgeInsets.only(right: value), child: this);

  /// Set left side padding according to `value`
  Padding pL(double value) => Padding(padding: EdgeInsets.only(left: value), child: this);

  /// Set Top side padding according to `value`
  Padding pT(double value) => Padding(padding: EdgeInsets.only(top: value), child: this);

  /// Set bottom side padding according to `value`
  Padding pB(double value) => Padding(padding: EdgeInsets.only(bottom: value), child: this);
}

extension MarginHelper on Widget {
  /// set symmetric margin of 16
  Container get m16 => Container(margin: const EdgeInsets.all(16), child: this);

  /// Set all side margin according to `value`
  Container m(double value) => Container(margin: EdgeInsets.all(value), child: this);

  /// Set horizontal margin according to `value`
  Container mH(double value) => Container(margin: EdgeInsets.symmetric(horizontal: value), child: this);

  /// Set vertical margin according to `value`
  Container mV(double value) => Container(margin: EdgeInsets.symmetric(vertical: value), child: this);

  /// Horizontal Container) 16
  Container get hM4 => Container(margin: const EdgeInsets.symmetric(horizontal: 4), child: this);
  Container get hM8 => Container(margin: const EdgeInsets.symmetric(horizontal: 8), child: this);
  Container get hM16 => Container(margin: const EdgeInsets.symmetric(horizontal: 16), child: this);
  Container get hM10 => Container(margin: const EdgeInsets.symmetric(horizontal: 10), child: this);
  Container get hM20 => Container(margin: const EdgeInsets.symmetric(horizontal: 20), child: this);

  /// Vertical Container) 16
  Container get vM30 => Container(margin: const EdgeInsets.symmetric(vertical: 30), child: this);
  Container get vM16 => Container(margin: const EdgeInsets.symmetric(vertical: 16), child: this);
  Container get vM8 => Container(margin: const EdgeInsets.symmetric(vertical: 8), child: this);
  Container get vM4 => Container(margin: const EdgeInsets.symmetric(vertical: 4), child: this);

  /// Set right side margin according to `value`
  Container mR(double value) => Container(margin: EdgeInsets.only(right: value), child: this);

  /// Set left side margin according to `value`
  Container mL(double value) => Container(margin: EdgeInsets.only(left: value), child: this);

  /// Set Top side margin according to `value`
  Container mT(double value) => Container(margin: EdgeInsets.only(top: value), child: this);

  /// Set bottom side margin according to `value`
  Container mB(double value) => Container(margin: EdgeInsets.only(bottom: value), child: this);
}

extension RadiusHelper on Widget {
  Container get bR16 => Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)), child: this);

  /// Set all side border radius according to `value`
  Container bR(double value) =>
      Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(value)), child: this);

  /// Border Radius of double 6 and 15
  Container get bR6 => Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)), child: this);
  Container get bR15 => Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)), child: this);

  /// Border Radius of double 30
  Container get bR30 => Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)), child: this);
}

extension OnPressed on Widget {
  Widget ripple(Function onPressed, {BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(5))}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                onPressed();
              },
              child: Container(),
            ),
          )
        ],
      );

  Widget onUserTap(Function onPressed) => GestureDetector(
        onTap: () {
          onPressed();
        },
        child: this,
      );
}
