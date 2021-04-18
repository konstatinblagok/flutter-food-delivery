import 'package:fluttermultistoreflutter/db/common/ps_shared_preferences.dart';

class PsRepository {
  void loadValueHolder() {
    //PsSharedPreferences.instance.loadUserId('Mg Ba2');
    PsSharedPreferences.instance.loadValueHolder();
  }

  void replaceLoginUserId(String loginUserId) {
    PsSharedPreferences.instance.replaceLoginUserId(
      loginUserId,
    );
  }

  void replaceNotiToken(String notiToken) {
    PsSharedPreferences.instance.replaceNotiToken(
      notiToken,
    );
  }

  void replaceNotiSetting(bool notiSetting) {
    PsSharedPreferences.instance.replaceNotiSetting(
      notiSetting,
    );
  }

  void replaceDate(String startDate, String endDate) {
    PsSharedPreferences.instance.replaceDate(startDate, endDate);
  }

  void replaceVerifyUserData(String userIdToVerify, String userNameToVerify,
      String userEmailToVerify, String userPasswordToVerify) {
    PsSharedPreferences.instance.replaceVerifyUserData(userIdToVerify,
        userNameToVerify, userEmailToVerify, userPasswordToVerify);
  }

  void replaceVersionForceUpdateData(bool appInfoForceUpdate) {
    PsSharedPreferences.instance.replaceVersionForceUpdateData(
      appInfoForceUpdate,
    );
  }

  void replaceAppInfoData(String appInfoVersionNo, bool appInfoForceUpdate,
      String appInfoForceUpdateTitle, String appInfoForceUpdateMsg) {
    PsSharedPreferences.instance.replaceAppInfoData(appInfoVersionNo,
        appInfoForceUpdate, appInfoForceUpdateTitle, appInfoForceUpdateMsg);
  }

  void replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsApp,
    String phone,
  ) {
    PsSharedPreferences.instance.replaceShopInfoValueHolderData(
        overAllTaxLabel,
        overAllTaxValue,
        shippingTaxLabel,
        shippingTaxValue,
        shippingId,
        shopId,
        messenger,
        whatsApp,
        phone);
  }

  void replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) {
    PsSharedPreferences.instance.replaceCheckoutEnable(
        paypalEnabled,
        stripeEnabled,
        codEnabled,
        bankEnabled,
        standardShippingEnable,
        zoneShippingEnable,
        noShippingEnable);
  }

  void replacePublishKey(String pubKey) {
    PsSharedPreferences.instance.replacePublishKey(pubKey);
  }

  void replaceShop(String shopId, String shopName) {
    PsSharedPreferences.instance.replaceShop(shopId, shopName);
  }
}
