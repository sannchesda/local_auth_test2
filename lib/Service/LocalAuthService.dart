

import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService{
  static final localAuth = LocalAuthentication();
  static Future<bool> hasBiometrics() async {
    try {
      return await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async{
    try{
      return await localAuth.getAvailableBiometrics();
    } on PlatformException catch(e){
      print (e);
      return <BiometricType>[];
    }

  }

  static Future<bool> authenticate() async {

    final isAvailable = await hasBiometrics();
    if(!isAvailable) return false;

    try{
      return await localAuth.authenticate(
        localizedReason: "Scan To Edit Profile",
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
        sensitiveTransaction: true,
        androidAuthStrings: AndroidAuthMessages(
          biometricHint: "Biometric hint",
          biometricNotRecognized: "biometricNotRecognized",
          biometricRequiredTitle: "biometricRequiredTitle",
        ),
        iOSAuthStrings: IOSAuthMessages(

        ),

      );
    } on PlatformException catch(e){
      print(e);
      return false;
    }

  }


}