import 'package:fluttermultistoreflutter/viewobject/common/ps_holder.dart'
    show PsHolder;
import 'package:flutter/cupertino.dart';

class AppInfoParameterHolder extends PsHolder<AppInfoParameterHolder> {
  AppInfoParameterHolder({@required this.startDate, @required this.endDate});

  final String startDate;
  final String endDate;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['start_date'] = startDate;
    map['end_date'] = endDate;

    return map;
  }

  @override
  AppInfoParameterHolder fromMap(dynamic dynamicData) {
    return AppInfoParameterHolder(
      startDate: dynamicData['start_date'],
      endDate: dynamicData['end_date'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (startDate != '') {
      key += startDate;
    }
    if (endDate != '') {
      key += endDate;
    }
    return key;
  }
}
