import 'package:get/get.dart';
import 'package:heroservices/models/main_service_model.dart';

class MainServiceController extends GetxController {
  ServiceModel selectedService;
  ServiceCategoryModel selectedServiceCategory;
  ServiceOptionModel selectedServiceOption;
  ServiceOptionFormModel selectedServiceOptionForm;

  setSelectedServiceCategory(ServiceCategoryModel serviceCategory) {
    selectedServiceCategory = serviceCategory;
    update();
  }

  setSelectedService(ServiceModel service) {
    selectedService = service;
    update();
  }

  setSelectedServiceOption(ServiceOptionModel serviceOption) {
    selectedServiceOption = serviceOption;
    update();
  }

  setSelectedServiceOptionForm(ServiceOptionFormModel serviceOptionForm) {
    selectedServiceOptionForm = serviceOptionForm;
    update();
  }

}