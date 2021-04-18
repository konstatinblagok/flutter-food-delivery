import 'package:fluttermultistoreflutter/viewobject/attribute_detail.dart';
import 'package:quiver/core.dart';
import 'common/ps_object.dart';

class AttributeHeader extends PsObject<AttributeHeader> {
  AttributeHeader(
      {this.id,
      this.productId,
      this.name,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.attributesDetail});
  String id;
  String productId;
  String name;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  List<AttributeDetail> attributesDetail;

  @override
  bool operator ==(dynamic other) => other is AttributeHeader && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  AttributeHeader fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AttributeHeader(
        id: dynamicData['id'],
        productId: dynamicData['product_id'],
        name: dynamicData['name'],
        addedDate: dynamicData['added_date'],
        addedUserId: dynamicData['added_user_id'],
        updatedDate: dynamicData['updated_date'],
        updatedUserId: dynamicData['updated_user_id'],
        updatedFlag: dynamicData['updated_flag'],
        attributesDetail:
            AttributeDetail().fromMapList(dynamicData['attributes_detail']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['product_id'] = object.productId;
      data['name'] = object.name;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['attributes_detail'] =
          AttributeDetail().toMapList(object.attributesDetail);

      return data;
    } else {
      return null;
    }
  }

  @override
  List<AttributeHeader> fromMapList(List<dynamic> dynamicDataList) {
    final List<AttributeHeader> userLoginList = <AttributeHeader>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userLoginList.add(fromMap(dynamicData));
        }
      }
    }
    return userLoginList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }
    return dynamicList;
  }
}
