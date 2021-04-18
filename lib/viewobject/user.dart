import 'package:fluttermultistoreflutter/viewobject/common/ps_object.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_city.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_country.dart';
import 'package:quiver/core.dart';

class User extends PsObject<User> {
  User(
      {this.userId,
      this.userIsSysAdmin,
      this.isShopAdmin,
      this.facebookId,
      this.googleId,
      this.userName,
      this.userEmail,
      this.userPhone,
      this.userPassword,
      this.userAboutMe,
      this.userCoverPhoto,
      this.userProfilePhoto,
      this.roleId,
      this.status,
      this.isBanned,
      this.addedDate,
      this.billingFirstName,
      this.billingLastName,
      this.billingCompany,
      this.billingAddress_1,
      this.billingAddress_2,
      this.billingCountry,
      this.billingState,
      this.billingCity,
      this.billingPostalCode,
      this.billingEmail,
      this.billingPhone,
      this.shippingFirstName,
      this.shippingLastName,
      this.shippingCompany,
      this.shippingAddress_1,
      this.shippingAddress_2,
      this.shippingCountry,
      this.shippingState,
      this.shippingCity,
      this.shippingPostalCode,
      this.shippingEmail,
      this.shippingPhone,
      this.deviceToken,
      this.code,
      this.verifyTypes,
      this.addedDateStr,
      this.country,
      this.city});
  String userId;
  String userIsSysAdmin;
  String isShopAdmin;
  String facebookId;
  String googleId;
  String userName;
  String userEmail;
  String userPhone;
  String userPassword;
  String userAboutMe;
  String userCoverPhoto;
  String userProfilePhoto;
  String roleId;
  String status;
  String isBanned;
  String addedDate;
  String billingFirstName;
  String billingLastName;
  String billingCompany;
  String billingAddress_1;
  String billingAddress_2;
  String billingCountry;
  String billingState;
  String billingCity;
  String billingPostalCode;
  String billingEmail;
  String billingPhone;
  String shippingFirstName;
  String shippingLastName;
  String shippingCompany;
  String shippingAddress_1;
  String shippingAddress_2;
  String shippingCountry;
  String shippingState;
  String shippingCity;
  String shippingPostalCode;
  String shippingEmail;
  String shippingPhone;
  String deviceToken;
  String code;
  String verifyTypes;
  String addedDateStr;
  ShippingCountry country;
  ShippingCity city;

  @override
  bool operator ==(dynamic other) => other is User && userId == other.userId;

  @override
  int get hashCode {
    return hash2(userId.hashCode, userId.hashCode);
  }

  @override
  String getPrimaryKey() {
    return userId;
  }

  @override
  User fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return User(
          userId: dynamicData['user_id'],
          userIsSysAdmin: dynamicData['user_is_sys_admin'],
          isShopAdmin: dynamicData['is_shop_admin'],
          facebookId: dynamicData['facebook_id'],
          googleId: dynamicData['google_id'],
          userName: dynamicData['user_name'],
          userEmail: dynamicData['user_email'],
          userPhone: dynamicData['user_phone'],
          userPassword: dynamicData['user_password'],
          userAboutMe: dynamicData['user_about_me'],
          userCoverPhoto: dynamicData['user_cover_photo'],
          userProfilePhoto: dynamicData['user_profile_photo'],
          roleId: dynamicData['role_id'],
          status: dynamicData['status'],
          isBanned: dynamicData['is_banned'],
          addedDate: dynamicData['added_date'],
          billingFirstName: dynamicData['billing_first_name'],
          billingLastName: dynamicData['billing_last_name'],
          billingCompany: dynamicData['billing_company'],
          billingAddress_1: dynamicData['billing_address_1'],
          billingAddress_2: dynamicData['billing_address_2'],
          billingCountry: dynamicData['billing_country'],
          billingState: dynamicData['billing_state'],
          billingCity: dynamicData['billing_city'],
          billingPostalCode: dynamicData['billing_postal_code'],
          billingEmail: dynamicData['billing_email'],
          billingPhone: dynamicData['billing_phone'],
          shippingFirstName: dynamicData['shipping_first_name'],
          shippingLastName: dynamicData['shipping_last_name'],
          shippingCompany: dynamicData['shipping_company'],
          shippingAddress_1: dynamicData['shipping_address_1'],
          shippingAddress_2: dynamicData['shipping_address_2'],
          shippingCountry: dynamicData['shipping_country'],
          shippingState: dynamicData['shipping_state'],
          shippingCity: dynamicData['shipping_city'],
          shippingPostalCode: dynamicData['shipping_postal_code'],
          shippingEmail: dynamicData['shipping_email'],
          shippingPhone: dynamicData['shipping_phone'],
          deviceToken: dynamicData['device_token'],
          code: dynamicData['code'],
          verifyTypes: dynamicData['verify_types'],
          addedDateStr: dynamicData['added_date_str'],
          country: ShippingCountry().fromMap(dynamicData['country']),
          city: ShippingCity().fromMap(dynamicData['city']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(User object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['user_id'] = object.userId;
      data['user_is_sys_admin'] = object.userIsSysAdmin;
      data['is_shop_admin'] = object.isShopAdmin;
      data['facebook_id'] = object.facebookId;
      data['google_id'] = object.googleId;
      data['user_name'] = object.userName;
      data['user_email'] = object.userEmail;
      data['user_phone'] = object.userPhone;
      data['user_password'] = object.userPassword;
      data['user_about_me'] = object.userAboutMe;
      data['user_cover_photo'] = object.userCoverPhoto;
      data['user_profile_photo'] = object.userProfilePhoto;
      data['role_id'] = object.roleId;
      data['status'] = object.status;
      data['is_banned'] = object.isBanned;
      data['added_date'] = object.addedDate;
      data['billing_first_name'] = object.billingFirstName;
      data['billing_last_name'] = object.billingLastName;
      data['billing_company'] = object.billingCompany;
      data['billing_address_1'] = object.billingAddress_1;
      data['billing_address_2'] = object.billingAddress_2;
      data['billing_country'] = object.billingCountry;
      data['billing_state'] = object.billingState;
      data['billing_city'] = object.billingCity;
      data['billing_postal_code'] = object.billingPostalCode;
      data['billing_email'] = object.billingEmail;
      data['billing_phone'] = object.billingPhone;
      data['shipping_first_name'] = object.shippingFirstName;
      data['shipping_last_name'] = object.shippingLastName;
      data['shipping_company'] = object.shippingCompany;
      data['shipping_address_1'] = object.shippingAddress_1;
      data['shipping_address_2'] = object.shippingAddress_2;
      data['shipping_country'] = object.shippingCountry;
      data['shipping_state'] = object.shippingState;
      data['shipping_city'] = object.shippingCity;
      data['shipping_postal_code'] = object.shippingPostalCode;
      data['shipping_email'] = object.shippingEmail;
      data['shipping_phone'] = object.shippingPhone;
      data['device_token'] = object.deviceToken;
      data['code'] = object.code;
      data['verify_types'] = object.verifyTypes;
      data['added_date_str'] = object.addedDateStr;
      data['country'] = ShippingCountry().toMap(object.country);
      data['city'] = ShippingCity().toMap(object.city);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<User> fromMapList(List<dynamic> dynamicDataList) {
    final List<User> subUserList = <User>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subUserList.add(fromMap(dynamicData));
        }
      }
    }
    return subUserList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<User> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (User data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
