import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/controllers/user_controller.dart';
import 'package:heroservices/models/user_model.dart';
import 'package:heroservices/services/user_service.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<FirebaseUser> _firebaseUser = Rx<FirebaseUser>();

  FirebaseUser get user => _firebaseUser.value;


  @override
  // ignore: must_call_super
  onInit() {
    _firebaseUser.bindStream(_auth.onAuthStateChanged);
  }

  void createUser(String fname, String lname, String mobile, String email, String password, String cpassword) async {
    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      //create user in database.dart
      UserModel _user = UserModel(
        id: _authResult.user.uid,
        fname: fname,
        lname: lname,
        mobile: mobile,
        email: _authResult.user.email,
        password: password,
      );
      if (await UserService().createNewUser(_user)) {
        Get.find<UserController>().user = _user;
        Get.back();
      }
    } catch (e) {
      Get.find<NavigationController>().alert('Unable to create account', e.message);
    }
  }

  void login(String email, String password) async {
    try {
      AuthResult _authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      Get.find<UserController>().user =
      await UserService().getUser(_authResult.user.uid);
    } catch (e) {
      Get.find<NavigationController>().alert('Error signing in', e.message);
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      Get.find<UserController>().clear();
    } catch (e) {
      Get.find<NavigationController>().alert('Error signing out', e.message);
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    Get.find<NavigationController>().alert('Request Sent!', 'Check your email inbox for instruction.');
  }
}