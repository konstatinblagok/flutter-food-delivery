import 'package:fluttermultistoreflutter/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class ProfileUpdateParameterHolder
    extends PsHolder<ProfileUpdateParameterHolder> {
  ProfileUpdateParameterHolder({
    @required this.userId,
    @required this.userName,
    @required this.userEmail,
    @required this.userPhone,
    @required this.userAboutMe,
    @required this.billingFirstName,
    @required this.billingLastName,
    @required this.billingCompany,
    @required this.billingAddress1,
    @required this.billingAddress2,
    @required this.billingCountry,
    @required this.billingState,
    @required this.billingCity,
    @required this.billingPostalCode,
    @required this.billingEmail,
    @required this.billingPhone,
    @required this.shippingFirstName,
    @required this.shippingLastName,
    @required this.shippingCompany,
    @required this.shippingAddress1,
    @required this.shippingAddress2,
    @required this.shippingCountry,
    @required this.shippingState,
    @required this.shippingCity,
    @required this.shippingPostalCode,
    @required this.shippingEmail,
    @required this.shippingPhone,
    @required this.countryId,
    @required this.cityId,
  });

  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String userAboutMe;
  final String billingFirstName;
  final String billingLastName;
  final String billingCompany;
  final String billingAddress1;
  final String billingAddress2;
  final String billingCountry;
  final String billingState;
  final String billingCity;
  final String billingPostalCode;
  final String billingEmail;
  final String billingPhone;
  final String shippingFirstName;
  final String shippingLastName;
  final String shippingCompany;
  final String shippingAddress1;
  final String shippingAddress2;
  final String shippingCountry;
  final String shippingState;
  final String shippingCity;
  final String shippingPostalCode;
  final String shippingEmail;
  final String shippingPhone;
  final String countryId;
  final String cityId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['user_name'] = userName;
    map['user_email'] = userEmail;
    map['user_phone'] = userPhone;
    map['user_about_me'] = userAboutMe;
    map['billing_first_name'] = billingFirstName;
    map['billing_last_name'] = billingLastName;
    map['billing_company'] = billingCompany;
    map['billing_address_1'] = billingAddress1;
    map['billing_address_2'] = billingAddress2;
    map['billing_country'] = billingCountry;
    map['billing_state'] = billingState;
    map['billing_city'] = billingCity;
    map['billing_postal_code'] = billingPostalCode;
    map['billing_email'] = billingEmail;
    map['billing_phone'] = billingPhone;
    map['shipping_first_name'] = shippingFirstName;
    map['shipping_last_name'] = shippingLastName;
    map['shipping_company'] = shippingCompany;
    map['shipping_address_1'] = shippingAddress1;
    map['shipping_address_2'] = shippingAddress2;
    map['shipping_country'] = shippingCountry;
    map['shipping_state'] = shippingState;
    map['shipping_city'] = shippingCity;
    map['shipping_postal_code'] = shippingPostalCode;
    map['shipping_email'] = shippingEmail;
    map['shipping_phone'] = shippingPhone;
    map['country_id'] = countryId;
    map['city_id'] = cityId;

    return map;
  }

  @override
  ProfileUpdateParameterHolder fromMap(dynamic dynamicData) {
    return ProfileUpdateParameterHolder(
      userId: dynamicData['user_id'],
      userName: dynamicData['user_name'],
      userEmail: dynamicData['user_email'],
      userPhone: dynamicData['user_phone'],
      userAboutMe: dynamicData['user_about_me'],
      billingFirstName: dynamicData['billing_first_name'],
      billingLastName: dynamicData['billing_last_name'],
      billingCompany: dynamicData['billing_company'],
      billingAddress1: dynamicData['billing_address_1'],
      billingAddress2: dynamicData['billing_address_2'],
      billingCountry: dynamicData['billing_country'],
      billingState: dynamicData['billing_state'],
      billingCity: dynamicData['billing_city'],
      billingPostalCode: dynamicData['billing_postal_code'],
      billingEmail: dynamicData['billing_email'],
      billingPhone: dynamicData['billing_phone'],
      shippingFirstName: dynamicData['shipping_first_name'],
      shippingLastName: dynamicData['shipping_last_name'],
      shippingCompany: dynamicData['shipping_company'],
      shippingAddress1: dynamicData['shipping_address_1'],
      shippingAddress2: dynamicData['shipping_address_2'],
      shippingCountry: dynamicData['shipping_country'],
      shippingState: dynamicData['shipping_state'],
      shippingCity: dynamicData['shipping_city'],
      shippingPostalCode: dynamicData['shipping_postal_code'],
      shippingEmail: dynamicData['shipping_email'],
      shippingPhone: dynamicData['shipping_phone'],
      countryId: dynamicData['country_id'],
      cityId: dynamicData['city_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (userName != '') {
      key += userName;
    }

    if (userEmail != '') {
      key += userEmail;
    }
    if (userPhone != '') {
      key += userPhone;
    }

    if (userAboutMe != '') {
      key += userAboutMe;
    }
    return key;
  }
}
