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
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'app_colors.dart';
import 'refresh_page.dart';
import 'home_page.dart';
import '../ml/detector.dart';
import '../ml/utils.dart';
import '../ml/model.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';
import '../utils/session_manager.dart';
import '../controllers/facerecognition_controller.dart';

class FaceRecognitionPage extends StatefulWidget {
  const FaceRecognitionPage({Key? key}) : super(key: key);

  @override
  State<FaceRecognitionPage> createState() => _FaceRecognitionPageState();
}

class _FaceRecognitionPageState extends State<FaceRecognitionPage>
    with WidgetsBindingObserver {
  String username = '';
  late FaceRecognitionController controller;

  @override
  void initState() {
    super.initState();
    username = SessionManager().getNamaUser() ?? '';
    controller = FaceRecognitionController();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _start();
  }

  void _start() async {
    interpreter = await loadModel();
    initialCamera();
  }

  void getDataFace() async {
    try {
      List<FaceRecognitionData> faceRecognitionList =
          await controller.getFaceRecognition();
      bool matchFound = false;
      String matchingUsername = "";

      for (FaceRecognitionData data in faceRecognitionList) {
        List storedEmbeddings = json.decode(data.kodeFace);
        double distance = euclideanDistance(storedEmbeddings, e1!);

        if (distance < threshold) {
          matchFound = true;
          matchingUsername = data.userName;
          break;
        }
      }

      if (matchFound && mounted) {
        setState(() {
          globalFaceDetection = matchingUsername;
        });

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: AppLocalizations(globalLanguage).translate("recognized"),
            message:
                '${AppLocalizations(globalLanguage).translate("youAre")} $matchingUsername',
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RefreshAttendance(),
            ),
          );
        }

        await _camera!.stopImageStream();

        setState(() {
          globalFaceDetection = 'Not Recognized';
        });
      } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: AppLocalizations(globalLanguage).translate("notRecognized"),
            message: AppLocalizations(globalLanguage).translate("noFaceFound"),
            contentType: ContentType.warning,
          ),
        );

        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
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
  Directory? tempDir;
  bool faceFound = false;
  bool _verify = false;
  List? e1;
  bool loading = true;

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
    String embPath = '${tempDir!.path}/emb.json';
    jsonFile = File(embPath);
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
            faceFound = false;
            _predRes =
                AppLocalizations(globalLanguage).translate("notRecognized");
          } else {
            faceFound = true;
          }

          String res;
          Face face;

          imglib.Image convertedImage =
              convertCameraImage(image, CameraLensDirection.front);

          for (face in result) {
            double x, y, w, h;
            x = (face.boundingBox.left - 10);
            y = (face.boundingBox.top - 10);
            w = (face.boundingBox.width + 10);
            h = (face.boundingBox.height + 10);
            imglib.Image croppedImage = imglib.copyCrop(
                convertedImage, x.round(), y.round(), w.round(), h.round());
            croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
            res = recog(croppedImage);
            finalResult.add(res, face);
          }

          _scanResults = finalResult;
          _isDetecting = false;
          setState(() {});
        }).catchError(
          (_) async {
            debugPrint('error: $_');
            _isDetecting = false;
            if (_camera != null) {
              await _camera!.stopImageStream();
              await Future.delayed(const Duration(milliseconds: 400));
              await _camera!.dispose();
              await Future.delayed(const Duration(milliseconds: 400));
              _camera = null;
            }

            if (mounted) {
              Navigator.pop(context);
            }
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (bool _) async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          return Future.sync(() => false);
        },
        child: Scaffold(
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
                    Text(
                        AppLocalizations(globalLanguage)
                            .translate("faceRecognition"),
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                        setState(() {
                          globalFaceDetection = 'Not Recognized';
                        });
                        await _camera!.stopImageStream();
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Colors.white, AppColors.lightGreen],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        getDataFace();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 30),
                        child: Text(
                          AppLocalizations(globalLanguage).translate("detect"),
                          style: const TextStyle(
                            color: AppColors.deepGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildResults() {
    Center noResultsText = Center(
        child: Text(
            '${AppLocalizations(globalLanguage).translate("pleaseWait")}...',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: AppColors.deepGreen)));
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
