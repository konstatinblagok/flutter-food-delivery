import 'package:fluttermultistoreflutter/viewobject/shop_list_by_tag_id.dart';
import 'package:sembast/sembast.dart';
import 'package:fluttermultistoreflutter/db/common/ps_dao.dart' show PsDao;

class ShopListByTagIdDao extends PsDao<ShopListByTagId> {
  ShopListByTagIdDao._() {
    init(ShopListByTagId());
  }
  static const String STORE_NAME = 'ShopListByTagId';
  final String _primaryKey = 'id';
  final String tagId = 'tag_id';

  // Singleton instance
  static final ShopListByTagIdDao _singleton = ShopListByTagIdDao._();

  // Singleton accessor
  static ShopListByTagIdDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ShopListByTagId object) {
    return object.id;
  }

  @override
  Filter getFilter(ShopListByTagId object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
