class ServiceModel {
  final String serviceCategoryId;
  final String serviceId;
  final String name;
  final String description;
  final bool enable;
  final int icon;

  ServiceModel(
      {this.serviceCategoryId,
      this.serviceId,
      this.name,
      this.description,
      this.enable,
      this.icon});
}

class ServiceCategoryModel {
  final String serviceCategoryId;
  final String name;
  final String description;
  final bool enable;
  final int icon;

  ServiceCategoryModel(
      {this.serviceCategoryId,
      this.name,
      this.description,
      this.icon,
      this.enable});
}

class ServiceOptionModel {
  final String serviceOptionId;
  final String serviceId;

  final String name;
  final String description;
  final String inclusions;
  final bool enable;
  final int icon;

  final String serviceType; //quotation, hourly, daily, timeline, session
  final String hoursToDay;

  final bool multipleBooking; //bool
  final bool openPrice; //bool
  final bool filterCity; //bool
  final bool filterProvince; //bool
  final int minTimeline;
  final int maxTimeline;


  ServiceOptionModel({
    this.serviceOptionId,
    this.serviceId,

    this.name,
    this.description,
    this.inclusions,
    this.enable,
    this.icon,

    this.serviceType, //quotation, hourly, daily, timeline, session
    this.hoursToDay,

    this.multipleBooking,
    this.openPrice,
    this.filterCity,
    this.filterProvince,
    this.minTimeline,
    this.maxTimeline,

  });
}

class ServiceOptionFormModel {
  final String serviceOptionFormId;
  final String serviceOptionId;
  final String name;
  final String description;
  final int order;
  final bool visible;

  ServiceOptionFormModel(
      {this.serviceOptionFormId,
      this.serviceOptionId,
      this.name,
      this.description,
      this.order,
      this.visible});
}

class ServiceOptionFormFieldModel {
  final String serviceOptionFormFieldId;
  final String serviceOptionFormId;
  final String label;
  final String hint;
  final String placeholder;
  final String type;
  final List values;
  final bool required;
  final int order;
  final bool visible;

  ServiceOptionFormFieldModel(
      {this.serviceOptionFormFieldId,
      this.serviceOptionFormId,
      this.label,
      this.hint,
      this.placeholder,
      this.type,
      this.values,
      this.required,
      this.order,
      this.visible});
}

class HeroServiceModel {
  final String heroServiceId;
  final String heroId;
  final String profileId;
  final String serviceOptionId;

  final int dailyRate;
  final int hourlyRate;
  final String status;

  final String heroName;
  final String heroNumber;
  final String heroAddress;
  final String heroCity;
  final String heroProvince;
  final String heroPhoto;
  final String heroCertification;
  final String heroRate;
  final String heroExperience;

  HeroServiceModel({
    this.heroServiceId,
    this.heroId,
    this.profileId,
    this.serviceOptionId,

    this.dailyRate,
    this.hourlyRate,
    this.status,

    this.heroName,
    this.heroNumber,
    this.heroAddress,
    this.heroCity,
    this.heroProvince,
    this.heroPhoto,
    this.heroCertification,
    this.heroRate,
    this.heroExperience,

  });
}

class HeroSettingsModel {
  final String heroId;
  final bool autoConfirm;
  final String blockDates;
  final Map locations;
  final bool offline;

  HeroSettingsModel({
    this.heroId,
    this.autoConfirm,
    this.blockDates,
    this.locations,
    this.offline
  });

  HeroSettingsModel.fromJson(Map<String, dynamic> parsedJSON)
      : heroId = parsedJSON['hero_id'],
        autoConfirm = parsedJSON['auto_confirm'],
        blockDates = parsedJSON['block_dates'],
        locations = parsedJSON['locations'],
        offline = parsedJSON['offline'];
}
