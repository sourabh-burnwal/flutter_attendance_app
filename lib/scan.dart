import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:satsang_attendance/upload.dart';

class ScanPage extends StatefulWidget {
  final String dropDownValue;
  const ScanPage({Key? key, required this.dropDownValue}) : super(key: key);
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanResult? scanResult;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final scanResult = this.scanResult;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Select a Camera'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.camera),
              tooltip: 'Scan',
              onPressed: _scan,
            )
          ],
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            if (scanResult != null)
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: const Text('Scan Result'),
                      subtitle: (scanResult.type.toString() == 'Cancelled')
                          ? Text('No QR found')
                          : Text(scanResult.rawContent.replaceAll('_', '\n')+'\n'+DateFormat('yyyy-MM-dd  kk:mm a').format(DateTime.now())),
                    ),
                    SizedBox(height: 20.0,),
                    flatButton("   Mark Attendance   ", scanResult.rawContent),
                    SizedBox(height: 30.0,),
                  ],
                ),
              ),
            const ListTile(
              title: Text('Camera selection'),
              dense: true,
              enabled: false,
            ),
            RadioListTile(
              onChanged: (v) => setState(() => _selectedCamera = -1),
              value: -1,
              title: const Text('Default camera'),
              groupValue: _selectedCamera,
            ),
            ...List.generate(
              _numberOfCameras,
                  (i) => RadioListTile(
                onChanged: (v) => setState(() => _selectedCamera = i),
                value: i,
                title: (i == 0)
                    ? Text('Rear Camera')
                    : Text('Front Camera'),
                groupValue: _selectedCamera,
              ),
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
          options: ScanOptions(
              useCamera: _selectedCamera
          )
      );
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }

  Widget flatButton(String text, String data) {
    var notPressed = true;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        onPressed: () async {
          if(notPressed){
          notPressed = false;
          UploadToGoogleSheet.insert(data, widget.dropDownValue);
        }
        },
        child: Text(
          text,
          style: TextStyle(color: Color.fromARGB(255, 254, 255, 255),fontWeight: FontWeight.bold),
        ),
        // shape: RoundedRectangleBorder(
        //     side: BorderSide(color: Colors.blue,width: 3.0),
        //     borderRadius: BorderRadius.circular(20.0)),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Color.fromRGBO(73, 131, 255, 1),
          ),
          elevation: MaterialStateProperty.all(0.0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}