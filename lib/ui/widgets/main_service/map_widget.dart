import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/form_controller.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {

  GoogleMapController mapController;
  List<Marker> _markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Text('Search in Google Map',),
        SizedBox(height: 20,),
        SearchMapPlaceWidget(
          darkMode: true,
          hasClearButton: true,
          placeType: PlaceType.address,
          placeholder: 'Enter your Complete Address',
          apiKey: 'AIzaSyCa74d9dW86yh-52LzCy9S0awYbgXuZ79w',
          onSelected: (Place place) async {

            Geolocation geolocation = await place.geolocation;

            print('=============================================');
            print('manual overide');
            List _addr = place.description.split(',');
            int _province = _addr.length-2;
            print(_addr[_province]);
            print('=============================================');
            var addresses = await Geocoder.local.findAddressesFromQuery(place.description);
            var first = addresses.first;
            print(first.addressLine);
            print('locality : '+first.locality); //city
            print('countryName : '+(first.countryName!=null?first.countryName:'null'));
            print('postalCode : '+(first.postalCode!=null?first.postalCode:'null'));
            print('subLocality : '+(first.subLocality!=null?first.subLocality:'null'));
            print('featureName : '+(first.featureName!=null?first.featureName:'null'));
            print('thoroughfare : '+(first.thoroughfare!=null?first.thoroughfare:'null'));
            print('subThoroughfare : '+(first.subThoroughfare!=null?first.subThoroughfare:'null'));
            print('=============================================');

            Get.find<FormController>().addDefaultFieldValue('Customer Address', place.description);
            Get.find<FormController>().addDefaultFieldValue('Customer City', first.locality);
            Get.find<FormController>().addDefaultFieldValue('Customer Province', _addr[_province]);

            setState((){
              _markers.clear();
              _markers.add(
                  Marker(
                      markerId: MarkerId(place.placeId),
                      position: geolocation.coordinates,
                      infoWindow: InfoWindow(
                          title: place.description
                      )
                  )
              );
            });
            mapController.animateCamera(
              CameraUpdate.newLatLng(geolocation.coordinates)
            );
            mapController.animateCamera(
              CameraUpdate.newLatLngBounds(geolocation.bounds, 0)
            );

          },
        ),
        SizedBox(height: 15,),
        SizedBox(
          height: 300,
          child: GoogleMap(
            onMapCreated: (GoogleMapController googleMapController) {

              setState(()=> mapController = googleMapController);

            },
            initialCameraPosition: CameraPosition(
              zoom: 12,
              target: LatLng(14.5995, 120.9842)
            ),
            mapType: MapType.normal,
            markers: Set<Marker>.of(_markers),
          ),
        )
      ],
    );
  }
}
