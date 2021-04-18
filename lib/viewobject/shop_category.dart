import 'package:fluttermultistoreflutter/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';
import 'default_icon.dart';
import 'default_photo.dart';

class ShopCategory extends PsObject<ShopCategory> {
  ShopCategory(
      {this.id,
      this.name,
      this.status,
      this.addedDate,
      this.updatedDate,
      this.addedUserId,
      this.shopId,
      this.updatedUserId,
      this.updatedFlag,
      this.touchCount,
      this.addedDateStr,
      this.defaultPhoto,
      this.defaultIcon});

  String id;
  String name;
  String status;
  String addedDate;
  String updatedDate;
  String addedUserId;
  String shopId;
  String updatedUserId;
  String updatedFlag;
  String touchCount;
  String addedDateStr;
  DefaultPhoto defaultPhoto;
  DefaultIcon defaultIcon;

  @override
  bool operator ==(dynamic other) => other is ShopCategory && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  ShopCategory fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ShopCategory(
          id: dynamicData['id'],
          name: dynamicData['name'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          shopId: dynamicData['shop_id'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          touchCount: dynamicData['touch_count'],
          addedDateStr: dynamicData['added_date_str'],
          defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
          defaultIcon: DefaultIcon().fromMap(dynamicData['default_icon']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ShopCategory object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['shop_id'] = object.shopId;
      data['updated_date'] = object.updatedFlag;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['touch_count'] = object.touchCount;
      data['added_date_str'] = object.addedDateStr;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['default_icon'] = DefaultIcon().toMap(object.defaultIcon);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ShopCategory> fromMapList(List<dynamic> dynamicDataList) {
    final List<ShopCategory> subShopCategoryList = <ShopCategory>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subShopCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subShopCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<ShopCategory> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ShopCategory data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
