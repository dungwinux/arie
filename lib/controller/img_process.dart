import 'package:firebase_ml_vision/firebase_ml_vision.dart';

Future<List<Barcode>> mlBarcodeScan(String imagePath) async {
  final image = FirebaseVisionImage.fromFilePath(imagePath);
  final BarcodeDetector barcodeDetector =
      FirebaseVision.instance.barcodeDetector();
  final List<Barcode> barcodes = await barcodeDetector.detectInImage(image);
  barcodeDetector.close();
  return barcodes;
}

Future<List<ImageLabel>> mlObjectLabel(String imagePath) async {
  final image = FirebaseVisionImage.fromFilePath(imagePath);
  final ImageLabeler imageLabeler = FirebaseVision.instance.imageLabeler();
  final List<ImageLabel> labels = await imageLabeler.processImage(image);
  imageLabeler.close();
  return labels;
}
