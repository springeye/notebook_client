import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ntp/ntp.dart';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';
void main() {
  setUp(() async {});

  tearDown(() async {});
  group("OTP Tests", () {
    test("generate OTP Code", () {
      var secret=base32.encodeString("12345678901234567890");
      print("${secret}\n");

      final code3 = OTP.generateTOTPCodeString(
          secret, DateTime.now().millisecondsSinceEpoch,
          length: 6,
          interval: 30,
          isGoogle: false,
          algorithm: Algorithm.SHA1);
      print(code3);

    });

  });
}
