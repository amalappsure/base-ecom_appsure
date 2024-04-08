import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class Addresses {
  final bool? status;
  final String? statusCode;
  final String? message;
  final List<Address> addresses;

  const Addresses({
    this.status,
    this.statusCode,
    this.message,
    this.addresses = const [],
  });

  @override
  String toString() {
    return 'Address(status: $status, statusCode: $statusCode, message: $message, result: $addresses)';
  }

  factory Addresses.fromJson(Map<String, dynamic> json) => Addresses(
    status: json['status'] as bool?,
    statusCode: json['statusCode'] as String?,
    message: json['message'] as String?,
    addresses: (json['result'] as List<dynamic>?)
        ?.map((e) => Address.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': addresses.map((e) => e.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Addresses) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      status.hashCode ^
      statusCode.hashCode ^
      message.hashCode ^
      addresses.hashCode;
}

@immutable
class Address {
  final int id;
  final int? customerId;
  final String? fullName;
  final String? address1;
  final String? address2;
  final String? city;
  final String? jadah;
  final String? state;
  final int areaId;
  final String? block;
  final String? landmark;
  final String? zip;
  final String? phone;
  final int? addressTypeId;
  final bool defaultAddress;
  final bool? active;
  final String? email;
  final String? street;
  final String? civilId;
  final String? area;
  final String? houseNo;
  final String? floor;
  final String? apartmentNo;
  final String? residenceAddress;
  final bool? bypassAddress;
  final double? deliveryCharge;

  const Address({
    required this.id,
    this.customerId,
    this.fullName,
    this.address1,
    this.address2,
    this.city,
    this.jadah,
    this.state,
    required this.areaId,
    this.block,
    this.landmark,
    this.zip,
    this.phone,
    this.addressTypeId,
    this.defaultAddress = false,
    this.active,
    this.email,
    this.street,
    this.civilId,
    this.area,
    this.houseNo,
    this.floor,
    this.apartmentNo,
    this.residenceAddress,
    this.bypassAddress,
    this.deliveryCharge,
  });

  @override
  String toString() {
    return 'Result(id: $id, customerId: $customerId, fullName: $fullName, address1: $address1, address2: $address2, city: $city, jadah: $jadah, state: $state, areaId: $areaId, block: $block, landmark: $landmark, zip: $zip, phone: $phone, addressTypeId: $addressTypeId, defaultAddress: $defaultAddress, active: $active, email: $email, street: $street, civilId: $civilId, area: $area, houseNo: $houseNo, floor: $floor, apartmentNo: $apartmentNo, residenceAddress: $residenceAddress, bypassAddress: $bypassAddress, deliveryCharge: $deliveryCharge)';
  }

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'] as int,
    customerId: json['customerID'] as int?,
    fullName: json['fullName'] as String?,
    address1: json['address1'] as String?,
    address2: json['address2'] as dynamic,
    city: json['city'] as dynamic,
    jadah: json['jadah'] as dynamic,
    state: json['state'] as dynamic,
    areaId: json['areaID'] as int? ?? 0,
    block: json['block'] as String?,
    landmark: json['landmark'] as String?,
    zip: json['zip'] as dynamic,
    phone: json['phone'] as String?,
    addressTypeId: json['addressTypeID'] as int?,
    defaultAddress: (json['defaultAddress'] as bool? ?? false),
    active: json['active'] as bool?,
    email: json['email'] as dynamic,
    street: json['street'] as String?,
    civilId: json['civilID'] as dynamic,
    area: json['area'] as String?,
    houseNo: json['houseNo'] as String?,
    floor: json['floor'] as String?,
    apartmentNo: json['apartmentNo'] as dynamic,
    residenceAddress: json['residenceAddress'] as String?,
    bypassAddress: json['bypassAddress'] as bool?,
    deliveryCharge: (json['deliveryCharge'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerID': customerId,
    'fullName': fullName,
    'address1': address1,
    'address2': address2,
    'city': city,
    'jadah': jadah,
    'state': state,
    'areaID': areaId,
    'block': block,
    'landmark': landmark,
    'zip': zip,
    'phone': phone,
    'addressTypeID': addressTypeId,
    'defaultAddress': defaultAddress,
    'active': active,
    'email': email,
    'street': street,
    'civilID': civilId,
    'area': area,
    'houseNo': houseNo,
    'floor': floor,
    'apartmentNo': apartmentNo,
    'residenceAddress': residenceAddress,
    'bypassAddress': bypassAddress,
    'deliveryCharge': deliveryCharge,
  };

  Map<String, dynamic> toPostJson() => {
    'ID': id,
    'CustomerID': customerId,
    'FullName': fullName,
    'Phone': phone,
    'Email': email,
    'AddressTypeID': addressTypeId,
    'AreaID': areaId,
    'Block': block,
    'Jadah': jadah,
    'Street': street,
    'Address1': address1,
    'Floor': floor,
    'HouseNo': houseNo,
    'Landmark': landmark,
    'ResidenceAddress': residenceAddress,
    'DefaultAddress': defaultAddress,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Address) return false;

    return id == other.id;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      customerId.hashCode ^
      fullName.hashCode ^
      address1.hashCode ^
      address2.hashCode ^
      city.hashCode ^
      jadah.hashCode ^
      state.hashCode ^
      areaId.hashCode ^
      block.hashCode ^
      landmark.hashCode ^
      zip.hashCode ^
      phone.hashCode ^
      addressTypeId.hashCode ^
      defaultAddress.hashCode ^
      active.hashCode ^
      email.hashCode ^
      street.hashCode ^
      civilId.hashCode ^
      area.hashCode ^
      houseNo.hashCode ^
      floor.hashCode ^
      apartmentNo.hashCode ^
      residenceAddress.hashCode ^
      bypassAddress.hashCode ^
      deliveryCharge.hashCode;

  Address copyWith({
    int? id,
    int? customerId,
    String? fullName,
    String? address1,
    String? address2,
    String? city,
    String? jadah,
    String? state,
    int? areaId,
    String? block,
    String? landmark,
    String? zip,
    String? phone,
    int? addressTypeId,
    bool? defaultAddress,
    bool? active,
    String? email,
    String? street,
    String? civilId,
    String? area,
    String? houseNo,
    String? floor,
    String? apartmentNo,
    String? residenceAddress,
    bool? bypassAddress,
    double? deliveryCharge,
  }) {
    return Address(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      fullName: fullName ?? this.fullName,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      jadah: jadah ?? this.jadah,
      state: state ?? this.state,
      areaId: areaId ?? this.areaId,
      block: block ?? this.block,
      landmark: landmark ?? this.landmark,
      zip: zip ?? this.zip,
      phone: phone ?? this.phone,
      addressTypeId: addressTypeId ?? this.addressTypeId,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      active: active ?? this.active,
      email: email ?? this.email,
      street: street ?? this.street,
      civilId: civilId ?? this.civilId,
      area: area ?? this.area,
      houseNo: houseNo ?? this.houseNo,
      floor: floor ?? this.floor,
      apartmentNo: apartmentNo ?? this.apartmentNo,
      residenceAddress: residenceAddress ?? this.residenceAddress,
      bypassAddress: bypassAddress ?? this.bypassAddress,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
    );
  }
}
