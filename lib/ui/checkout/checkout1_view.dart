import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/user/user_provider.dart';
import 'package:fluttermultistoreflutter/repository/user_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/error_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/loading_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/success_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_textfield_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/profile_update_view_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_city.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_country.dart';
import 'package:fluttermultistoreflutter/viewobject/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class Checkout1View extends StatefulWidget {
  const Checkout1View(this.updateCheckout1ViewState);
  final Function updateCheckout1ViewState;

  @override
  _Checkout1ViewState createState() {
    final _Checkout1ViewState _state = _Checkout1ViewState();
    updateCheckout1ViewState(_state);
    return _state;
  }
}

class _Checkout1ViewState extends State<Checkout1View> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController shippingFirstNameController = TextEditingController();
  TextEditingController shippingLastNameController = TextEditingController();
  TextEditingController shippingEmailController = TextEditingController();
  TextEditingController shippingPhoneController = TextEditingController();
  TextEditingController shippingCompanyController = TextEditingController();
  TextEditingController shippingAddress1Controller = TextEditingController();
  TextEditingController shippingAddress2Controller = TextEditingController();
  TextEditingController shippingCountryController = TextEditingController();
  TextEditingController shippingStateController = TextEditingController();
  TextEditingController shippingCityController = TextEditingController();
  TextEditingController shippingPostalCodeController = TextEditingController();

  TextEditingController billingFirstNameController = TextEditingController();
  TextEditingController billingLastNameController = TextEditingController();
  TextEditingController billingEmailController = TextEditingController();
  TextEditingController billingPhoneController = TextEditingController();
  TextEditingController billingCompanyController = TextEditingController();
  TextEditingController billingAddress1Controller = TextEditingController();
  TextEditingController billingAddress2Controller = TextEditingController();
  TextEditingController billingCountryController = TextEditingController();
  TextEditingController billingStateController = TextEditingController();
  TextEditingController billingCityController = TextEditingController();
  TextEditingController billingPostalCodeController = TextEditingController();

  bool isSwitchOn = false;
  UserRepository userRepository;
  UserProvider userProvider;
  PsValueHolder valueHolder;
  String countryId;

  bool bindDataFirstTime = true;

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    return Consumer<UserProvider>(builder:
        (BuildContext context, UserProvider userProvider, Widget child) {
      if (userProvider.user != null && userProvider.user.data != null) {
        if (bindDataFirstTime) {
          /// Shipping Data
          userEmailController.text = userProvider.user.data.userEmail;
          userPhoneController.text = userProvider.user.data.userPhone;
          shippingFirstNameController.text =
              userProvider.user.data.shippingFirstName;
          shippingLastNameController.text =
              userProvider.user.data.shippingLastName;
          shippingCompanyController.text =
              userProvider.user.data.shippingCompany;
          shippingAddress1Controller.text =
              userProvider.user.data.shippingAddress_1;
          shippingAddress2Controller.text =
              userProvider.user.data.shippingAddress_2;
          // shippingCountryController.text =
          //     userProvider.user.data.shippingCountry;
          if (userProvider != null && userProvider.selectedCountry != null) {
            shippingCountryController.text = userProvider.selectedCountry.name;
          }
          shippingStateController.text = userProvider.user.data.shippingState;
          // shippingCityController.text = userProvider.user.data.shippingCity;
          if (userProvider != null && userProvider.selectedCity != null) {
            shippingCityController.text = userProvider.selectedCity.name;
          }
          shippingPostalCodeController.text =
              userProvider.user.data.shippingPostalCode;
          shippingEmailController.text = userProvider.user.data.shippingEmail;
          shippingPhoneController.text = userProvider.user.data.shippingPhone;
          userProvider.selectedCountry = userProvider.user.data.country;
          userProvider.selectedCity = userProvider.user.data.city;

          /// Billing Data
          billingFirstNameController.text =
              userProvider.user.data.billingFirstName;
          billingLastNameController.text =
              userProvider.user.data.billingLastName;
          billingEmailController.text = userProvider.user.data.billingEmail;
          billingPhoneController.text = userProvider.user.data.billingPhone;
          billingCompanyController.text = userProvider.user.data.billingCompany;
          billingAddress1Controller.text =
              userProvider.user.data.billingAddress_1;
          billingAddress2Controller.text =
              userProvider.user.data.billingAddress_2;
          billingCountryController.text = userProvider.user.data.billingCountry;
          billingStateController.text = userProvider.user.data.billingState;
          billingCityController.text = userProvider.user.data.billingCity;
          billingPostalCodeController.text =
              userProvider.user.data.billingPostalCode;
          bindDataFirstTime = false;
        }
        return SingleChildScrollView(
          child: Container(
            color: PsColors.backgroundColor,
            padding: const EdgeInsets.only(
                left: PsDimens.space16, right: PsDimens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: PsDimens.space16,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space12,
                      right: PsDimens.space12,
                      top: PsDimens.space16),
                  child: Text(
                    Utils.getString(context, 'checkout1__contact_info'),
                    style: Theme.of(context).textTheme.subtitle.copyWith(),
                  ),
                ),
                const SizedBox(
                  height: PsDimens.space16,
                ),
                PsTextFieldWidget(
                    titleText: Utils.getString(context, 'edit_profile__email'),
                    textAboutMe: false,
                    hintText: Utils.getString(context, 'edit_profile__email'),
                    textEditingController: userEmailController,
                    isStar: true),
                PsTextFieldWidget(
                    titleText: Utils.getString(context, 'edit_profile__phone'),
                    textAboutMe: false,
                    phoneInputType: true,
                    hintText: Utils.getString(context, 'edit_profile__phone'),
                    textEditingController: userPhoneController),
                const SizedBox(
                  height: PsDimens.space16,
                ),
                Container(
                    margin: const EdgeInsets.only(
                        left: PsDimens.space12,
                        right: PsDimens.space12,
                        top: PsDimens.space16),
                    child: Text(
                      Utils.getString(context, 'checkout1__shipping_address'),
                      style: Theme.of(context).textTheme.subtitle.copyWith(),
                    )),
                const SizedBox(
                  height: PsDimens.space16,
                ),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__first_name'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__first_name'),
                    textEditingController: shippingFirstNameController),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__last_name'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__last_name'),
                    textEditingController: shippingLastNameController),
                PsTextFieldWidget(
                    titleText: Utils.getString(context, 'edit_profile__email'),
                    textAboutMe: false,
                    hintText: Utils.getString(context, 'edit_profile__email'),
                    textEditingController: shippingEmailController),
                PsTextFieldWidget(
                    titleText: Utils.getString(context, 'edit_profile__phone'),
                    textAboutMe: false,
                    hintText: Utils.getString(context, 'edit_profile__phone'),
                    textEditingController: shippingPhoneController),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__company_name'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__company_name'),
                    textEditingController: shippingCompanyController),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__address1'),
                    height: PsDimens.space120,
                    textAboutMe: true,
                    hintText:
                        Utils.getString(context, 'edit_profile__address1'),
                    keyboardType: TextInputType.multiline,
                    textEditingController: shippingAddress1Controller,
                    isStar: true),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__address2'),
                    height: PsDimens.space120,
                    textAboutMe: true,
                    hintText:
                        Utils.getString(context, 'edit_profile__address2'),
                    keyboardType: TextInputType.multiline,
                    textEditingController: shippingAddress2Controller),
                PsDropdownBaseWithControllerWidget(
                    title:
                        Utils.getString(context, 'edit_profile__country_name'),
                    textEditingController: shippingCountryController,
                    isStar: true,
                    onTap: () async {
                      final dynamic result = await Navigator.pushNamed(
                          context, RoutePaths.countryList);

                      if (result != null && result is ShippingCountry) {
                        setState(() {
                          countryId = result.id;
                          shippingCountryController.text = result.name;
                          shippingCityController.text = '';
                          userProvider.selectedCountry = result;
                          userProvider.selectedCity = null;
                        });
                      }
                    }),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__state_name'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__state_name'),
                    textEditingController: shippingStateController),
                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(context, 'edit_profile__city_name'),
                    textEditingController: shippingCityController,
                    isStar: true,
                    onTap: () async {
                      if (shippingCountryController.text.isEmpty) {
                        showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return WarningDialog(
                                message: Utils.getString(
                                    context, 'edit_profile__selected_country'),
                              );
                            });
                      } else {
                        final dynamic result = await Navigator.pushNamed(
                            context, RoutePaths.cityList,
                            arguments:
                                countryId ?? userProvider.user.data.country.id);

                        if (result != null && result is ShippingCity) {
                          setState(() {
                            shippingCityController.text = result.name;
                            userProvider.selectedCity = result;
                          });
                        }
                      }
                    }),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__postal_code'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__postal_code'),
                    textEditingController: shippingPostalCodeController),
                const SizedBox(
                  height: PsDimens.space20,
                ),
                const Divider(
                  height: PsDimens.space1,
                ),
                const SizedBox(
                  height: PsDimens.space20,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space12,
                      right: PsDimens.space12,
                      top: PsDimens.space16),
                  child: Text(
                    Utils.getString(context, 'checkout1__billing_address'),
                    style: Theme.of(context).textTheme.subtitle.copyWith(),
                  ),
                ),
                const SizedBox(
                  height: PsDimens.space16,
                ),
                Row(
                  children: <Widget>[
                    Switch(
                      value: isSwitchOn,
                      onChanged: (bool isOn) {
                        print(isOn);
                        setState(() {
                          isSwitchOn = isOn;

                          // bindBillingData();
                          billingFirstNameController.text =
                              shippingFirstNameController.text;
                          billingLastNameController.text =
                              shippingLastNameController.text;
                          billingEmailController.text =
                              shippingEmailController.text;
                          billingPhoneController.text =
                              shippingPhoneController.text;
                          billingCompanyController.text =
                              shippingCompanyController.text;
                          billingAddress1Controller.text =
                              shippingAddress1Controller.text;
                          billingAddress2Controller.text =
                              shippingAddress2Controller.text;
                          billingCountryController.text =
                              shippingCountryController.text;
                          billingStateController.text =
                              shippingStateController.text;
                          billingCityController.text =
                              shippingCityController.text;
                          billingPostalCodeController.text =
                              shippingPostalCodeController.text;
                        });
                      },
                      activeTrackColor: PsColors.mainColor,
                      activeColor: PsColors.mainDarkColor,
                    ),
                    Text(Utils.getString(
                        context, 'checkout1__same_billing_address')),
                  ],
                ),
                const SizedBox(
                  height: PsDimens.space16,
                ),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__first_name'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__first_name'),
                    textEditingController: billingFirstNameController),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__last_name'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__last_name'),
                    textEditingController: billingLastNameController),
                PsTextFieldWidget(
                    titleText: Utils.getString(context, 'edit_profile__email'),
                    textAboutMe: false,
                    hintText: Utils.getString(context, 'edit_profile__email'),
                    textEditingController: billingEmailController),
                PsTextFieldWidget(
                    titleText: Utils.getString(context, 'edit_profile__phone'),
                    textAboutMe: false,
                    hintText: Utils.getString(context, 'edit_profile__phone'),
                    textEditingController: billingPhoneController),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__company_name'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__company_name'),
                    textEditingController: billingCompanyController),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__address1'),
                    height: PsDimens.space120,
                    textAboutMe: true,
                    hintText:
                        Utils.getString(context, 'edit_profile__address1'),
                    keyboardType: TextInputType.multiline,
                    textEditingController: billingAddress1Controller,
                    isStar: true),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__address2'),
                    height: PsDimens.space120,
                    textAboutMe: true,
                    hintText:
                        Utils.getString(context, 'edit_profile__address2'),
                    keyboardType: TextInputType.multiline,
                    textEditingController: billingAddress2Controller),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__country_name'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__country_name'),
                    textEditingController: billingCountryController),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__state_name'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__state_name'),
                    textEditingController: billingStateController),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__city_name'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__city_name'),
                    textEditingController: billingCityController),
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'edit_profile__postal_code'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'edit_profile__postal_code'),
                    textEditingController: billingPostalCodeController),
                const SizedBox(
                  height: PsDimens.space16,
                ),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }

  dynamic checkIsDataChange(UserProvider userProvider) async {
    if (userProvider.user.data.userEmail == userEmailController.text &&
        userProvider.user.data.userPhone == userPhoneController.text &&
        userProvider.user.data.billingFirstName ==
            billingFirstNameController.text &&
        userProvider.user.data.billingLastName ==
            billingLastNameController.text &&
        userProvider.user.data.billingCompany ==
            billingCompanyController.text &&
        userProvider.user.data.billingAddress_1 ==
            billingAddress1Controller.text &&
        userProvider.user.data.billingAddress_2 ==
            billingAddress2Controller.text &&
        userProvider.user.data.billingCountry ==
            billingCountryController.text &&
        userProvider.user.data.billingState == billingStateController.text &&
        userProvider.user.data.billingCity == billingCityController.text &&
        userProvider.user.data.billingPostalCode ==
            billingPostalCodeController.text &&
        userProvider.user.data.billingEmail == billingEmailController.text &&
        userProvider.user.data.billingPhone == billingPhoneController.text &&
        userProvider.user.data.shippingFirstName ==
            shippingFirstNameController.text &&
        userProvider.user.data.shippingLastName ==
            shippingLastNameController.text &&
        userProvider.user.data.shippingCompany ==
            shippingCompanyController.text &&
        userProvider.user.data.shippingAddress_1 ==
            shippingAddress1Controller.text &&
        userProvider.user.data.shippingAddress_2 ==
            shippingAddress2Controller.text &&
        userProvider.user.data.shippingCountry ==
            shippingCountryController.text &&
        userProvider.user.data.shippingState == shippingStateController.text &&
        userProvider.user.data.shippingCity == shippingCityController.text &&
        userProvider.user.data.shippingPostalCode ==
            shippingPostalCodeController.text &&
        userProvider.user.data.shippingEmail == shippingEmailController.text &&
        userProvider.user.data.shippingPhone == shippingPhoneController.text) {
      return true;
    } else {
      return false;
    }
  }

  dynamic callUpdateUserProfile(UserProvider userProvider) async {
    bool isSuccess = false;

    if (await Utils.checkInternetConnectivity()) {
      final ProfileUpdateParameterHolder profileUpdateParameterHolder =
          ProfileUpdateParameterHolder(
        userId: userProvider.psValueHolder.loginUserId,
        userName: userProvider.user.data.userName,
        userEmail: userEmailController.text,
        userPhone: userPhoneController.text,
        userAboutMe: userProvider.user.data.userAboutMe,
        billingFirstName: billingFirstNameController.text,
        billingLastName: billingLastNameController.text,
        billingCompany: billingCompanyController.text,
        billingAddress1: billingAddress1Controller.text,
        billingAddress2: billingAddress2Controller.text,
        billingCountry: billingCountryController.text,
        billingState: billingStateController.text,
        billingCity: billingCityController.text,
        billingPostalCode: billingPostalCodeController.text,
        billingEmail: billingEmailController.text,
        billingPhone: billingPhoneController.text,
        shippingFirstName: shippingFirstNameController.text,
        shippingLastName: shippingLastNameController.text,
        shippingCompany: shippingCompanyController.text,
        shippingAddress1: shippingAddress1Controller.text,
        shippingAddress2: shippingAddress2Controller.text,
        shippingCountry: userProvider.selectedCountry.name,
        shippingState: shippingStateController.text,
        shippingCity: userProvider.selectedCity.name,
        shippingPostalCode: shippingPostalCodeController.text,
        shippingEmail: shippingEmailController.text,
        shippingPhone: shippingPhoneController.text,
        countryId: userProvider.selectedCountry.id,
        cityId: userProvider.selectedCity.id,
      );
      final ProgressDialog progressDialog = loadingDialog(context);
      progressDialog.show();
      final PsResource<User> _apiStatus = await userProvider
          .postProfileUpdate(profileUpdateParameterHolder.toMap());
      if (_apiStatus.data != null) {
        progressDialog.hide();
        isSuccess = true;

        showDialog<dynamic>(
            context: context,
            builder: (BuildContext contet) {
              return SuccessDialog(
                message: Utils.getString(context, 'edit_profile__success'),
              );
            });
      } else {
        progressDialog.hide();

        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: _apiStatus.message,
              );
            });
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }

    return isSuccess;
  }
}
