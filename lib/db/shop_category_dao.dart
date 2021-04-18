import 'package:fluttermultistoreflutter/viewobject/shop_category.dart';
import 'package:sembast/sembast.dart';
import 'package:fluttermultistoreflutter/db/common/ps_dao.dart' show PsDao;

class ShopCategoryDao extends PsDao<ShopCategory> {
  ShopCategoryDao._() {
    init(ShopCategory());
  }
  static const String STORE_NAME = 'ShopCategory';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ShopCategoryDao _singleton = ShopCategoryDao._();

  // Singleton accessor
  static ShopCategoryDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ShopCategory object) {
    return object.id;
  }

  @override
  Filter getFilter(ShopCategory object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
