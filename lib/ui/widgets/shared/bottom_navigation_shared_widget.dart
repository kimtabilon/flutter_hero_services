import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/auth_controller.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/ui/views/account_view.dart';
import 'package:heroservices/ui/views/booking_view.dart';
import 'package:heroservices/ui/views/service_category_view.dart';

class BottomNavigationSharedWidget extends StatefulWidget {

  @override
  _BottomNavigationSharedWidgetState createState() => _BottomNavigationSharedWidgetState();
}

class _BottomNavigationSharedWidgetState extends State<BottomNavigationSharedWidget> {
  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = true;

  @override
  Widget build(BuildContext context) {
    Get.put<NavigationController>(NavigationController());
    var con = GetConnect();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        !isInternetOn
            ? Container(width:double.infinity, alignment: Alignment.center, color: Colors.red[300], child: Text('You are not Connected to Internet', style: TextStyle(color: Colors.white70),))
            : SizedBox.shrink(),
        GetBuilder<NavigationController>(
          builder: (ctrl) => BottomNavigationBar(
            selectedItemColor: Colors.white,
            currentIndex: ctrl.bottomNavCurrent,
            onTap: (i) {
              ctrl.setBottomNavCurrent(i);
              switch(i) {
                case 0:
                  Get.offAll(BookingView());
                  break;
                case 2:
                  Get.put<AuthController>(AuthController());
                  Get.offAll(AccountView());
                  break;
                default:
                  Get.offAll(ServiceCategoryView());
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.history_toggle_off),
                label: 'BOOKINGS',
                backgroundColor: Colors.white
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.explore),
                label: 'EXPLORE',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.face),
                  label: "ACCOUNT"
              )
            ],
          )
          ,
        ),
      ],
    );
  }

  void GetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {

      iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {

      iswificonnected = true;
      /*setState(() async {
        wifiBSSID = await (Connectivity().getWifiBSSID());
        wifiIP = await (Connectivity().getWifiIP());
        wifiName = await (Connectivity().getWifiName());
      });*/

    }
  }
}
