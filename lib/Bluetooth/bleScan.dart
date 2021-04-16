import 'dart:async';

import 'package:app0/DB/database_provider.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:uuid/uuid.dart';

class Bluetooth {
  Bluetooth._();
  static final Bluetooth ble = Bluetooth._();
  static FlutterBlue _flutterBlue = FlutterBlue.instance;
  static const MAJOR_ID = 1;
  static const MINOR_ID = 100;
  static const TRANSMISSION_POWER = -65;
  static const IDENTIFIER = 'com.example.myDeviceRegion';
  static const LAYOUT = BeaconBroadcast.ALTBEACON_LAYOUT;
  static const MANUFACTURER_ID = 0x0118;
  //static bool _on;
  static BeaconBroadcast _beaconBroadcast = BeaconBroadcast();
  //static bool _isScanning;
  //static bool _isAdvertising;
  //static bool inProgress;
  static int _flag;
  static bool canChange;
  static String _oldOid;
  static Timer _timerOut;
  static Timer _timerIn;
  static Timer _timer;
  static Map<String, List<int>> _scanList = {};
  static int _n = 0;

  Future<void> scan(String newOid, BuildContext context) async {
    // Start scanning
    _oldOid ??= '';
    canChange ??= true;
    FlutterBlue flutterBlue2 = FlutterBlue.instance;
    bool on = (await flutterBlue2.isAvailable) && (await flutterBlue2.isOn);
    if (!on || on == null) {
      if (_oldOid != newOid) {
        showMessage("Bluetooth off", context);
      } else {
        if (canChange) {
          _oldOid = '';
          await stop();
        } else {
          showMessage(
              "One process already underway\nPlease try again nafter a few minutes!",
              context);
        }
      }
    } else {
      print("Bluetooth on");
      //inProgress ??= false;
      if (canChange) {
        /*flag ??= 1;
        if (flag == 1) {
          oldOid = newOid;
          await stop();
          start(newOid);
          print('Started0');
        } else {
          */
        if (_oldOid != newOid) {
          _oldOid = newOid;
          await stop();
          start(newOid);
          print('Started1');
        } else {
          _oldOid = '';
          await stop();
        }
      } else {
        showMessage(
            "One process already underway\nPlease try again nafter a few minutes!",
            context);
      }
    }
  }

  bool isActive(String newOid) {
    _oldOid ??= '';
    if (_oldOid != newOid) {
      return false;
    } else {
      return true;
    }
  }

// Stop scanning
  //flutterBlue.stopScan();
  static Future<void> start(String oid) async {
    String uuid;
    DateTime now = DateTime.now().toUtc();
    int duration = (10 - now.minute.remainder(10)) * 60 - now.second;
    if (duration >= 365) {
      print("Go NOW !");
      _timerIn = Timer.periodic(const Duration(seconds: 120), (Timer t1) async {
        now = DateTime.now().toUtc();
        duration = (10 - now.minute.remainder(10)) * 60 - now.second;
        if (duration <= 120) {
          _timerIn.cancel();
          print("TimerIn cancelled");
          print("Waiting...");
          _flag = 0;
          await Future.delayed(Duration(seconds: duration));
          getTimer(oid);
          print("Waited and now GO");
          //flag = 1;
        } else {
          doneScanning(oid, uuid, 15);
          //inProgress = true;
        }
      });
      uuid = await DatabaseProvider.db.getUUIDAtDate(oid);
      _n = 0;
      doneScanning(oid, uuid, 15);
    } else {
      print("Waiting...");
      _flag = 0;
      await Future.delayed(Duration(seconds: duration));
      getTimer(oid);
      print("Waited and now GO");
      //flag = 1;
    }
  }

  static Future<void> stop() async {
    _flag ??= 1;
    canChange = false;
    while (_flag == 0) {
      await Future.delayed(Duration(seconds: 1));
    }
    if (_timerOut != null) {
      _timerOut.cancel();
      print('Out cancelled');
    }
    if (_timerIn != null) {
      _timerIn.cancel();
      print('In cancelled');
    }
    if (_timer != null) {
      _timer.cancel();
      print('timer cancelled');
    }
    await _flutterBlue.stopScan();
    await _beaconBroadcast.stop();
    print('Stopped');
    //inProgress = false;
    _scanList.clear();
    canChange = true;
  }

  static void getTimer(String oid) async {
    String uuid;
    DateTime now = DateTime.now().toUtc();
    int duration = (10 - now.minute.remainder(10)) * 60 - now.second;
    if (duration < 540) {
      print("Waiting...");
      await Future.delayed(Duration(seconds: duration));
    }
    _timerOut = Timer.periodic(Duration(seconds: 600), (Timer t1) async {
      _timerIn.cancel();
      _timerIn = Timer.periodic(const Duration(seconds: 120), (Timer t2) {
        doneScanning(oid, uuid, 15);
        if (_n == 4) {
          _timerIn.cancel();
          compute(oid);
          print("TimerIn cancelled");
          //inProgress = false;
        } else {
          //inProgress = true;
        }
      });
      uuid = await DatabaseProvider.db.getUUIDAtDate(oid);
      _n = 0;
      //inProgress = true;
      doneScanning(oid, uuid, 15);
    });
    _timerIn = Timer.periodic(const Duration(seconds: 120), (Timer t2) {
      doneScanning(oid, uuid, 15);
      if (_n == 4) {
        _timerIn.cancel();
        compute(oid);
        print("TimerIn cancelled");
      } else {
        //inProgress = true;
      }
    });
    uuid = await DatabaseProvider.db.getUUIDAtDate(oid);
    _n = 0;
    //inProgress = true;
    await compute(oid);
    doneScanning(oid, uuid, 15);
    _flag = 1;
  }

  static void doneScanning(String oid, String uuidAd, int seconds) async {
    //FlutterBlue flutterBlue = FlutterBlue.instance;
    try {
      bool on = (await _flutterBlue.isAvailable) && (await _flutterBlue.isOn);
      if (!on || on == null) {
        print("Bluetooth off");
      } else {
        _flutterBlue.startScan(timeout: Duration(seconds: seconds));
        print("Here");
        // Listen to scan results
        _flutterBlue.scanResults.listen((results) async {
          // do something with scan results
          for (ScanResult r in results) {
            //BluetoothDevice bluetoothDevice = r.device;
            //print('bluetoothDeviceID: ${bluetoothDevice.id}');
            if (r.buff[30] == 190 && r.buff[31] == 172) {
              var uuid = Uuid();
              String uuidScan = uuid
                  .v4(options: {'random': r.buff.sublist(32, 48)}).toString();
              print('UUIDScan: $uuidScan');
              print('RSSI: ${r.rssi}');
              if (uuidScan.substring(9, 13) == '0786') {
                _scanList.containsKey(uuidScan)
                    ? _scanList[uuidScan].contains(r.rssi)
                        ? _scanList[uuidScan]
                            [_scanList[uuidScan].indexOf(r.rssi)] = r.rssi
                        : _scanList[uuidScan].add(r.rssi)
                    : _scanList.addAll({
                        uuidScan: [r.rssi]
                      });
              }
            }
            /*
            AdvertisementData advertisementData = r.advertisementData;
            print('ManufacturerData: ${advertisementData.manufacturerData}');*/
          }
        });
      }
      _timer = Timer(Duration(seconds: seconds), () async {
        await _flutterBlue.stopScan();
        doneAdvertising(uuidAd, 30);
      });
    } catch (e) {
      print(e);
      print("Scanning failed");
    }
  }

  static void doneAdvertising(String uuid, int seconds) async {
    //BeaconBroadcast beaconBroadcast = BeaconBroadcast();
    try {
      bool on = (await _flutterBlue.isAvailable) && (await _flutterBlue.isOn);
      if (!on || on == null) {
        print("Bluetooth off");
      } else {
        _beaconBroadcast
            .setUUID(uuid)
            .setMajorId(MAJOR_ID)
            .setMinorId(MINOR_ID)
            .setTransmissionPower(TRANSMISSION_POWER)
            .setIdentifier(IDENTIFIER)
            .setLayout(LAYOUT)
            .setManufacturerId(MANUFACTURER_ID)
            .start();
        _timer = Timer(Duration(seconds: seconds), () async {
          await _beaconBroadcast.stop();
          _n++;
          print('N= $_n');
          //inProgress = false;
        });
        print('UUID broadcasted: $uuid');
      }
    } catch (e) {
      print(e);
      print('Broadcast failed');
      _beaconBroadcast.stop();
      if (_timer != null) {
        _timer.cancel();
        print('timer cancelled');
      }
    }
  }

  static Future<void> compute(String oid) async {
    if (_scanList.isNotEmpty) {
      _scanList.forEach((key, value) async {
        int rssi = 0;
        List<int> temp = value;
        if (value.length > 3) {
          temp.sort();
          List<int> temp2 = temp.sublist(value.length - 3);
          rssi = ((temp2[0] + temp2[1] + temp2[2]) / 3).ceil();
        } else if (value.length == 3) {
          rssi = ((value[0] + value[1] + value[2]) / 3).ceil();
        } else {
          for (final i in value) {
            rssi = rssi + i;
          }
          rssi = (rssi / value.length).ceil();
        }
        await DatabaseProvider.db
            .logUUID(oid, key, DateTime.now().toUtc(), rssi);
      });
      _scanList.clear();
    }
  }

  static void showMessage(String text, BuildContext context) {
    var alert = new AlertDialog(content: new Text(text), actions: <Widget>[
      new TextButton(
          child: const Text("Ok"),
          onPressed: () {
            //Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}
