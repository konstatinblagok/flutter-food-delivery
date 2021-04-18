import 'package:fluttermultistoreflutter/viewobject/shop_tag.dart';
import 'package:sembast/sembast.dart';
import 'package:fluttermultistoreflutter/db/common/ps_dao.dart' show PsDao;

class ShopTagDao extends PsDao<ShopTag> {
  ShopTagDao._() {
    init(ShopTag());
  }
  static const String STORE_NAME = 'ShopTag';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ShopTagDao _singleton = ShopTagDao._();

  // Singleton accessor
  static ShopTagDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ShopTag object) {
    return object.id;
  }

  @override
  Filter getFilter(ShopTag object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
