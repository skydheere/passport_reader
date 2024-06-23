import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'api_service.dart';

class PassportReader extends StatefulWidget {
  // ignore: use_super_parameters
  const PassportReader({Key? key, required this.apiKey}) : super(key: key);

  final String apiKey;

  @override
  _PassportReaderState createState() => _PassportReaderState();
}

class _PassportReaderState extends State<PassportReader> {
  String? resultText;

  CameraDescription? _cameraDescription;
  XFile? _capturedImage;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraDescription = cameras.first;
      _controller = CameraController(
        _cameraDescription!,
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _controller.initialize();
      setState(() {});
    } else {
      print("No cameras available");
    }
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      setState(() {
        _capturedImage = image;
        resultText = null;
      });
      _processCapturedImage();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _processCapturedImage() async {
    if (_capturedImage != null) {
      setState(() {
        _isProcessing = true;
      });

      final response = await ApiService.processPassportImage(
          File(_capturedImage!.path), widget.apiKey);

      setState(() {
        try {
          _isProcessing = false;
          if (response != 'No text found') {
            final jsonResponseString = response
                .replaceAllMapped(
                  RegExp(r'```json([\s\S]*?)```'),
                  (match) => match.group(1) ?? '',
                )
                .trim();

            final jsonResponse = jsonDecode(jsonResponseString);

            _handleParsedData(jsonResponse);
          } else {
            resultText = 'Error: ${response}';
          }
        } catch (e) {
          setState(() {
            _capturedImage = null;
          });
          log('Failed to decode JSON response: $e');
        }
      });
    }
  }

  String _formatResponse(Map<String, dynamic> data) {
    return jsonEncode(data);
  }

  void _handleParsedData(jsonResponse) {
    try {
      final extractedData = {
        'name': jsonResponse['name'] ?? '',
        'mother_name': jsonResponse['mother_name'] ?? '',
        'nationality': jsonResponse['nationality'] ?? '',
        'dob': jsonResponse['dob'] ?? '',
        'gender': jsonResponse['gender'] ?? '',
        'passport_no': jsonResponse['passport_no'] ?? '',
      };
      log('extacted data $extractedData');
      Navigator.pop(context, extractedData);
    } catch (e) {
      setState(() {
        _capturedImage = null;
      });
      print('Failed to decode JSON response: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passport Reader'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: _isProcessing
                  ? Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/pass_scan.gif',
                                  package: 'passport_reader'))),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.green
                                    .withOpacity(0.5), // Transparent background
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: CameraPreview(_controller),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
            ),
            if (_capturedImage == null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _takePicture,
                  child: const Text('Capture to scan'),
                ),
              ),
            if (resultText != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(resultText!),
              ),
          ],
        ),
      ),
    );
  }
}
