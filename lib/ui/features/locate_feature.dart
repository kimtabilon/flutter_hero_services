import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heroservices/models/booking_model.dart';

class LocateFeature extends StatefulWidget {
  final BookingModel booking;
  final List<Placemark> startPlacemark;
  final List<Placemark> destinationPlacemark;

  LocateFeature({this.booking, this.startPlacemark, this.destinationPlacemark});

  @override
  _LocateFeatureState createState() => _LocateFeatureState();
}

class _LocateFeatureState extends State<LocateFeature> {
  Geolocator _geolocator = Geolocator();
  Set<Marker> markers = {};
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    Position startCoordinates = widget.startPlacemark[0].position;
    Position destinationCoordinates = widget.destinationPlacemark[0].position;

    Marker startMarker = Marker(
      markerId: MarkerId('$startCoordinates'),
      position: LatLng(
        startCoordinates.latitude,
        startCoordinates.longitude,
      ),
      infoWindow: InfoWindow(
        title: 'Start',
        snippet: widget.booking.customerAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    // Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId('$destinationCoordinates'),
      position: LatLng(
        destinationCoordinates.latitude,
        destinationCoordinates.longitude,
      ),
      infoWindow: InfoWindow(
        title: 'Destination',
        snippet: widget.booking.heroAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    // Add the markers to the list
    markers.add(startMarker);
    markers.add(destinationMarker);

    // Define two position variables
    Position _northeastCoordinates;
    Position _southwestCoordinates;

// Calculating to check that
// southwest coordinate <= northeast coordinate
    if (startCoordinates.latitude <= destinationCoordinates.latitude) {
      _southwestCoordinates = startCoordinates;
      _northeastCoordinates = destinationCoordinates;
    } else {
      _southwestCoordinates = destinationCoordinates;
      _northeastCoordinates = startCoordinates;
    }

// Accommodate the two locations within the
// camera view of the map
    /*mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(
            _northeastCoordinates.latitude,
            _northeastCoordinates.longitude,
          ),
          southwest: LatLng(
            _southwestCoordinates.latitude,
            _southwestCoordinates.longitude,
          ),
        ),
        100.0, // padding
      ),
    );*/

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
          child: Text(widget.booking.serviceOption.toUpperCase(), style: TextStyle(fontSize: 15),),
        ),
        SizedBox(
          height: 330,
          child: GoogleMap(
            onMapCreated: (GoogleMapController googleMapController) {
              setState(()=> mapController = googleMapController);
            },
            initialCameraPosition: CameraPosition(
                zoom: 14,
                target: LatLng(
                  _northeastCoordinates.latitude,
                  _northeastCoordinates.longitude,
                )
            ),
            mapType: MapType.normal,
            //markers: Set<Marker>.of(_markers),
            markers: markers != null ? Set<Marker>.from(markers) : null,
          ),
        ),
      ],
    );
  }
}
