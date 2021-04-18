import 'package:fluttermultistoreflutter/viewobject/common/ps_object.dart';
import 'package:fluttermultistoreflutter/viewobject/delete_object.dart';
import 'package:fluttermultistoreflutter/viewobject/ps_app_version.dart';

class PSAppInfo extends PsObject<PSAppInfo> {
  PSAppInfo({this.psAppVersion, this.deleteObject});
  PSAppVersion psAppVersion;
  List<DeleteObject> deleteObject;

  @override
  String getPrimaryKey() {
    return '';
  }

  @override
  PSAppInfo fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return PSAppInfo(
          psAppVersion: PSAppVersion().fromMap(dynamicData['version']),
          deleteObject:
              DeleteObject().fromMapList(dynamicData['delete_history']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['version'] = PSAppVersion().fromMap(object.psAppVersion);
      data['delete_history'] = object.deleteObject.toList();
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PSAppInfo> fromMapList(List<dynamic> dynamicDataList) {
    final List<PSAppInfo> psAppInfoList = <PSAppInfo>[];

    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          psAppInfoList.add(fromMap(json));
        }
      }
    }
    return psAppInfoList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<dynamic> dynamicList = <dynamic>[];
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
