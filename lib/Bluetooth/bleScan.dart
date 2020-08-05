import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth {
  Bluetooth._();
  static final Bluetooth ble = Bluetooth._();
  static final FlutterBlue flutterBlue = FlutterBlue.instance;
  //static bool _on;
  bool _inProgress;

  Future<void> scan() async {
    // Start scanning
    bool on = (await flutterBlue.isAvailable) && (await flutterBlue.isOn);
    if (!on || on == null) {
      //_on = false;
      print("Bluetooth off");
    } else {
      //_on = true;
      print("Bluetooth on");
      _inProgress = await flutterBlue.isScanning.first;
      if (!_inProgress) {
        start();
        print('Started0');
      } else {
        print("Already scanning");
      }
    }
  }

  Future<void> start() async {
    try {
      print('Started1');
      flutterBlue.startScan(timeout: Duration(seconds: 60));
      print('Started2');
      _inProgress = true;

// Listen to scan results
      flutterBlue.scanResults.listen((results) async {
        // do something with scan results
        for (ScanResult r in results) {
          BluetoothDevice bluetoothDevice = r.device;
          print('bluetoothDeviceID: ${bluetoothDevice.id}');
          print('RSSI:${r.rssi}');
          print('buff: ${r.buff}');
          AdvertisementData advertisementData = r.advertisementData;
          print('ManufacturerData: ${advertisementData.manufacturerData}');
          // Connect to the device
          /*await bluetoothDevice.connect();
          List<BluetoothService> services =
              await bluetoothDevice.discoverServices();
          services.forEach((service) async {
            // do something with service
            print('service: $service');
            // Reads all characteristics
            var characteristics = service.characteristics;
            for (BluetoothCharacteristic c in characteristics) {
              print('characteristic: $c');
              List<int> value = await c.read();
              print(value);
              // Reads all descriptors
              var descriptors = c.descriptors;
              for (BluetoothDescriptor d in descriptors) {
                print('descriptor: $d');
                List<int> value = await d.read();
                print(value);
              }
            }
          });*/
        }
      });
// Stop scanning
      //flutterBlue.stopScan();
    } catch (e) {
      print('Scan error: $e');
    }
  }
}
