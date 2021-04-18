import 'package:quiver/core.dart';
import 'common/ps_map_object.dart';

class ShopListByTagId extends PsMapObject<ShopListByTagId> {
  ShopListByTagId({this.tagId, this.id, int sorting}) {
    super.sorting = sorting;
  }
  String id;
  String tagId;

  @override
  bool operator ==(dynamic other) => other is ShopListByTagId && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  ShopListByTagId fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ShopListByTagId(
          id: dynamicData['id'],
          tagId: dynamicData['tag_id'],
          sorting: dynamicData['sorting']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['tag_id'] = object.tagId;
      data['sorting'] = object.sorting;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ShopListByTagId> fromMapList(List<dynamic> dynamicDataList) {
    final List<ShopListByTagId> shopMapList = <ShopListByTagId>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          shopMapList.add(fromMap(dynamicData));
        }
      }
    }
    return shopMapList;
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

  @override
  List<String> getIdList(List<dynamic> mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic shop in mapList) {
        if (shop != null) {
          idList.add(shop.id);
        }
      }
    }
    return idList;
  }

  List<String> getShopList(List<dynamic> mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic shop in mapList) {
        if (shop != null) {
          idList.add(shop.tagId);
        }
      }
    }
    return idList;
  }

  List<ShopListByTagId> getShopListByTagId(List<dynamic> mapList) {
    final List<ShopListByTagId> idList = <ShopListByTagId>[];
    if (mapList != null) {
      for (dynamic shop in mapList) {
        if (shop != null) {
          idList.add(shop.tagId);
        }
      }
    }
    return idList;
  }
}
