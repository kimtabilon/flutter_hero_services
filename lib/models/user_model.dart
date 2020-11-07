import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String fname;
  String lname;
  String mobile;
  String email;
  String password;

  UserModel({this.id, this.fname, this.lname, this.mobile, this.email, this.password});

  UserModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.documentID;
    fname = documentSnapshot["fname"];
    lname = documentSnapshot["lname"];
    mobile = documentSnapshot["mobile"];
    email = documentSnapshot["email"];
    password = documentSnapshot["password"];
  }
}

class HeroModel {
  String id;
  String profileId;
  String email;
  String password;
  String status;
  bool editAccount;

  HeroModel({
    this.id,
    this.profileId,
    this.email,
    this.password,
    this.status,
    this.editAccount,
  });

  HeroModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.documentID;
    profileId = documentSnapshot["profile_id"];
    email = documentSnapshot["email"];
    password = documentSnapshot["password"];
    status = documentSnapshot["status"];
    editAccount = documentSnapshot["edit_account"];
  }
}

class ProfileModel {
  final String firstName;
  final String middleName;
  final String lastName;
  final String gender;
  final String birthday;

  ProfileModel({
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.birthday,
  });
}

class AddressModel {
  final String building;
  final String street;
  final String barangay;
  final String city;
  final String province;
  final String country;
  final String zip;

  AddressModel({
    this.building,
    this.street,
    this.barangay,
    this.city,
    this.province,
    this.country,
    this.zip,
  });
}

class ContactModel {
  final String type;
  final String value;

  ContactModel({
    this.type,
    this.value
  });
}

class LocationModel {
  final String lat;
  final String lng;
  final String ip;
  final String provider;
  final String wifi;

  LocationModel({
    this.lat,
    this.lng,
    this.ip,
    this.provider,
    this.wifi,
  });
}
