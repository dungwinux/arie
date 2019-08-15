import 'package:firebase_ml_vision/firebase_ml_vision.dart';

final List<String> supportType = ['barcode', 'object'];

Future<List<String>> imgProcess(String imagePath, {String mode}) {
  final image = FirebaseVisionImage.fromFilePath(imagePath);
  // TODO: [Low] Add more type
  switch (mode) {
    case 'barcode':
      return mlBarcodeScan(image);
    case 'object':
      return mlObjectLabel(image);
    default:
      return Future.sync(() => []);
  }
}

Future<List<String>> mlBarcodeScan(FirebaseVisionImage image) async {
  /// Return all barcode value visible on image

  final BarcodeDetector barcodeDetector =
      FirebaseVision.instance.barcodeDetector();
  final List<Barcode> barcodes = await barcodeDetector.detectInImage(image);
  barcodeDetector.close();
  return barcodes.map((x) => x.rawValue).toList();
}

Future<List<String>> mlObjectLabel(FirebaseVisionImage image) async {
  /// Return label with confidence > 0.5

  final ImageLabeler imageLabeler = FirebaseVision.instance.imageLabeler();
  final List<ImageLabel> labels = await imageLabeler.processImage(image);
  imageLabeler.close();
  
  return labels
      .where((x) => x.confidence > 0.5)
      .map((ImageLabel x) => x.text)
      .toList();
}
