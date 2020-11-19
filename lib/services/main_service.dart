import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/form_controller.dart';
import 'package:heroservices/models/main_service_model.dart';

class MainService {
  final String serviceCategoryId;
  final String serviceId;
  final String serviceOptionId;
  final String serviceOptionFormId;

  final bool filterCity;
  final String clientCity;
  final bool filterProvince;
  final String clientProvince;

  MainService({
    this.serviceCategoryId,
    this.serviceOptionId,
    this.serviceId,
    this.serviceOptionFormId,

    this.filterCity,
    this.clientCity,
    this.filterProvince,
    this.clientProvince,
  });

  /*
   * SERVICES
  */
  final CollectionReference serviceCollection =
      Firestore.instance.collection('service');

  List<ServiceModel> _serviceListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return ServiceModel(
        serviceId: doc.documentID,
        serviceCategoryId: doc.data['service_category_id'],
        name: doc.data['name'] ?? '',
        description: doc.data['description'] ?? '',
        enable: doc.data['enable'] ?? false,
        icon: doc.data['icon'] ?? 58790,
      );
    }).toList();
  }

  Stream<List<ServiceModel>> get services {
    return serviceCollection
        .where('service_category_id', isEqualTo: serviceCategoryId)
        .where('enable', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(_serviceListFromSnapshot);
  }

  /*
   * SERVICE CATEGORIES
  */
  final CollectionReference serviceCategoryCollection =
      Firestore.instance.collection('service_category');

  List<ServiceCategoryModel> _serviceCategoryListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return ServiceCategoryModel(
        serviceCategoryId: doc.documentID,
        name: doc.data['name'] ?? '',
        description: doc.data['description'] ?? '',
        enable: doc.data['enable'] ?? false,
        icon: doc.data['icon'] ?? 58790,
      );
    }).toList();
  }

  Stream<List<ServiceCategoryModel>> get serviceCategories {
    return serviceCategoryCollection
        .where('enable', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(_serviceCategoryListFromSnapshot);
  }

  /*
   * SERVICE OPTIONS
  */
  final CollectionReference serviceOptionCollection =
      Firestore.instance.collection('service_option');

  List<ServiceOptionModel> _serviceOptionListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return ServiceOptionModel(
        serviceOptionId: doc.documentID,
        serviceId: doc.data['service_id'] ?? '',

        serviceType: doc.data['service_type'] ?? '',
        hoursToDay: doc.data['hours_to_day'] ?? '',

        name: doc.data['name'] ?? '',
        description: doc.data['description'] ?? '',
        inclusions: doc.data['inclusions'] ?? '',
        enable: doc.data['enable'] ?? false,
        icon: doc.data['icon'] ?? 58790,

        multipleBooking: doc.data['multiple_booking'] ?? false,
        openPrice: doc.data['open_price'] ?? false,
        filterCity: doc.data['filter_city'] ?? false,
        filterProvince: doc.data['filter_province'] ?? false,
        minTimeline: doc.data['min_timeline'] ?? 1,
        maxTimeline: doc.data['max_timeline'] ?? 8,
      );
    }).toList();
  }

  Stream<List<ServiceOptionModel>> get serviceOptions {
    return serviceOptionCollection
        .where('service_id', isEqualTo: serviceId)
        .where('enable', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(_serviceOptionListFromSnapshot);
  }

  /*
   * SERVICE OPTION FEATURED
  */
  Stream<List<ServiceOptionModel>> get featured {
    return serviceOptionCollection
        .where('enable', isEqualTo: true)
        .where('featured', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(_serviceOptionListFromSnapshot);
  }

  /*
   * SERVICE OPTION HEROES
  */
  final CollectionReference serviceOptionHeroesCollection = Firestore.instance.collection('hero_services');

  List<HeroServiceModel> _serviceOptionHeroesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {

      Get.find<FormController>().expandHeroTile(doc.data['hero_id'], false);
      Get.find<FormController>().setHeroAvailable(doc.data['hero_id'], true);
      Get.find<FormController>().setHeroLoading(doc.data['hero_id'], false);

      return HeroServiceModel(
        heroServiceId: doc.documentID,
        heroId: doc.data['hero_id'] ?? '',
        profileId: doc.data['profile_id'] ?? '',
        serviceOptionId: doc.data['service_option_id'] ?? '',

        dailyRate: doc.data['daily_rate'] ?? 0,
        hourlyRate: doc.data['hourly_rate'] ?? 0,
        status: doc.data['status'] ?? '',

        heroName: doc.data['hero_name'] ?? '',
        heroAddress: doc.data['hero_address'] ?? '',
        heroCity: doc.data['hero_city'] ?? '',
        heroProvince: doc.data['hero_province'] ?? '',
        heroPhoto: doc.data['hero_photo'] ?? '',
        heroCertification: doc.data['hero_certification'] ?? '',
        heroRate: doc.data['hero_rate'] ?? '',
        heroExperience: doc.data['hero_experience'] ?? '',
      );
    }).toList();
  }

  Stream<List<HeroServiceModel>> get serviceHeroes {
    Query heroes = serviceOptionHeroesCollection
        .where('service_option_id', isEqualTo: serviceOptionId)
        .where('status', isEqualTo: 'active');

    if(filterCity) {
      print('filterCity : '+clientCity);
      heroes = heroes.where('hero_city', isEqualTo: clientCity);
    }

    if(filterProvince) {
      print('filterProvince : '+clientProvince);
      heroes = heroes.where('hero_province', isEqualTo: clientProvince);
    }

    return heroes.snapshots()
        .map(_serviceOptionHeroesListFromSnapshot);
  }

  /*
   * SERVICE OPTION FORMS
  */
  final CollectionReference serviceOptionFormCollection =
      Firestore.instance.collection('service_option_form');

  List<ServiceOptionFormModel> _serviceOptionFormListFromSnapshot(QuerySnapshot snapshot) {

    Get.find<FormController>().setTotalForm(snapshot.documents.length);

    return snapshot.documents.map((doc) {
      return ServiceOptionFormModel(
        serviceOptionFormId: doc.documentID,
        serviceOptionId: doc.data['service_option_id'] ?? '',
        name: doc.data['name'] ?? '',
        description: doc.data['description'] ?? '',
        order: doc.data['order'] ?? 1,
        visible: doc.data['visible'] ?? false,
      );
    }).toList();
  }

  Stream<List<ServiceOptionFormModel>> get serviceOptionForms {
    return serviceOptionFormCollection
        .where('service_option_id', isEqualTo: serviceOptionId)
        .where('visible', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map(_serviceOptionFormListFromSnapshot);
  }

  /*
   * SERVICE OPTION FORM FIELDS
  */
  final CollectionReference serviceOptionFormFieldCollection =
      Firestore.instance.collection('service_option_form_field');

  List<ServiceOptionFormFieldModel> _serviceOptionFormFieldListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      Get.put<FormController>(FormController()).addFieldValue(
          doc.data['label'],
          ''
      );

      if(doc.data['required']) {
        Get.put<FormController>(FormController()).addRequiredValue(
            doc.data['label'],
            'required'
        );
      }
      return ServiceOptionFormFieldModel(
        serviceOptionFormFieldId: doc.documentID,
        serviceOptionFormId: doc.data['service_option_form_id'] ?? '',
        label: doc.data['label'] ?? '',
        hint: doc.data['hint'] ?? '',
        placeholder: doc.data['placeholder'] ?? '',
        type: doc.data['type'] ?? '',
        values: doc.data['values'] ?? [],
        required: doc.data['required'] ?? false,
        order: doc.data['order'] ?? 1,
        visible: doc.data['visible'] ?? false,
      );
    }).toList();
  }

  Stream<List<ServiceOptionFormFieldModel>> get serviceOptionFormFields {
    return serviceOptionFormFieldCollection
        .where('service_option_form_id', isEqualTo: serviceOptionFormId)
        .where('visible', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map(_serviceOptionFormFieldListFromSnapshot);
  }
}
