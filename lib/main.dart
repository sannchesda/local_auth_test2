// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_test2/Service/LocalAuthService.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalAuthentication auth = LocalAuthentication();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Local Authentication'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final List<BiometricType> isAuthenticated = await LocalAuthService.getBiometrics();
                  print(isAuthenticated);
                  Fluttertoast.showToast(
                    msg: isAuthenticated.toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    fontSize: 18,
                    backgroundColor: Colors.blue,
                    textColor: Colors.yellow,
                  );
                },
                child: Text("Get Available Biometrics Type"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final isAuthenticated = await LocalAuthService.authenticate();
                  print(isAuthenticated);
                  if(isAuthenticated){
                    Fluttertoast.showToast(
                      msg: "Press Again to Exit",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      fontSize: 18,
                      backgroundColor: Colors.blue,
                      textColor: Colors.yellow,
                    );

                  }else{
                    Fluttertoast.showToast(
                      msg: "Iasdasdsa",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      fontSize: 18,
                      backgroundColor: Colors.blue,
                      textColor: Colors.yellow,
                    );
                  }
                },
                child: Icon(Icons.fingerprint),
              ),
            ),

            Expanded(
              child: ListView(
                children: _deviceData.keys.map((String property) {
                  return Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          property,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            child: Text(
                              '${_deviceData[property]}',
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      // body: ListView(
      //   padding: const EdgeInsets.only(top: 30),
      //   children: [
      //     Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         if (_supportState == _SupportState.unknown)
      //           CircularProgressIndicator()
      //         else if (_supportState == _SupportState.supported)
      //           Text("This device is supported")
      //         else
      //           Text("This device is not supported"),
      //         Divider(height: 100),
      //         Text('Can check biometrics: $_canCheckBiometrics\n'),
      //         ElevatedButton(
      //           child: const Text('Check biometrics'),
      //           onPressed: _checkBiometrics,
      //         ),
      //         Divider(height: 100),
      //         Text('Available biometrics: $_availableBiometrics\n'),
      //         ElevatedButton(
      //           child: const Text('Get available biometrics'),
      //           onPressed: _getAvailableBiometrics,
      //         ),
      //         Divider(height: 100),
      //         Text('Current State: $_authorized\n'),
      //         (_isAuthenticating)
      //             ? ElevatedButton(
      //                 onPressed: _cancelAuthentication,
      //                 child: Row(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: [
      //                     Text("Cancel Authentication"),
      //                     Icon(Icons.cancel),
      //                   ],
      //                 ),
      //               )
      //             : Column(
      //                 children: [
      //                   ElevatedButton(
      //                     child: Row(
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         Text('Authenticate'),
      //                         Icon(Icons.perm_device_information),
      //                       ],
      //                     ),
      //                     onPressed: _authenticate,
      //                   ),
      //                   ElevatedButton(
      //                     child: Row(
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         Text(_isAuthenticating
      //                             ? 'Cancel'
      //                             : 'Authenticate: biometrics only'),
      //                         Icon(Icons.fingerprint),
      //                       ],
      //                     ),
      //                     onPressed: _authenticateWithBiometrics,
      //                   ),
      //                 ],
      //               ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getDeviceInfo();
  }


  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {

    return <String, dynamic>{

      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  void getDeviceInfo() {

  }

}


enum _SupportState {
  unknown,
  supported,
  unsupported,
}
