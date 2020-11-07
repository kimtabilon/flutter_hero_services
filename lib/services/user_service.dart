import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/models/user_model.dart';

class UserService {
  final Firestore _firestore = Firestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("customer").document(user.id).setData({
        "fname": user.fname,
        "lname": user.lname,
        "mobile": user.mobile,
        "email": user.email,
        "password": user.password,
      });
      return true;
    } catch (e) {
      Get.find<NavigationController>().alert('Unable to save user data', e.message);
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot _doc =
      await _firestore.collection("customer").document(uid).get();
      return UserModel.fromDocumentSnapshot(documentSnapshot: _doc);
    } catch (e) {
      Get.find<NavigationController>().alert('Unable to get user data', e.message);
      rethrow;
    }
  }

  //hero
  Future<HeroModel> getHero(String uid) async {
    try {
      DocumentSnapshot _doc =
      await _firestore.collection("hero").document(uid).get();
      return HeroModel.fromDocumentSnapshot(documentSnapshot: _doc);
    } catch (e) {
      Get.find<NavigationController>().alert('Unable to get hero data', e.message);
      rethrow;
    }
  }
}