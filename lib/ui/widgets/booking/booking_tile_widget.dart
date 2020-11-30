import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/models/booking_model.dart';
import 'package:heroservices/services/booking_service.dart';
import 'package:heroservices/ui/features/chat_feature.dart';
import 'package:heroservices/ui/features/locate_feature.dart';
import 'package:heroservices/ui/widgets/booking/view_booking_widget.dart';
import 'package:heroservices/ui/widgets/shared/rating_widget.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';
import 'package:intl/intl.dart';
import 'package:load/load.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;

class BookingTileWidget extends StatelessWidget {
  final BookingModel booking;

  BookingTileWidget({this.booking});

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    switch(booking.queue) {
      case 'for_quotation':
        return ExpansionTile(
          title: Text(booking.serviceOption),
          subtitle: Text(booking.queue.replaceAll('_', ' ').toUpperCase() + ' • ' + DateFormat('yyyy.MM.dd | HH:mm a').format(DateTime.parse(booking.schedule)).toString()),
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey[100],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  StreamBuilder(
                    stream: BookingService(bookingId: booking.bookingId).bookingQuotes,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text('Error: ${snapshot.error}')),
                        );
                      }
                      switch(snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return SpinkitSharedWidget(type: 'ThreeBounce',);
                        default:
                          if (snapshot.data.length == 0) {
                            //hideLoadingDialog();
                            return Center(child: Text('No response from heroes'));
                          }
                          //hideLoadingDialog();
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.hasData ? snapshot.data.length : 0,
                            itemBuilder: (context, i) {
                              QuoteModel quote = snapshot.data[i];
                              Map bookingGroups = Get.find<NavigationController>().bookingGroups;
                              Map _bookings = bookingGroups[booking.groupId]['bookings'];

                              for(var h=0; h<_bookings.length; h++) {
                                BookingModel b = _bookings[h];
                                if(b.heroId == quote.heroId && b.queue!='for_quotation') {
                                  return ListTile(
                                    title: Text(quote.heroName),
                                    subtitle: Text(b.queue.replaceAll('_', ' ').toUpperCase()),
                                    trailing: Text((booking.openPrice ? quote.rate : booking.total)+'.00 PHP'),
                                    leading: ovalButton(b.queue, b, null),
                                  );
                                }
                              }
                              return ListTile(
                                title: Text(quote.heroName),
                                subtitle: RatingWidget(),
                                trailing: Text((booking.openPrice ? quote.rate : booking.total)+'.00 PHP'),
                                leading: ovalButton('for_quotation', null, quote),
                              );
                            },
                          );
                      }
                    },
                  ),
                  SizedBox(height: 20,),
                  actionButtons(context),
                  SizedBox(height: 20,),
                ],
              ),
            ),

          ],
        );
        break;
      default:
        Map bookingGroups = Get.find<NavigationController>().bookingGroups;
        Map _bookings = bookingGroups[booking.groupId]['bookings'];
        int groupHasQuote = 0;
        for(var i=0; i<_bookings.length; i++) {
          BookingModel bb = _bookings[i];
          if(bb.queue=='for_quotation') {
            groupHasQuote++;
          }
        }
        if(bookingGroups[booking.groupId]['bookingId'] == booking.bookingId && groupHasQuote==0) {
          if(bookingGroups[booking.groupId]['count']>1) {
            return ExpansionTile(
              title: Text(booking.serviceOption),
              subtitle: Text(DateFormat('yyyy.MM.dd | HH:mm a').format(DateTime.parse(booking.schedule)).toString()),
              trailing: Text(bookingGroups[booking.groupId]['total'].toString()+'.00 PHP'),
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  ),
                ),

                Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _bookings.length,
                        itemBuilder: (context, index) {
                          BookingModel b = _bookings[index];

                          return ListTile(
                            title: Text(b.heroName),
                            subtitle: Text(b.queue.replaceAll('_', ' ').toUpperCase()),
                            trailing: Text((int.parse(b.heroRate) * int.parse(booking.timeline)).toString()+'.00 PHP'),
                            leading: ovalButton(b.queue, b, null),
                          );
                        },
                      ),
                      actionButtons(context),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ],
            );
          }
          return ExpansionTile(
            title: Text(booking.serviceOption),
            subtitle: Text(booking.queue.replaceAll('_', ' ').toUpperCase() + ' • ' + DateFormat('yyyy.MM.dd | HH:mm a').format(DateTime.parse(booking.schedule)).toString()),
            trailing: Text(booking.total+'.00 PHP'),
            children: [
              Container(
                width: double.infinity,
                color: Colors.grey[100],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20,),
                    actionButtons(context),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ],
          );
        }
        return SizedBox.shrink();
        break;
    }
  }

  Widget ovalButton(String queue, BookingModel _booking, QuoteModel quote) {
    switch(queue) {
      case 'for_confirmation':
        return ClipOval(
          child: Material(
            color: Colors.red[300], // button color
            child: InkWell(
              splashColor: Color(0xff93CA68), // inkwell color
              child: SizedBox(width: 30, height: 30, child: Icon(Icons.close, color: Colors.white,)),
              onLongPress: () {
                BookingService().changeQueue(_booking.bookingId, 'cancelled');
              },
              onTap: () {
                Get.find<NavigationController>().alert('Confirm your action', 'Long press to cancel this Hero.');
              },
            ),
          ),
        );
        break;
      case 'active':
        GlobalKey _key = GlobalKey();
        return ClipOval(
          child: Material(
            color: Colors.grey[800], // button color
            child: InkWell(
              splashColor: Color(0xff93CA68), // inkwell color
              child: SizedBox(width: 30, height: 30, child: Icon(Icons.more_horiz, color: Colors.white, size: 20,)),
              onLongPress: () {
                //BookingService().changeQueue(bookingId, 'cancelled');
              },
              onTap: () {
                popupMenu(_key, _booking);
              },
              key: _key,
              /*onTap: () {
                Get.to(ChatView(booking: _booking,));
                //Get.find<NavigationController>().alert('Message', 'Chat feature is not yet available.');
              },*/
            ),
          ),
        );
        break;
      case 'for_quotation':
        return ClipOval(
          child: Material(
            color: Colors.grey[400], // button color
            child: InkWell(
              splashColor: Color(0xff93CA68), // inkwell color
              child: SizedBox(width: 30, height: 30, child: Icon(Icons.add, color: Colors.white,)),
              onLongPress: () {
                if(booking.multipleBooking) {
                  BookingService().bookService(
                      booking.groupId,
                      booking.serviceOptionId,
                      booking.serviceOption,
                      booking.multipleBooking,
                      booking.openPrice,

                      quote.heroId,
                      quote.heroName,
                      quote.heroNumber,
                      quote.heroAddress,
                      quote.rate,

                      booking.customerId,
                      booking.customerName,
                      booking.customerAddress,
                      booking.schedule,
                      booking.timelineType,
                      booking.timeline,
                      booking.formValues,
                      booking.promoCode,
                      booking.promoAmount,
                      booking.openPrice ? quote.rate : booking.total,
                      booking.tax,
                      'for_confirmation'
                  );
                } else {
                  BookingService().addHero(
                      booking.bookingId,
                      quote.heroId,
                      quote.heroName,
                      quote.heroAddress,
                      quote.rate,
                      booking.openPrice ? quote.rate : booking.total,
                  );
                }
              },
              onTap: () {
                Get.find<NavigationController>().alert('Confirm your action', 'Long press to select a quote.');
              },
            ),
          ),
        );
        break;
      default:
        return null;
        break;
    }
  }

  Widget actionButtons(context) {
    Map bookingGroups = Get.find<NavigationController>().bookingGroups;
    Map _bookingsInGroup = bookingGroups[booking.groupId]['bookings'];

    switch(booking.queue) {
      case 'for_quotation':
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlineButton(
              onLongPress: () {
                BookingService().changeQueue(booking.bookingId, 'closed');
              },
              onPressed: (){
                Get.find<NavigationController>().alert('Confirm your action', 'Long press to close quotation.');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('CLOSE QUOTATION',style: TextStyle(color: Colors.grey[800]),),
              ),
            ),
            viewDetailsButton(context),
          ],
        );
        break;

      case 'for_confirmation':
        if(_bookingsInGroup.length==1) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlineButton(
                onLongPress: () {
                  BookingService().changeQueue(booking.bookingId, 'cancelled');
                },
                onPressed: (){
                  Get.find<NavigationController>().alert('Confirm your action', 'Long press to cancel booking.');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('CANCEL BOOKING',style: TextStyle(color: Colors.grey[800]),),
                ),
              ),
              viewDetailsButton(context),
            ],
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            viewDetailsButton(context),
          ],
        );
        break;

      case 'active':
        if(_bookingsInGroup.length==1) {
          GlobalKey _key = GlobalKey();
          BookingModel _booking = _bookingsInGroup[0];

          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.black54,
                key: _key,
                onPressed: (){
                  popupMenu(_key, _booking);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('MORE OPTIONS',style: TextStyle(color: Colors.white),),
                ),
              ),
              viewDetailsButton(context),
            ],
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            viewDetailsButton(context),
          ],
        );
        break;

      default:
        return Text('Something went wrong, booking status not set.');
        break;
    }
  }

  Widget viewDetailsButton(context) {
    return MaterialButton(
      color: Colors.blue,
      elevation: 0,
      onPressed: (){
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                    width: double.maxFinite,
                    child: ViewBookingWidget(booking: booking,)
                ),
              );
            }
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('VIEW DETAILS',style: TextStyle(color: Colors.white),),
      ),
    );
  }

  popupMenu(_key, _booking) {
    PopupMenu menu = PopupMenu(
      // backgroundColor: Colors.teal,
      // lineColor: Colors.tealAccent,
      // maxColumn: 2,
        items: [
          MenuItem(
              title: 'Chat',
              // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
              image: Icon(
                Icons.chat,
                color: Colors.white,
              )),
          /*MenuItem(
              title: 'Call',
              image: Icon(
                Icons.call,
                color: Colors.white,
              )),*/
          MenuItem(
              title: 'Locate',
              image: Icon(
                Icons.edit_location,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Help',
              image: Icon(
                Icons.help,
                color: Colors.white,
              )),

        ],
        onClickMenu: (MenuItemProvider item) async {
          switch(item.menuTitle) {
            case 'Chat':
              Get.to(ChatFeature(booking: _booking, isAdmin: false,));
              break;
            case 'Help':
              Get.to(ChatFeature(booking: _booking, isAdmin: true,));
              break;
            case 'Locate':
              if(!kIsWeb) {
                showLoadingDialog();
                Geolocator _geolocator = Geolocator();
                List<Placemark> startPlacemark = await _geolocator
                    .placemarkFromAddress(_booking.customerAddress);
                List<Placemark> destinationPlacemark = await _geolocator
                    .placemarkFromAddress(_booking.heroAddress);

                /*START PolylinePoints*/
                PolylinePoints polylinePoints;
                List<LatLng> polylineCoordinates = [];
                Map<PolylineId, Polyline> polylines = {};
                Position startCoordinates = startPlacemark[0].position;
                Position destinationCoordinates = destinationPlacemark[0]
                    .position;

                polylinePoints = PolylinePoints();

                PolylineResult result = await polylinePoints
                    .getRouteBetweenCoordinates(
                  'AIzaSyCa74d9dW86yh-52LzCy9S0awYbgXuZ79w',
                  // Google Maps API Key
                  PointLatLng(
                      startCoordinates.latitude, startCoordinates.longitude),
                  PointLatLng(destinationCoordinates.latitude,
                      destinationCoordinates.longitude),
                  travelMode: TravelMode.transit,
                );

                if (result.points.isNotEmpty) {
                  result.points.forEach((PointLatLng point) {
                    polylineCoordinates.add(
                        LatLng(point.latitude, point.longitude));
                  });
                }

                PolylineId id = PolylineId('poly');

                Polyline polyline = Polyline(
                  polylineId: id,
                  color: Colors.red,
                  points: polylineCoordinates,
                  width: 3,
                );

                polylines[id] = polyline;
                /*END PolylinePoints*/

                Future<Uint8List> getBytesFromAsset(String path,
                    int width) async {
                  ByteData data = await rootBundle.load(path);
                  ui.Codec codec = await ui.instantiateImageCodec(
                      data.buffer.asUint8List(), targetWidth: width);
                  ui.FrameInfo fi = await codec.getNextFrame();
                  return (await fi.image.toByteData(
                      format: ui.ImageByteFormat.png)).buffer.asUint8List();
                }

                Uint8List markerIcon = await getBytesFromAsset(
                    'assets/hero-marker.png', 80);

                Get.bottomSheet(
                    BottomSheet(
                        enableDrag: true,
                        onClosing: () {},
                        builder: (context) {
                          return Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.75,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(25.0),
                                  topRight: const Radius.circular(25.0),
                                ),
                              ),
                              child: LocateFeature(
                                booking: _booking,
                                startPlacemark: startPlacemark,
                                destinationPlacemark: destinationPlacemark,
                                polylines: polylines,
                                pinLocationIcon: BitmapDescriptor.fromBytes(
                                    markerIcon),
                              )
                          );
                        }
                    )
                );
                hideLoadingDialog();
              } else {
                Get.find<NavigationController>().alert('Not Supported.', 'You are using browser platform.');
              }
              break;
            case 'Call':
              launch(('tel://${_booking.heroNumber}'));
              break;
          }
          print('Click menu -> ${item.menuTitle}');
        },
        stateChanged: (bool isShow) {},
        onDismiss: (){});

    menu.show(widgetKey: _key);
  }
}
