import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/models/booking_model.dart';
import 'package:heroservices/services/booking_service.dart';

class LocateFeature extends StatefulWidget {
  final BookingModel booking;
  final List<Placemark> startPlacemark;
  final List<Placemark> destinationPlacemark;
  final Map<PolylineId, Polyline> polylines;
  final BitmapDescriptor pinLocationIcon;

  LocateFeature({this.booking, this.startPlacemark, this.destinationPlacemark, this.polylines, this.pinLocationIcon});

  @override
  _LocateFeatureState createState() => _LocateFeatureState();
}

class _LocateFeatureState extends State<LocateFeature> {
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
        title: widget.booking.customerName,
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
        title: widget.booking.heroName,
        snippet: widget.booking.heroAddress,
      ),
      icon: widget.pinLocationIcon,
    );

    // Add the markers to the list
    markers.add(startMarker);
    markers.add(destinationMarker);

    // Define two position variables
    Position _northeastCoordinates;
    Position _southwestCoordinates;

    if (startCoordinates.latitude <= destinationCoordinates.latitude) {
      _southwestCoordinates = startCoordinates;
      _northeastCoordinates = destinationCoordinates;
    } else {
      _southwestCoordinates = destinationCoordinates;
      _northeastCoordinates = startCoordinates;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder(
          stream: BookingService(bookingId: widget.booking.bookingId).locate,
          builder: (context, snapshot) {
            return SizedBox.shrink();
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
          child: Text(widget.booking.serviceOption.toUpperCase(), style: TextStyle(fontSize: 15),),
        ),
        SizedBox(
          height: 330,
          child: GetBuilder<NavigationController>(
            builder: (navCtrl) {
              navCtrl.locate.forEach((key, value) {
                LocateModel _locate = value;
                print(value.lng);
                print('===========================');
                Marker _new = Marker(
                  markerId: MarkerId('$destinationCoordinates'),
                  position: LatLng(
                    double.parse(_locate.lat),
                    double.parse(_locate.lng)
                  ),
                  infoWindow: InfoWindow(
                    title: widget.booking.heroName,
                    snippet: widget.booking.heroAddress,
                  ),
                  icon: widget.pinLocationIcon,
                );
                markers = {};
                markers.add(_new);
              });
              markers.add(startMarker);
              return GoogleMap(
                onMapCreated: (GoogleMapController googleMapController) {
                  setState(()=> mapController = googleMapController);
                },
                initialCameraPosition: CameraPosition(
                    zoom: 16,
                    target: LatLng(
                      _northeastCoordinates.latitude,
                      _northeastCoordinates.longitude,
                    )
                ),
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                //markers: Set<Marker>.of(_markers),
                markers: markers != null ? Set<Marker>.from(markers) : null,
                polylines: Set<Polyline>.of(widget.polylines.values),
              );
            },
          ),
        ),
      ],
    );
  }

}
