import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/collection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'app_colors.dart';
import 'attendanceform_page.dart';
import '../modules/detector.dart';
import '../modules/utils.dart';
import '../modules/model.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';

class FaceRecognitionPage extends StatefulWidget {
  const FaceRecognitionPage({Key? key}) : super(key: key);

  @override
  State<FaceRecognitionPage> createState() => _FaceRecognitionPageState();
}

class _FaceRecognitionPageState extends State<FaceRecognitionPage> with WidgetsBindingObserver {
  // FACE DETECTION
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _start();
  }

  void _start() async {
    interpreter = await loadModel();
    initialCamera();
  }

  @override
  void dispose() async {
    WidgetsBinding.instance!.removeObserver(this);
    if (_camera != null) {
      await _camera!.stopImageStream();
      await Future.delayed(const Duration(milliseconds: 200));
      await _camera!.dispose();
      _camera = null;
    }
    super.dispose();
  }

  late File jsonFile;
  var interpreter;
  CameraController? _camera;
  dynamic data = {};
  bool _isDetecting = false;
  double threshold = 1.0;
  dynamic _scanResults;
  String _predRes = '';
  bool isStream = true;
  CameraImage? _cameraimage;
  Directory? tempDir;
  bool _faceFound = false;
  bool _verify = false;
  List? e1;
  bool loading = true;
  final TextEditingController _name = TextEditingController(text: '');

  void initialCamera() async {
    CameraDescription description = await getCamera(CameraLensDirection.front);
    _camera = CameraController(
      description,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await _camera!.initialize();
    await Future.delayed(const Duration(milliseconds: 500));
    loading = false;
    tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir!.path + '/emb.json';
    jsonFile = File(_embPath);
    if (jsonFile.existsSync()) {
      data = json.decode(jsonFile.readAsStringSync());
    }

    await Future.delayed(const Duration(milliseconds: 500));

    _camera!.startImageStream((CameraImage image) async {
      if (_camera != null) {
        if (_isDetecting) return;
        _isDetecting = true;
        dynamic finalResult = Multimap<String, Face>();

        detect(image, getDetectionMethod()).then((dynamic result) async {
          if (result.length == 0 || result == null) {
            _faceFound = false;
            _predRes = AppLocalizations(globalLanguage).translate("notRecognized");
          } else {
            _faceFound = true;
          }

          String res;
          Face _face;

          imglib.Image convertedImage = convertCameraImage(image, CameraLensDirection.front);

          for (_face in result) {
            double x, y, w, h;
            x = (_face.boundingBox.left - 10);
            y = (_face.boundingBox.top - 10);
            w = (_face.boundingBox.width + 10);
            h = (_face.boundingBox.height + 10);
            imglib.Image croppedImage = imglib.copyCrop(convertedImage, x.round(), y.round(), w.round(), h.round());
            croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
            res = recog(croppedImage);
            finalResult.add(res, _face);
          }

          _scanResults = finalResult;
          _isDetecting = false;
          setState(() {});
        }).catchError(
          (_) async {
            print({'error': _.toString()});
            _isDetecting = false;
            if (_camera != null) {
              await _camera!.stopImageStream();
              await Future.delayed(const Duration(milliseconds: 400));
              await _camera!.dispose();
              await Future.delayed(const Duration(milliseconds: 400));
              _camera = null;
            }
            Navigator.pop(context);
          },
        );
      }
    });
  }

  String recog(imglib.Image img) {
    List input = imageToByteListFloat32(img, 112, 128, 128);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.filled(1 * 192, null, growable: false).reshape([1, 192]);
    interpreter.run(input, output);
    output = output.reshape([192]);
    e1 = List.from(output);
    return compare(e1!).toUpperCase();
  }

  String compare(List currEmb) {
    double minDist = 999;
    double currDist = 0.0;
    _predRes = AppLocalizations(globalLanguage).translate("notRecognized");
    for (String label in data.keys) {
      currDist = euclideanDistance(data[label], currEmb);
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        _predRes = label;
        if (_verify == false) {
          _verify = true;
        }
      }
    }
    return _predRes;
  }

  // LOCATION DETECT
  String message = 'Location';

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    geolocator.LocationPermission permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cant request');
    }

    final position = await geolocator.Geolocator.getCurrentPosition();
    globalLat = position.latitude.toString();
    globalLong = position.longitude.toString();
    await getLocationName();

    setState(() {
      message = 'Latitude $globalLat, Longitude: $globalLong';
    });

    return await geolocator.Geolocator.getCurrentPosition();
  }

  Future<String> getLocationName() async {
    double latitude = double.parse(globalLat);
    double longitude = double.parse(globalLong);

    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String locationName = placemark.name ?? "";
      String thoroughfare = placemark.thoroughfare ?? "";
      String subLocality = placemark.subLocality ?? "";
      String locality = placemark.locality ?? "";
      String administrativeArea = placemark.administrativeArea ?? "";
      String country = placemark.country ?? "";
      String postalCode = placemark.postalCode ?? "";

      String address = "$locationName $thoroughfare $subLocality $locality $administrativeArea $country $postalCode";

      globalLocationName = address;
      return address;
    } else {
      globalLocationName = "Location not found";
      return "Location not found";
    }
  }

  void _liveLocation() {
    geolocator.LocationSettings locationSettings = geolocator.LocationSettings(accuracy: geolocator.LocationAccuracy.high, distanceFilter: 1000);

    geolocator.Geolocator.getPositionStream(locationSettings: locationSettings).listen((geolocator.Position position) {
      globalLat = position.latitude.toString();
      globalLong = position.longitude.toString();

      setState(() {
        message = 'Latitude $globalLat, Longitude: $globalLong';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: Builder(builder: (context) {
              if ((_camera == null || !_camera!.value.isInitialized) ||
                  loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return _camera == null
                  ? const Center(child: SizedBox())
                  : Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        CameraPreview(_camera!),
                        _buildResults(),
                        Positioned(
                          bottom: 20,
                          child: RawMaterialButton(
                            onPressed: () {
                              _getCurrentLocation().then((value) {
                                globalLat = '${value.latitude}';
                                globalLong = '${value.longitude}';
                                getLocationName();
                                setState(() {
                                  message =
                                      'Latitude $globalLat, Longitude: $globalLong';
                                });
                                _liveLocation();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AttendanceFormPage(),
                                  ),
                                );
                              });
                            },
                            shape: const CircleBorder(
                              side: BorderSide(color: Colors.white, width: 2.0),
                            ),
                            elevation: 2.0,
                            fillColor: Colors.transparent,
                            padding: const EdgeInsets.all(1),
                            child: const Icon(
                              Icons.circle,
                              color: AppColors.mainGreen,
                              size: 60,
                            ),
                          ),
                        ),
                      ],
                    );
            }),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.cameraswitch, color: Colors.white),
                  onPressed: () {
                    // Camera switch
                  },
                ),
                Text(AppLocalizations(globalLanguage).translate("faceRecognition"),
                    style: const TextStyle(fontSize: 24, color: Colors.white)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  children: [
                    TextField(
                      controller: _name,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_name.text.isNotEmpty) {
                          Navigator.pop(context);
                          await Future.delayed(const Duration(milliseconds: 400));
                          data[_name.text] = e1;
                          jsonFile.writeAsStringSync(json.encode(data));

                          if (_camera != null) {
                            await _camera!.stopImageStream();
                            await Future.delayed(const Duration(milliseconds: 400));
                            await _camera!.dispose();
                            await Future.delayed(const Duration(milliseconds: 400));
                            _camera = null;
                          }

                          initialCamera();
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          print("Name cannot be empty!");
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: AppLocalizations(globalLanguage).translate("nameFailed"),
                              message: AppLocalizations(globalLanguage).translate("nameFailedMessage"),
                              contentType: ContentType.failure,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        }
                      },
                      child: Text(AppLocalizations(globalLanguage).translate("save")),
                    )
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildResults() {
    Center noResultsText = const Center(
        child: Text('Please wait...',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white)));
    if (_scanResults == null ||
        _camera == null ||
        !_camera!.value.isInitialized) {
      return noResultsText;
    }
    CustomPainter painter;

    final Size imageSize = Size(
      _camera!.value.previewSize!.height,
      _camera!.value.previewSize!.width,
    );
    painter = FaceDetectorPainter(imageSize, _scanResults);
    return CustomPaint(
      painter: painter,
    );
  }
}
