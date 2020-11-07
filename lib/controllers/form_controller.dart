import 'package:get/get.dart';
import 'package:heroservices/models/main_service_model.dart';

class FormController extends GetxController {
  Map<String, String> formValues = {};
  Map<String, String> defaultFormValues = {};

  List formHeroes = [];


  Map<String, String> requiredValues = {};
  int totalForm;
  int currentForm;
  Map<String, bool> isHeroExpanded = {};
  Map<String, bool> isHeroAvailable = {};
  Map<String, bool> isHeroLoading = {};

  addFieldValue(String key, String value) {
    formValues.update(key, (v) => value, ifAbsent: () => value);
    update();
  }

  addDefaultFieldValue(String key, String value) {
    defaultFormValues.update(key, (v) => value, ifAbsent: () => value);
    update();
  }

  addFormHeroes(HeroServiceModel hero) {
    formHeroes.add(hero);
    var names='';
    int total=0;
    for(var x=0; x<formHeroes.length; x++) {
      HeroServiceModel h = formHeroes[x];
      names+=h.heroName+', ';
      total+=(h.hourlyRate*int.parse(defaultFormValues['Timeline']));
    }
    addDefaultFieldValue('Hero', names);
    addDefaultFieldValue('Total', total.toString());
    update();
  }

  removeFormHeroes(int index) {
    formHeroes.removeAt(index);

    var names='';
    int total=0;
    for(var x=0; x<formHeroes.length; x++) {
      HeroServiceModel h = formHeroes[x];
      names+=h.heroName+', ';
      total+=(h.hourlyRate*int.parse(defaultFormValues['Timeline']));
    }

    addDefaultFieldValue('Hero', names);
    addDefaultFieldValue('Total', total.toString());

    update();
  }

  resetFormHeroes() {
    formHeroes = [];
    update();
  }

  addRequiredValue(String key, String value) {
    requiredValues.update(key, (v) => value, ifAbsent: () => value);
    //print('requiredValues : '+requiredValues.toString());
    update();
  }

  setTotalForm(int value) {
    totalForm = value;
    update();
  }

  setCurrentForm() {
    currentForm++;
    update();
  }

  setHeroAvailable(String heroId, bool value) {
    isHeroAvailable.update(heroId, (v) => value, ifAbsent: () => value);
    //print(isHeroAvailable.toString());
    update();
  }
  expandHeroTile(String heroId, bool value) {
    isHeroExpanded.update(heroId, (v) => value, ifAbsent: () => value);
    //print(isHeroExpanded.toString());
    update();
  }

  setHeroLoading(String heroId, bool value) {
    isHeroLoading.update(heroId, (v) => value, ifAbsent: () => value);
    //print(isHeroExpanded.toString());
    update();
  }

  resetForm(ServiceOptionModel serviceOption) {
    currentForm=0;
    totalForm=0;

    formValues={};
    defaultFormValues={};
    isHeroLoading={};
    isHeroExpanded={};
    isHeroAvailable={};

    requiredValues={'Schedule':'required','Timeline':'required','Customer Name':'required','Customer Address':'required',};

    formHeroes = [];

    if(serviceOption.serviceType!='quotation') {
      addRequiredValue('Hero','required');
    } else {
      if(!serviceOption.openPrice) {
        addRequiredValue('Price','required');
      }
    }

    if(serviceOption.serviceType=='daily') {
      addDefaultFieldValue('Timeline Type', 'Days');
    } else {
      addDefaultFieldValue('Timeline Type', 'Hours');
    }

    update();
  }


}