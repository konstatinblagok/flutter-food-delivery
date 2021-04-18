import 'package:fluttermultistoreflutter/viewobject/shipping_method.dart';
import 'package:sembast/sembast.dart';
import 'package:fluttermultistoreflutter/db/common/ps_dao.dart' show PsDao;

class ShippingMethodDao extends PsDao<ShippingMethod> {
  ShippingMethodDao._() {
    init(ShippingMethod());
  }
  static const String STORE_NAME = 'ShippingMethod';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ShippingMethodDao _singleton = ShippingMethodDao._();

  // Singleton accessor
  static ShippingMethodDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ShippingMethod object) {
    return object.id;
  }

  @override
  Filter getFilter(ShippingMethod object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
