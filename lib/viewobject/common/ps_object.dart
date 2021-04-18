abstract class PsObject<T> {
  int key = 0;

  String getPrimaryKey();

  T fromMap(dynamic dynamicData);

  Map<String, dynamic> toMap(T object);

  List<T> fromMapList(List<dynamic> dynamicDataList);

  List<Map<String, dynamic>> toMapList(List<T> objectList);
}
