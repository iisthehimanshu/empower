
import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart' as g;
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../Navigation/API/QRDataAPI.dart';
import '../Navigation/API/buildingAllApi.dart';
import '../Navigation/ApiModels/QRDataAPIModel.dart';
import '../Navigation/Elements/HelperClass.dart';
import '../Navigation/Elements/Translator.dart';
import '../Navigation/Navigation.dart';



class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  static String? bid;
  static String? landmarkID;
  static String? source;
  bool _isDeepLinkHandled = false;
  @override
  void reassemble() {
    super.reassemble();
    controller?.pauseCamera();
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TranslatorWidget(
          text: 'QR Scanner',
          fontSize: '18',
          fontWeight: '500',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: TranslatorWidget(
                text: 'Scan QR code',
                fontSize: '12',
                fontWeight: '400',
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!_isDeepLinkHandled) {
        _isDeepLinkHandled = true;
        try {
          final uri = Uri.parse(scanData.code ?? '');
          String qrCode = uri.fragment.split('/').last;
          print("qrCode");
          print(qrCode);

          List<QRDataAPIModel>? qrData = await QRDataAPI().fetchQRData(buildingAllApi.allBuildingID.keys.toList());
          qrData?.forEach((e){
            if(e.code == qrCode){
              if(e.landmarkId == null){
                HelperClass.launchURL(scanData.code!);
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>   Navigation(directLandID: e.landmarkId!),
                  ),
                );
              }
            }
          });
          print(qrData);
          print("qrScanner");
          print(uri);
          controller.stopCamera();
        } catch (e) {
          print('Error parsing URL: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
