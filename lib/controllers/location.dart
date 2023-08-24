import 'package:location/location.dart' as l;

class Location {
  late double lat;
  late double long;

  Future<void> getCurrentLocation() async {
    try {
      l.LocationData position = await _getLocation();
      lat = position.latitude ?? 0;
      long = position.longitude ?? 0;
    } catch (e) {
      print(e);
    }
  }

  Future<l.LocationData> _getLocation() async {
    bool serviceEnabled;
    l.PermissionStatus permission;

    l.Location location = l.Location();
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      bool isturnedon = await l.Location().requestService();

      if (!isturnedon) {
        throw const LocationServiceException();
      }
    }

    permission = await location.hasPermission();
    if (permission == l.PermissionStatus.denied ||
        permission == l.PermissionStatus.deniedForever) {
      permission = await location.requestPermission();
      if (permission == l.PermissionStatus.denied ||
          permission == l.PermissionStatus.deniedForever) {
        throw const LocationPermissionsException();
      }
    }

    // if (permission == l.PermissionStatus.deniedForever) {
    //   throw const LocationDeniedForeverException();
    // }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    print(await location.getLocation());
    return await location.getLocation();
  }
}

class LocationServiceException implements Exception {
  static const String message = 'LocationServiceException';
  const LocationServiceException() : super();
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}

class LocationPermissionsException implements Exception {
  static const String message = 'LocationPermissionsException';
  const LocationPermissionsException() : super();
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}

class LocationDeniedForeverException implements Exception {
  static const String message = 'LocationDeniedForeverException';
  const LocationDeniedForeverException() : super();
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}
