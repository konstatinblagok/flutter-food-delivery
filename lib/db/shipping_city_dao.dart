import 'package:fluttermultistoreflutter/viewobject/shipping_city.dart';
import 'package:sembast/sembast.dart';
import 'package:fluttermultistoreflutter/db/common/ps_dao.dart' show PsDao;

class ShippingCityDao extends PsDao<ShippingCity> {
  ShippingCityDao._() {
    init(ShippingCity());
  }
  static const String STORE_NAME = 'ShippingCity';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ShippingCityDao _singleton = ShippingCityDao._();

  // Singleton accessor
  static ShippingCityDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(ShippingCity object) {
    return object.id;
  }

  @override
  Filter getFilter(ShippingCity object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
