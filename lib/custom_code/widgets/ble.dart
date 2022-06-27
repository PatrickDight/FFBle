// Automatic FlutterFlow imports
import 'dart:convert';

import 'package:flutter/material.dart';
// Begin custom widget code
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class Ble extends StatefulWidget {
  const Ble({
    Key key,
    this.width,
    this.height,
    this.doScan,
  }) : super(key: key);

  final double width;
  final double height;
  final bool doScan;

  @override
  _BleState createState() => _BleState();
}


class _BleState extends State<Ble> {

  final String title="";
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList =[];
  final List<BluetoothDevice> connectedDevicesList =[];
  final Map<Guid, List<int>> readValues =  Map<Guid, List<int>>();
  final _writeController = TextEditingController();
  BluetoothDevice _connectedDevice;
  List<BluetoothService> _services;

  _addDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      setState(() {
        devicesList.add(device);
      });
    }
  }  _addConnectedDeviceToList(final BluetoothDevice device) {
    if (!connectedDevicesList.contains(device)) {
      setState(() {
        connectedDevicesList.add(device);
      });
    }
  }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // Start scanning
//   //  flutterBlue.startScan(timeout: Duration(seconds: 10));
//
//
// // Listen to scan results
// //     var subscription = flutterBlue.scanResults.listen((results) {
// //       print("listning");
// //       print(results.length);
// //       // do something with scan results
// //       for (ScanResult r in results) {
// //         devicesName.add(r.device.id.toString());
// //         //FFAppState().counter=FFAppState().counter+1;
// //         FFAppState().devicelist.add(r.device.name);
// //
// //         print('${r.device.state}');
// //         print('${r.device.name}');
// //         print('${r.device.toString()}');
// //       }
// //       setState(() {
// //
// //       });
// //     });
//
//   }
  @override
  void initState() {
    super.initState();
    if(_connectedDevice!=null){
      _connectedDevice.state.listen((event) {

        setState(() {
          print("State updated");
        });

      });
    }

    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        print("Connected DeviceFound");
        _addConnectedDeviceToList(device);
      }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        print("Result DeviceFound");

        _addDeviceTolist(result.device);
      }
    });
    flutterBlue.startScan();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //   backgroundColor: Colors.white,
      body: devicesList.isEmpty?Text("Scanning",style: TextStyle(color: Colors.white)):
      _buildView(),
      //: _buildListViewOfDevices(),
    );

  }
  ListView _buildListViewOfDevices() {
    List<Container> containers = [];
    for (BluetoothDevice device in devicesList) {
      containers.add(
        Container(
          //height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text((device.name == ''||device.name==null) ? 'unknown device' : device.name),
                    Text(device.id.toString()),
                    Text(device.runtimeType .toString()),
                    Text(device.state.first.hashCode  .toString()),
                  ],
                ),
              ),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  _connectedDevice?.id==device.id?"Connected":'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {


                  flutterBlue.stopScan();
                  try {

                    await device.connect();

                    // flutterBlue.startScan();
                  } catch (e) {
                    // flutterBlue.startScan();

                    print("Connect Exception");

                    if (e.code != 'already_connected') {
                      throw e;

                    }
                  } finally {
                    flutterBlue.startScan();

                    print("Connect Finally");
                    _services = await device.discoverServices();
                  }
                  setState(() {
                    print("Connected Successfully");
                    _connectedDevice = device;
                  });
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(

      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons =[];

    if (characteristic.properties.read) {

      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              color: Colors.blue,
              child: Text('READ', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                var sub = characteristic.value.listen((value) {
                  readValues[characteristic.uuid] = value;
                  setState(() {

                  });
                });
                await characteristic.read();
                // sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Text('WRITE', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _writeController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Send"),
                            onPressed: () {
                              characteristic.write(
                                  utf8.encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  readValues[characteristic.uuid] = value;
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  ListView _buildConnectDeviceView() {
    List<Container> containers = [];

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = [];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if(characteristic.uuid=="e794afa8-2a47-4f3d-82d9-bdad3d2809d3"){
          // characteristicsWidget.add(
          //     Align(
          //       alignment: Alignment.centerLeft,
          //       child: Column(
          //         children: <Widget>[
          //           Row(
          //             children: <Widget>[
          //               Text(characteristic.uuid.toString(),
          //                   style: TextStyle(fontWeight: FontWeight.bold)),
          //             ],
          //           ),
          //           Row(
          //             children: <Widget>[
          //               ..._buildReadWriteNotifyButton(characteristic),
          //             ],
          //           ),
          //           Row(
          //             children: <Widget>[
          //               Text('Value: ' +
          //                   readValues[characteristic.uuid].toString()),
          //             ],
          //           ),
          //           Divider(),
          //         ],
          //       ),
          //     ),
          //   );

          print("Device found");
        }
        print("Device found UDID");
        print( readValues[characteristic.uuid].toString());
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ' + readValues[characteristic.uuid].toString(),maxLines: 3,),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        );


      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Text(service.uuid.toString()),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }

}
