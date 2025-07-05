import 'dart:io';

import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

requestLocationPermission() async {
  var location = Location();

  var serviceEnabled = await location.serviceEnabled();
  if(!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if(!serviceEnabled) {
      exit(1);
    }
  }

  var locationPermission = Permission.location;
  if(await locationPermission.status.isDenied) {
    if(await locationPermission.request().isDenied) {
      exit(1);
    }
  }
}

requestCameraPermission() async {
  var camera = Permission.camera;
  if(await camera.status.isDenied) {
    var requestCamera = await camera.request();
    if(requestCamera.isDenied) {
      exit(1);
    }
  }
}

requestStoragePermission() async {
  var storage = Permission.storage;
  if(await storage.status.isDenied) {
    var requestStorage = await storage.request();
    if(requestStorage.isDenied) {
      exit(1);
    }
  }
}
