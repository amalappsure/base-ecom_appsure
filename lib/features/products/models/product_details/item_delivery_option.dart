import 'package:flutter/foundation.dart';

@immutable
class ItemDeliveryOption {
  final int? id;
  final dynamic itemId;
  final dynamic deliveryOptionId;
  final String? deliveryOption;
  final String? title;
  final dynamic arabicTitle;
  final bool? appliedDelOption;
  final dynamic locationId;
  final double rate;
  final bool? sunday;
  final bool? monday;
  final bool? tuesday;
  final bool? wednesday;
  final bool? thursday;
  final bool? friday;
  final bool? saturday;
  final dynamic fromTime;
  final dynamic toTime;
  final bool? isDefault;
  final String? description;
  final dynamic arabicDescription;
  final String? deliveryTerms;
  final dynamic arabicDeliveryTerms;
  final bool? active;
  final dynamic menuId;
  final dynamic companyId;
  final dynamic dataSet;
  final dynamic dataTable;
  final dynamic username;
  final dynamic localIp;
  final dynamic internetIp;
  final dynamic language;
  final dynamic connectionString;

  const ItemDeliveryOption({
    this.id,
    this.itemId,
    this.deliveryOptionId,
    this.deliveryOption,
    this.title,
    this.arabicTitle,
    this.appliedDelOption,
    this.locationId,
    this.rate = 0,
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.fromTime,
    this.toTime,
    this.isDefault,
    this.description,
    this.arabicDescription,
    this.deliveryTerms,
    this.arabicDeliveryTerms,
    this.active,
    this.menuId,
    this.companyId,
    this.dataSet,
    this.dataTable,
    this.username,
    this.localIp,
    this.internetIp,
    this.language,
    this.connectionString,
  });

  @override
  String toString() {
    return 'ItemDeliveryOption(id: $id, itemId: $itemId, deliveryOptionId: $deliveryOptionId, deliveryOption: $deliveryOption, title: $title, arabicTitle: $arabicTitle, appliedDelOption: $appliedDelOption, locationId: $locationId, rate: $rate, sunday: $sunday, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, fromTime: $fromTime, toTime: $toTime, isDefault: $isDefault, description: $description, arabicDescription: $arabicDescription, deliveryTerms: $deliveryTerms, arabicDeliveryTerms: $arabicDeliveryTerms, active: $active, menuId: $menuId, companyId: $companyId, dataSet: $dataSet, dataTable: $dataTable, username: $username, localIp: $localIp, internetIp: $internetIp, language: $language, connectionString: $connectionString)';
  }

  factory ItemDeliveryOption.fromJson(Map<String, dynamic> json) {
    return ItemDeliveryOption(
      id: json['id'] as int?,
      itemId: json['itemID'] as dynamic,
      deliveryOptionId: json['deliveryOptionID'] as dynamic,
      deliveryOption: json['deliveryOption'] as String?,
      title: json['title'] as String?,
      arabicTitle: json['arabicTitle'] as dynamic,
      appliedDelOption: json['appliedDelOption'] as bool?,
      locationId: json['locationID'] as dynamic,
      rate: (json['rate'] as num? ?? 0).toDouble(),
      sunday: json['sunday'] as bool?,
      monday: json['monday'] as bool?,
      tuesday: json['tuesday'] as bool?,
      wednesday: json['wednesday'] as bool?,
      thursday: json['thursday'] as bool?,
      friday: json['friday'] as bool?,
      saturday: json['saturday'] as bool?,
      fromTime: json['fromTime'] as dynamic,
      toTime: json['toTime'] as dynamic,
      isDefault: json['isDefault'] as bool?,
      description: json['description'] as String?,
      arabicDescription: json['arabicDescription'] as dynamic,
      deliveryTerms: json['deliveryTerms'] as String?,
      arabicDeliveryTerms: json['arabicDeliveryTerms'] as dynamic,
      active: json['active'] as bool?,
      menuId: json['menuID'] as dynamic,
      companyId: json['companyID'] as dynamic,
      dataSet: json['dataSet'] as dynamic,
      dataTable: json['dataTable'] as dynamic,
      username: json['username'] as dynamic,
      localIp: json['localIP'] as dynamic,
      internetIp: json['internetIP'] as dynamic,
      language: json['language'] as dynamic,
      connectionString: json['connectionString'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemID': itemId,
    'deliveryOptionID': deliveryOptionId,
    'deliveryOption': deliveryOption,
    'title': title,
    'arabicTitle': arabicTitle,
    'appliedDelOption': appliedDelOption,
    'locationID': locationId,
    'rate': rate,
    'sunday': sunday,
    'monday': monday,
    'tuesday': tuesday,
    'wednesday': wednesday,
    'thursday': thursday,
    'friday': friday,
    'saturday': saturday,
    'fromTime': fromTime,
    'toTime': toTime,
    'isDefault': isDefault,
    'description': description,
    'arabicDescription': arabicDescription,
    'deliveryTerms': deliveryTerms,
    'arabicDeliveryTerms': arabicDeliveryTerms,
    'active': active,
    'menuID': menuId,
    'companyID': companyId,
    'dataSet': dataSet,
    'dataTable': dataTable,
    'username': username,
    'localIP': localIp,
    'internetIP': internetIp,
    'language': language,
    'connectionString': connectionString,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ItemDeliveryOption) return false;

    return id == other.id;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      itemId.hashCode ^
      deliveryOptionId.hashCode ^
      deliveryOption.hashCode ^
      title.hashCode ^
      arabicTitle.hashCode ^
      appliedDelOption.hashCode ^
      locationId.hashCode ^
      rate.hashCode ^
      sunday.hashCode ^
      monday.hashCode ^
      tuesday.hashCode ^
      wednesday.hashCode ^
      thursday.hashCode ^
      friday.hashCode ^
      saturday.hashCode ^
      fromTime.hashCode ^
      toTime.hashCode ^
      isDefault.hashCode ^
      description.hashCode ^
      arabicDescription.hashCode ^
      deliveryTerms.hashCode ^
      arabicDeliveryTerms.hashCode ^
      active.hashCode ^
      menuId.hashCode ^
      companyId.hashCode ^
      dataSet.hashCode ^
      dataTable.hashCode ^
      username.hashCode ^
      localIp.hashCode ^
      internetIp.hashCode ^
      language.hashCode ^
      connectionString.hashCode;
}
