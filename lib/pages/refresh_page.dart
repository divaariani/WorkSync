import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'app_colors.dart';
import 'attendanceform_page.dart';
import 'attendance_page.dart';
import 'stockopname_page.dart';
import 'warehouse_page.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';

class RefreshAttendance extends StatefulWidget {
  const RefreshAttendance({Key? key}) : super(key: key);

  @override
  State<RefreshAttendance> createState() => _RefreshAttendanceState();
}

class _RefreshAttendanceState extends State<RefreshAttendance> {
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
    geolocator.LocationSettings locationSettings = 
      const geolocator.LocationSettings(accuracy: geolocator.LocationAccuracy.high, distanceFilter: 1000);

    geolocator.Geolocator.getPositionStream(locationSettings: locationSettings).listen((geolocator.Position position) {
      double targetLatitude1 = -6.520107;
      double targetLongitude1 = 106.830266;
      double area1a10003000 = geolocator.Geolocator.distanceBetween(position.latitude, position.longitude, targetLatitude1, targetLongitude1);

      double targetLatitude2 = -6.520100;
      double targetLongitude2 = 106.831998;
      double finishedwarehouse = geolocator.Geolocator.distanceBetween(position.latitude, position.longitude, targetLatitude2, targetLongitude2);

      if (area1a10003000 <= 50 || finishedwarehouse <= 50) {
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
          globalLocationName = AppLocalizations(globalLanguage).translate("outsideArea");
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      _getCurrentLocation().then((value) {
        _liveLocation();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AttendanceFormPage(),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.deepGreen, AppColors.lightGreen], 
          ),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Lottie.asset('assets/loading.json'),
          ),
        ),
      ),
    );
  }
}

class RefreshAttendanceList extends StatefulWidget {
  const RefreshAttendanceList({Key? key}) : super(key: key);

  @override
  State<RefreshAttendanceList> createState() => _RefreshAttendanceListState();
}

class _RefreshAttendanceListState extends State<RefreshAttendanceList> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AttendancePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.deepGreen, AppColors.lightGreen], 
          ),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Lottie.asset('assets/loading.json'),
          ),
        ),
      ),
    );
  }
}

class RefreshStockTable extends StatefulWidget {
  const RefreshStockTable({Key? key}) : super(key: key);

  @override
  State<RefreshStockTable> createState() => _RefreshStockTableState();
}

class _RefreshStockTableState extends State<RefreshStockTable> {
  
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const StockOpnamePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.deepGreen, AppColors.lightGreen], 
          ),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Lottie.asset('assets/loading.json'),
          ),
        ),
      ),
    );
  }
}

class RefreshWarehouseTable extends StatefulWidget {
  const RefreshWarehouseTable({Key? key}) : super(key: key);

  @override
  State<RefreshWarehouseTable> createState() => _RefreshWarehouseTableState();
}

class _RefreshWarehouseTableState extends State<RefreshWarehouseTable> {
  
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const WarehousePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.deepGreen, AppColors.lightGreen], 
          ),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Lottie.asset('assets/loading.json'),
          ),
        ),
      ),
    );
  }
}