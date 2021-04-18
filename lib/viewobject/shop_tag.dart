import 'package:fluttermultistoreflutter/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';
import 'default_icon.dart';
import 'default_photo.dart';

class ShopTag extends PsObject<ShopTag> {
  ShopTag(
      {this.id,
      this.name,
      this.status,
      this.addedDate,
      this.updatedDate,
      this.addedUserId,
      this.updatedUserId,
      this.addedDateStr,
      this.defaultPhoto,
      this.defaultIcon});

  String id;
  String name;
  String status;
  String addedDate;
  String updatedDate;
  String addedUserId;
  String updatedUserId;
  String addedDateStr;
  DefaultPhoto defaultPhoto;
  DefaultIcon defaultIcon;

  @override
  bool operator ==(dynamic other) => other is ShopTag && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  ShopTag fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ShopTag(
          id: dynamicData['id'],
          name: dynamicData['name'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          addedDateStr: dynamicData['added_date_str'],
          defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
          defaultIcon: DefaultIcon().fromMap(dynamicData['default_icon']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ShopTag object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['updated_date'] = object.updatedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_user_id'] = object.updatedUserId;
      data['added_date_str'] = object.addedDateStr;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['default_icon'] = DefaultIcon().toMap(object.defaultIcon);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ShopTag> fromMapList(List<dynamic> dynamicDataList) {
    final List<ShopTag> subShopTagList = <ShopTag>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subShopTagList.add(fromMap(dynamicData));
        }
      }
    }
    return subShopTagList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<ShopTag> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ShopTag data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
