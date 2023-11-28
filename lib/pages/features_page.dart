import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'app_colors.dart';
import 'approvals_page.dart';
import 'overtimelist_page.dart';
import 'attendanceform_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({Key? key}) : super(key: key);

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
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
      return Future.error('Location permissions are permanently denied, we cant request');
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
    geolocator.LocationSettings locationSettings = geolocator.LocationSettings(
        accuracy: geolocator.LocationAccuracy.high, distanceFilter: 1000);

    geolocator.Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((geolocator.Position position) {
      double targetLatitude = -6.520107;
      double targetLongitude = 106.830266;
      double distance = geolocator.Geolocator.distanceBetween(
        position.latitude, position.longitude, targetLatitude, targetLongitude);

      if (distance <= 500) {
        globalLat = position.latitude.toString();
        globalLong = position.longitude.toString();

        setState(() {
          message = 'Latitude $globalLat, Longitude: $globalLong';
        });
      } else {
        setState(() {
          message = 'Outside the allowed area';
          globalLat = '';
          globalLong = '';
          globalLocationName = 'Outside the allowed area';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 70),
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(AppLocalizations(globalLanguage).translate("features"),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/attendancefeature.png',
                  title: AppLocalizations(globalLanguage).translate("attendanceForm"),
                  onTap: () {
                    _getCurrentLocation().then((value) {
                      _liveLocation();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AttendanceFormPage(),
                        ),
                      );
                    });
                  },
                ),
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/overtime.png',
                  title: AppLocalizations(globalLanguage).translate("overtime"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OvertimeListPage()),
                    );
                  },
                ),
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/leave.png',
                  title: AppLocalizations(globalLanguage).translate("leave"),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const LeaveListPage()),
                    // );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/approval.png',
                  title: AppLocalizations(globalLanguage).translate("approvals"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ApprovalsPage()),
                    );
                  },
                ),
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/checkpoint.png',
                  title: AppLocalizations(globalLanguage).translate("checkpoinTour"),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const CheckPointPage()),
                    // );
                  },
                ),
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/ticketing.png',
                  title:
                      AppLocalizations(globalLanguage).translate("ticketing"),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => TicketingPage()),
                    // );
                  },
                ),
              ],
            ),
          ]),
        ))
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  final Color color;
  final String imagePath;
  final String title;
  final double imageWidth;
  final double imageHeight;
  final VoidCallback onTap;

  CardItem({
    required this.color,
    required this.imagePath,
    this.title = '',
    this.imageWidth = 70,
    this.imageHeight = 70,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 0.27 * MediaQuery.of(context).size.width,
            height: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                width: imageWidth,
                height: imageHeight,
                child: Image.asset(imagePath),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.deepGreen,
            ),
          ),
        ],
      ),
    );
  }
}
