import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/blank_card.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as imglib;
import 'dart:ui' as ui;
import 'dart:typed_data';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  int _cameraId = -1;
  bool _initialized = false;
  bool _photoTaken = false;
  late String _lastImagePath;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeOrDisposeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      if (_cameraId >= 0 && !_isDisposed) {
        await CameraPlatform.instance.dispose(_cameraId);
        _cameraId = -1;
      }

      final List<CameraDescription> cameras =
      await CameraPlatform.instance.availableCameras();
      if (cameras.isNotEmpty) {
        _cameraId = await CameraPlatform.instance.createCamera(
          cameras[0],
          ResolutionPreset.veryHigh,
        );
        await CameraPlatform.instance.initializeCamera(_cameraId);
        setState(() {
          _initialized = true;
        });
      }
    } on CameraException catch (e) {
      _showSnackBar(
          'Failed to initialize camera: ${e.code}: ${e.description}');
    }
  }

  Future<void> _disposeCamera() async {
    if (_cameraId >= 0 && _initialized && !_isDisposed) {
      await CameraPlatform.instance.dispose(_cameraId);
      if (!_isDisposed) {
        setState(() {
          _initialized = false;
        });
      }
      _cameraId = -1;
    }
  }

  void _initializeOrDisposeCamera() {
    if (_initialized) {
      _disposeCamera();
    } else {
      _initializeCamera();
    }
  }

  Future<void> _takePhoto() async {
    if (_cameraId >= 0 && _initialized) {
      // Pause the preview before taking a photo
      await CameraPlatform.instance.pausePreview(_cameraId);

      final XFile file = await CameraPlatform.instance.takePicture(_cameraId);

      // Decode the image file
      final File imageFile = File(file.path);
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final ui.Image image =
      await decodeImageFromList(Uint8List.fromList(imageBytes));

      // Check if the image is flipped, and correct it if needed
      final bool isFlipped = image.width > image.height;
      final imglib.Image imgLibImage = imglib.decodeImage(imageBytes)!;
      final imglib.Image fixedImage = isFlipped
          ? imglib.flipHorizontal(imgLibImage)
          : imgLibImage;

      // Get the documents directory
      final Directory documentsDirectory =
      await getApplicationDocumentsDirectory();

      // Create a folder named "Kiosk"
      final Directory kioskDirectory =
      Directory('${documentsDirectory.path}/Kiosk/Photos');
      if (!await kioskDirectory.exists()) {
        await kioskDirectory.create();
      }

      // Save the corrected image to the "Kiosk" folder
      final String newPath =
          '${kioskDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(newPath).writeAsBytes(imglib.encodeJpg(fixedImage));

      setState(() {
        _photoTaken = true;
        _lastImagePath = newPath;
      });

      _showSnackBar('Photo captured and saved: $newPath');
    }
  }

  Future<void> _retakePhoto() async {
    // Delete the last taken photo
    if (await File(_lastImagePath).exists()) {
      await File(_lastImagePath).delete();
      setState(() {
        _photoTaken = false;
      });

      // Resume the preview after retaking the photo
      await CameraPlatform.instance.resumePreview(_cameraId);
    }
  }

  void _navigateToNextPage() {
    if (_photoTaken) {
      _disposeCamera(); // Dispose the camera before navigating to the next page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InsertBlankCard(), // Replace with your desired next page
        ),
      );
    } else {
      // Show an alert if a photo hasn't been taken yet
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Take Photo'),
            content: const Text('Please take a photo before proceeding.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildOverlay(Size previewSize) {
    final double circleRadius = min(previewSize.width, previewSize.height) / 3;

    return Center(
      child: Container(
        width: 500,
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_initialized) CameraPlatform.instance.buildPreview(_cameraId),
            Container(
              width: circleRadius * 2,
              height: circleRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  void dispose() {
    _isDisposed = true;
    _disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Page'),
      ),
      body: Column(
        children: [
          _buildOverlay(const Size(400, 400)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _photoTaken ? _retakePhoto : _takePhoto,
            child: Text(_photoTaken ? 'Retake' : 'Take Photo'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Dispose the camera when "Cancel" is clicked
                  _disposeCamera();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _navigateToNextPage,
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
