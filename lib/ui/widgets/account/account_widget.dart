import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/auth_controller.dart';
import 'package:heroservices/controllers/user_controller.dart';
import 'package:heroservices/services/user_service.dart';
import 'package:heroservices/ui/widgets/shared/bottom_navigation_shared_widget.dart';
import 'package:heroservices/ui/widgets/shared/rating_widget.dart';

class AccountWidget extends GetWidget<AuthController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ACCOUNT', style: TextStyle(letterSpacing: 5)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (choice) {
              switch(choice) {
                case 'Logout':
                  controller.signOut();
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationSharedWidget(),
      body: GetX<UserController>(
        initState: (_) async {
          Get.find<UserController>().user =
          await UserService().getUser(controller.user.uid);
        },
        builder: (userCtrl) => SingleChildScrollView(
          child: userCtrl.user.fname!=null ? Container(
            height: 300,
            width: double.infinity,
            color: Color(0xffeeeeee),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage('assets/avatar2.png'),
                    ),
                  ),
                ),
                Center(child: Text(userCtrl.user.fname+' '+userCtrl.user.lname, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                Center(child: Text(userCtrl.user.mobile)),
                Center(child: Text(userCtrl.user.email)),
                SizedBox(height: 5.0,),
                Center(child: RatingWidget()),
                SizedBox(height: 20.0,),
              ],
            ),
          ) : SizedBox(height: 1,),
        ),
      ),
    );
  }
}
