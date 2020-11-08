import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroservices/controllers/bindings/auth_binding.dart';
import 'package:heroservices/ui/views/service_category_view.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Get.find<NavigationController>().alert('Message', 'Lorem Ipsum');
    return LoadingProvider(
      themeData: LoadingThemeData(
        loadingBackgroundColor: Colors.transparent,
      ),
      loadingWidgetBuilder: (ctx, data) {
        return Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: ClipOval(
              child: Container(
                child: SpinKitDoubleBounce(
                  color: Color(0xff93CA68),
                  size: 50.0,
                ),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
      child: GetMaterialApp(
        initialBinding: AuthBinding(),
        title: 'Hero Services',
        theme: ThemeData(
          cardTheme: CardTheme(
            margin: EdgeInsets.all(5.0),
          ),
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(color: Color(0xff13869F)),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Color(0xff93CA68)),
          floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color(0xff13869F)),
        ),
        debugShowCheckedModeBanner: false,
        home: ServiceCategoryView(),
        //home: ChatView(),
      ),
    );
  }
}
