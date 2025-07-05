import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationPicker extends StatefulWidget {
  final ValueChanged<LocationData>? onChange;
  const LocationPicker({
    super.key,
    this.onChange,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late StreamSubscription<LocationData> _locationSubscription;
  
  late GoogleMapController _googleMapController;
  final Location _location = Location();
  
  void _onMapCreated(GoogleMapController ctrl)
  {
    _googleMapController = ctrl;
    _locationSubscription = _location.onLocationChanged.listen((l) { 
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(l.latitude!, l.longitude!),
            zoom: 15
          ),
        ),
      );
      if(widget.onChange != null) {
        widget.onChange!(l);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(6.1750, 106.8283),
        zoom: 2
      ),
      zoomControlsEnabled: false,
      zoomGesturesEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _locationSubscription.cancel();
    _googleMapController.dispose();
  }
}