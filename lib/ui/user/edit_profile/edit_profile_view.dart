import 'dart:io';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/user/user_provider.dart';
import 'package:fluttermultistoreflutter/repository/user_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_appbar.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_button_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_textfield_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/error_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/loading_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/success_dialog.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/profile_update_view_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;
  UserProvider userProvider;
  PsValueHolder psValueHolder;
  AnimationController animationController;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController shippingfirstNameController =
      TextEditingController();
  final TextEditingController shippingLastNameController =
      TextEditingController();
  final TextEditingController shippingEmailController = TextEditingController();
  final TextEditingController shippingPhoneController = TextEditingController();
  final TextEditingController shippingCompanyNameController =
      TextEditingController();
  final TextEditingController shippingAddress1Controller =
      TextEditingController();
  final TextEditingController shippingAddress2Controller =
      TextEditingController();
  TextEditingController shippingStateController = TextEditingController();
  final TextEditingController shippingPostalCodeController =
      TextEditingController();
  final TextEditingController billingfirstNameController =
      TextEditingController();
  final TextEditingController billingLastNameController =
      TextEditingController();
  final TextEditingController billingEmailController = TextEditingController();
  final TextEditingController billingPhoneController = TextEditingController();
  final TextEditingController billingCompanyNameController =
      TextEditingController();
  final TextEditingController billingAddress1Controller =
      TextEditingController();
  final TextEditingController billingAddress2Controller =
      TextEditingController();
  final TextEditingController billingStateController = TextEditingController();
  final TextEditingController billingPostalCodeController =
      TextEditingController();
  bool bindDataFirstTime = true;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBar<UserProvider>(
            appBarTitle: Utils.getString(context, 'edit_profile__title') ?? '',
            initProvider: () {
              return UserProvider(
                  repo: userRepository, psValueHolder: psValueHolder);
            },
            onProviderReady: (UserProvider provider) async {
              await provider.getUserFromDB(provider.psValueHolder.loginUserId);
              userProvider = provider;
            },
            builder:
                (BuildContext context, UserProvider provider, Widget child) {
              if (userProvider != null &&
                  userProvider.user != null &&
                  userProvider.user.data != null) {
                if (bindDataFirstTime) {
                  userNameController.text = userProvider.user.data.userName;
                  emailController.text = userProvider.user.data.userEmail;
                  phoneController.text = userProvider.user.data.userPhone;
                  aboutMeController.text = userProvider.user.data.userAboutMe;
                  userProvider.selectedCountry = userProvider.user.data.country;
                  userProvider.selectedCity = userProvider.user.data.city;

                  /// Shipping Data
                  shippingfirstNameController.text =
                      userProvider.user.data.shippingFirstName;
                  shippingLastNameController.text =
                      userProvider.user.data.shippingLastName;
                  shippingEmailController.text =
                      userProvider.user.data.shippingEmail;
                  shippingPhoneController.text =
                      userProvider.user.data.shippingPhone;
                  shippingCompanyNameController.text =
                      userProvider.user.data.shippingCompany;
                  shippingAddress1Controller.text =
                      userProvider.user.data.shippingAddress_1;
                  shippingAddress2Controller.text =
                      userProvider.user.data.shippingAddress_2;
                  // shippingCountryController.text =
                  //     userProvider.user.data.shippingCountry;
                  shippingStateController.text =
                      userProvider.user.data.shippingState;
                  // shippingCityController.text =
                  //     userProvider.user.data.shippingCity;
                  shippingPostalCodeController.text =
                      userProvider.user.data.shippingPostalCode;

                  /// Billing Data
                  billingfirstNameController.text =
                      userProvider.user.data.billingFirstName;
                  billingLastNameController.text =
                      userProvider.user.data.billingLastName;
                  billingEmailController.text =
                      userProvider.user.data.billingEmail;
                  billingPhoneController.text =
                      userProvider.user.data.billingPhone;
                  billingCompanyNameController.text =
                      userProvider.user.data.billingCompany;
                  billingAddress1Controller.text =
                      userProvider.user.data.billingAddress_1;
                  billingAddress2Controller.text =
                      userProvider.user.data.billingAddress_2;
                  billingStateController.text =
                      userProvider.user.data.billingState;
                  billingPostalCodeController.text =
                      userProvider.user.data.billingPostalCode;
                  bindDataFirstTime = false;
                }

                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _ImageWidget(userProvider: userProvider),
                      _UserFirstCardWidget(
                        userNameController: userNameController,
                        emailController: emailController,
                        phoneController: phoneController,
                        aboutMeController: aboutMeController,
                      ),
                      _ShippingAddressCardWidget(
                        userProvider: userProvider,
                        shippingfirstNameController:
                            shippingfirstNameController,
                        shippingLastNameController: shippingLastNameController,
                        shippingEmailController: shippingEmailController,
                        shippingPhoneController: shippingPhoneController,
                        shippingCompanyNameController:
                            shippingCompanyNameController,
                        shippingAddress1Controller: shippingAddress1Controller,
                        shippingAddress2Controller: shippingAddress2Controller,
                        shippingStateController: shippingStateController,
                        shippingPostalCodeController:
                            shippingPostalCodeController,
                      ),
                      _BillingAddressCardWidget(
                        billingfirstNameController: billingfirstNameController,
                        billingLastNameController: billingLastNameController,
                        billingEmailController: billingEmailController,
                        billingPhoneController: billingPhoneController,
                        billingCompanyNameController:
                            billingCompanyNameController,
                        billingAddress1Controller: billingAddress1Controller,
                        billingAddress2Controller: billingAddress2Controller,
                        billingStateController: billingStateController,
                        billingPostalCodeController:
                            billingPostalCodeController,
                        // billingCityNameController: billingCityNameController,
                        userProvider: userProvider,
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      _TwoButtonWidget(
                        userProvider: userProvider,
                        userNameController: userNameController,
                        emailController: emailController,
                        phoneController: phoneController,
                        aboutMeController: aboutMeController,
                        shippingfirstNameController:
                            shippingfirstNameController,
                        shippingLastNameController: shippingLastNameController,
                        shippingEmailController: shippingEmailController,
                        shippingPhoneController: shippingPhoneController,
                        shippingCompanyNameController:
                            shippingCompanyNameController,
                        shippingAddress1Controller: shippingAddress1Controller,
                        shippingAddress2Controller: shippingAddress2Controller,
                        shippingStateController: shippingStateController,
                        shippingPostalCodeController:
                            shippingPostalCodeController,
                        billingfirstNameController: billingfirstNameController,
                        billingLastNameController: billingLastNameController,
                        billingEmailController: billingEmailController,
                        billingPhoneController: billingPhoneController,
                        billingCompanyNameController:
                            billingCompanyNameController,
                        billingAddress1Controller: billingAddress1Controller,
                        billingAddress2Controller: billingAddress2Controller,
                        billingStateController: billingStateController,
                        billingPostalCodeController:
                            billingPostalCodeController,
                      ),
                      const SizedBox(
                        height: PsDimens.space20,
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }));
  }
}

class _TwoButtonWidget extends StatelessWidget {
  const _TwoButtonWidget({
    @required this.userProvider,
    @required this.userNameController,
    @required this.emailController,
    @required this.phoneController,
    @required this.aboutMeController,
    @required this.billingfirstNameController,
    @required this.billingLastNameController,
    @required this.billingEmailController,
    @required this.billingPhoneController,
    @required this.billingCompanyNameController,
    @required this.billingAddress1Controller,
    @required this.billingAddress2Controller,
    @required this.billingStateController,
    @required this.billingPostalCodeController,
    @required this.shippingfirstNameController,
    @required this.shippingLastNameController,
    @required this.shippingEmailController,
    @required this.shippingPhoneController,
    @required this.shippingCompanyNameController,
    @required this.shippingAddress1Controller,
    @required this.shippingAddress2Controller,
    @required this.shippingStateController,
    @required this.shippingPostalCodeController,
  });

  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController aboutMeController;
  final TextEditingController billingfirstNameController;
  final TextEditingController billingLastNameController;
  final TextEditingController billingEmailController;
  final TextEditingController billingPhoneController;
  final TextEditingController billingCompanyNameController;
  final TextEditingController billingAddress1Controller;
  final TextEditingController billingAddress2Controller;
  final TextEditingController billingStateController;
  final TextEditingController billingPostalCodeController;
  final TextEditingController shippingfirstNameController;
  final TextEditingController shippingLastNameController;
  final TextEditingController shippingEmailController;
  final TextEditingController shippingPhoneController;
  final TextEditingController shippingCompanyNameController;
  final TextEditingController shippingAddress1Controller;
  final TextEditingController shippingAddress2Controller;
  final TextEditingController shippingStateController;
  final TextEditingController shippingPostalCodeController;
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12, right: PsDimens.space12),
          child: PSButtonWidget(
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString(context, 'edit_profile__save'),
            onPressed: () async {
              if (userNameController.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'edit_profile__name_error'),
                      );
                    });
              } else if (emailController.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'edit_profile__email_error'),
                      );
                    });
              } else {
                if (await Utils.checkInternetConnectivity()) {
                  final ProfileUpdateParameterHolder
                      profileUpdateParameterHolder =
                      ProfileUpdateParameterHolder(
                    userId: userProvider.user.data.userId,
                    userName: userNameController.text,
                    userEmail: emailController.text,
                    userPhone: phoneController.text,
                    userAboutMe: aboutMeController.text,
                    billingFirstName: billingfirstNameController.text,
                    billingLastName: billingLastNameController.text,
                    billingCompany: billingCompanyNameController.text,
                    billingAddress1: billingAddress1Controller.text,
                    billingAddress2: billingAddress2Controller.text,
                    billingCountry: '',
                    billingState: billingStateController.text,
                    billingCity: '',
                    billingPostalCode: billingPostalCodeController.text,
                    billingEmail: billingEmailController.text,
                    billingPhone: billingPhoneController.text,
                    shippingFirstName: shippingfirstNameController.text,
                    shippingLastName: shippingLastNameController.text,
                    shippingCompany: shippingCompanyNameController.text,
                    shippingAddress1: shippingAddress1Controller.text,
                    shippingAddress2: shippingAddress2Controller.text,
                    shippingCountry: '',
                    shippingState: shippingStateController.text,
                    shippingCity: '',
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

                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext contet) {
                          return SuccessDialog(
                            message: Utils.getString(
                                context, 'edit_profile__success'),
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
                          message: Utils.getString(
                              context, 'error_dialog__no_internet'),
                        );
                      });
                }
              }
            },
          ),
        ),
        const SizedBox(
          height: PsDimens.space12,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              right: PsDimens.space12,
              bottom: PsDimens.space20),
          child: PSButtonWidget(
            hasShadow: false,
            colorData: PsColors.grey,
            width: double.infinity,
            titleText:
                Utils.getString(context, 'edit_profile__password_change'),
            onPressed: () {
              Navigator.pushNamed(
                context,
                RoutePaths.user_update_password,
              );
            },
          ),
        )
      ],
    );
  }
}

class _ImageWidget extends StatefulWidget {
  const _ImageWidget({this.userProvider});
  final UserProvider userProvider;

  @override
  __ImageWidgetState createState() => __ImageWidgetState();
}

File pickedImage;

class __ImageWidgetState extends State<_ImageWidget> {
  Future<bool> requestGalleryPermission() async {
    final Map<PermissionGroup, PermissionStatus> permissionss =
        await PermissionHandler()
            .requestPermissions(<PermissionGroup>[PermissionGroup.photos]);
    if (permissionss != null &&
        permissionss.isNotEmpty &&
        permissionss[PermissionGroup.photos] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic _pickImage() async {
      final ImageSource imageSource = await showDialog<ImageSource>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text(
                    Utils.getString(context, 'edit_profile__select_image')),
                actions: <Widget>[
                  // MaterialButton(
                  //   child: const Text('Camera'),
                  //   onPressed: () => Navigator.pop(context, ImageSource.camera),
                  // ),
                  MaterialButton(
                    child:
                        Text(Utils.getString(context, 'edit_profile__gallery')),
                    onPressed: () =>
                        Navigator.pop(context, ImageSource.gallery),
                  )
                ],
              ));

      if (imageSource != null) {
        if (ImagePicker != null &&
            ImagePicker.pickImage != null &&
            imageSource == ImageSource.gallery) {
          final File file = await ImagePicker.pickImage(source: imageSource);
          if (file != null) {
            final ProgressDialog pr = loadingDialog(context);
            pr.show();
            final PsResource<User> _apiStatus = await widget.userProvider
                .postImageUpload(widget.userProvider.psValueHolder.loginUserId,
                    PsConst.PLATFORM, file);

            if (_apiStatus.data != null) {
              pr.hide();
              pr.hide();
              setState(() {
                pickedImage = file;
              });
            }
          }
        } else {
          pickedImage = File(''); //for not select any image from gallery

          if (pr != null) {
            pr.hide();
            pr.hide();
          }
        }
      }
    }

    final Widget _imageWidget = PsNetworkImageWithUrl(
      photoKey: '',
      imagePath: widget.userProvider.user.data.userProfilePhoto,
      width: double.infinity,
      height: PsDimens.space200,
      boxfit: BoxFit.cover,
      onTap: () {},
    );

    final Widget _editWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () async {
          if (await Utils.checkInternetConnectivity()) {
            requestGalleryPermission().then((bool status) async {
              if (status) {
                await _pickImage();
              }
            });
          } else {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message:
                        Utils.getString(context, 'error_dialog__no_internet'),
                  );
                });
          }
        },
      ),
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: PsColors.mainColor),
        color: PsColors.backgroundColor,
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

    final Widget _imageInCenterWidget = Positioned(
        top: 110,
        child: Stack(
          children: <Widget>[
            Container(
                width: 90,
                height: 90,
                child: CircleAvatar(
                  child: PsNetworkCircleImage(
                    photoKey: '',
                    imagePath: widget.userProvider.user.data.userProfilePhoto,
                    width: double.infinity,
                    height: PsDimens.space200,
                    boxfit: BoxFit.cover,
                    onTap: () async {
                      if (await Utils.checkInternetConnectivity()) {
                        requestGalleryPermission().then((bool status) async {
                          if (status) {
                            await _pickImage();
                          }
                        });
                      } else {
                        showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorDialog(
                                message: Utils.getString(
                                    context, 'error_dialog__no_internet'),
                              );
                            });
                      }
                    },
                  ),
                )),
            Positioned(
              top: 1,
              right: 1,
              child: _editWidget,
            ),
          ],
        ));
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: PsDimens.space160,
          child: _imageWidget,
        ),
        Container(
          color: PsColors.white.withAlpha(100),
          width: double.infinity,
          height: PsDimens.space160,
        ),
        Container(
          // color: PsColors.white38,
          width: double.infinity,
          height: PsDimens.space220,
        ),
        _imageInCenterWidget,
      ],
    );
  }
}

class _UserFirstCardWidget extends StatelessWidget {
  const _UserFirstCardWidget(
      {@required this.userNameController,
      @required this.emailController,
      @required this.phoneController,
      @required this.aboutMeController});
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController aboutMeController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.backgroundColor,
      padding:
          const EdgeInsets.only(left: PsDimens.space8, right: PsDimens.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: PsDimens.space16,
          ),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__user_name'),
              hintText: Utils.getString(context, 'edit_profile__user_name'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: userNameController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__email'),
              hintText: Utils.getString(context, 'edit_profile__email'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: emailController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__phone'),
              textAboutMe: false,
              phoneInputType: true,
              hintText: Utils.getString(context, 'edit_profile__phone'),
              textEditingController: phoneController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__about_me'),
              height: PsDimens.space120,
              keyboardType: TextInputType.multiline,
              textAboutMe: true,
              phoneInputType: false,
              hintText: Utils.getString(context, 'edit_profile__about_me'),
              textEditingController: aboutMeController),
        ],
      ),
    );
  }
}

class _ShippingAddressCardWidget extends StatefulWidget {
  const _ShippingAddressCardWidget({
    @required this.userProvider,
    @required this.shippingfirstNameController,
    @required this.shippingLastNameController,
    @required this.shippingEmailController,
    @required this.shippingPhoneController,
    @required this.shippingCompanyNameController,
    @required this.shippingAddress1Controller,
    @required this.shippingAddress2Controller,
    @required this.shippingStateController,
    // @required this.shippingCountryController,
    // @required this.shippingCityController,
    @required this.shippingPostalCodeController,
  });
  final UserProvider userProvider;
  final TextEditingController shippingfirstNameController;
  final TextEditingController shippingLastNameController;
  final TextEditingController shippingEmailController;
  final TextEditingController shippingPhoneController;
  final TextEditingController shippingCompanyNameController;
  final TextEditingController shippingAddress1Controller;
  final TextEditingController shippingAddress2Controller;
  final TextEditingController shippingStateController;
  // final TextEditingController shippingCountryController;
  // final TextEditingController shippingCityController;
  final TextEditingController shippingPostalCodeController;

  @override
  __ShippingAddressCardWidgetState createState() =>
      __ShippingAddressCardWidgetState();
}

class __ShippingAddressCardWidgetState
    extends State<_ShippingAddressCardWidget> {
  String countryId;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.backgroundColor,
      padding:
          const EdgeInsets.only(left: PsDimens.space8, right: PsDimens.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space12,
                right: PsDimens.space12,
                top: PsDimens.space16),
            child: Text(
              Utils.getString(context, 'checkout1__shipping_address'),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__first_name'),
              hintText: Utils.getString(context, 'edit_profile__first_name'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.shippingfirstNameController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__last_name'),
              hintText: Utils.getString(context, 'edit_profile__last_name'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.shippingLastNameController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__email'),
              hintText: Utils.getString(context, 'edit_profile__email'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.shippingEmailController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__phone'),
              textAboutMe: false,
              phoneInputType: true,
              hintText: Utils.getString(context, 'edit_profile__phone'),
              textEditingController: widget.shippingPhoneController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__company_name'),
              hintText: Utils.getString(context, 'edit_profile__company_name'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.shippingCompanyNameController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__address1'),
              height: PsDimens.space120,
              keyboardType: TextInputType.multiline,
              textAboutMe: true,
              phoneInputType: false,
              hintText: Utils.getString(context, 'edit_profile__address1'),
              textEditingController: widget.shippingAddress1Controller),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__address2'),
              height: PsDimens.space120,
              keyboardType: TextInputType.multiline,
              textAboutMe: true,
              phoneInputType: false,
              hintText: Utils.getString(context, 'edit_profile__address2'),
              textEditingController: widget.shippingAddress2Controller),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__state_name'),
              hintText: Utils.getString(context, 'edit_profile__state_name'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.shippingStateController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__postal_code'),
              hintText: Utils.getString(context, 'edit_profile__postal_code'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.shippingPostalCodeController),
          const SizedBox(
            height: PsDimens.space12,
          )
        ],
      ),
    );
  }
}

class _BillingAddressCardWidget extends StatefulWidget {
  const _BillingAddressCardWidget({
    @required this.billingfirstNameController,
    @required this.billingLastNameController,
    @required this.billingEmailController,
    @required this.billingPhoneController,
    @required this.billingCompanyNameController,
    @required this.billingAddress1Controller,
    @required this.billingAddress2Controller,
    @required this.billingStateController,
    @required this.billingPostalCodeController,
    // @required this.billingCityNameController,
    @required this.userProvider,
  });
  final TextEditingController billingfirstNameController;
  final TextEditingController billingLastNameController;
  final TextEditingController billingEmailController;
  final TextEditingController billingPhoneController;
  final TextEditingController billingCompanyNameController;
  final TextEditingController billingAddress1Controller;
  final TextEditingController billingAddress2Controller;
  final TextEditingController billingStateController;
  final TextEditingController billingPostalCodeController;
  // final TextEditingController billingCityNameController;
  final UserProvider userProvider;

  @override
  __BillingAddressCardWidgetState createState() =>
      __BillingAddressCardWidgetState();
}

class __BillingAddressCardWidgetState extends State<_BillingAddressCardWidget> {
  String countryId;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.backgroundColor,
      margin: const EdgeInsets.only(top: PsDimens.space12),
      padding: const EdgeInsets.only(
        left: PsDimens.space8,
        right: PsDimens.space8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space12,
                right: PsDimens.space12,
                top: PsDimens.space16),
            child: Text(
              Utils.getString(context, 'checkout1__billing_address'),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__first_name'),
              hintText: Utils.getString(context, 'edit_profile__first_name'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.billingfirstNameController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__last_name'),
              hintText: Utils.getString(context, 'edit_profile__last_name'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.billingLastNameController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__email'),
              hintText: Utils.getString(context, 'edit_profile__email'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.billingEmailController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__phone'),
              textAboutMe: false,
              phoneInputType: true,
              hintText: Utils.getString(context, 'edit_profile__phone'),
              textEditingController: widget.billingPhoneController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__company_name'),
              hintText: Utils.getString(context, 'edit_profile__company_name'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.billingCompanyNameController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__address1'),
              height: PsDimens.space120,
              keyboardType: TextInputType.multiline,
              textAboutMe: true,
              phoneInputType: false,
              hintText: Utils.getString(context, 'edit_profile__address1'),
              textEditingController: widget.billingAddress1Controller),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__address2'),
              height: PsDimens.space120,
              keyboardType: TextInputType.multiline,
              textAboutMe: true,
              phoneInputType: false,
              hintText: Utils.getString(context, 'edit_profile__address2'),
              textEditingController: widget.billingAddress2Controller),
          // PsDropdownBaseWidget(
          //     title: Utils.getString(context, 'edit_profile__country_name'),
          //     selectedText: widget.userProvider.user.data.billingCountry,
          //     onTap: () async {
          //       final dynamic result =
          //           await Navigator.pushNamed(context, RoutePaths.countryList);

          //       if (result != null && result is ShippingCountry) {
          //         setState(() {
          //           countryId = result.id;
          //           widget.userProvider.user.data.billingCountry = result.name;
          //           widget.userProvider.user.data.billingCity = '';
          //         });
          //       }
          //     }),

          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__state_name'),
              hintText: Utils.getString(context, 'edit_profile__state_name'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.billingStateController),
          // PsDropdownBaseWidget(
          //     title: Utils.getString(context, 'edit_profile__city_name'),
          //     selectedText: widget.userProvider.user.data.billingCity,
          //     onTap: () async {
          //       if (countryId != null) {
          //         final dynamic result = await Navigator.pushNamed(
          //             context, RoutePaths.cityList,
          //             arguments: countryId);

          //         if (result != null && result is ShippingCity) {
          //           setState(() {
          //             widget.userProvider.user.data.billingCity = result.name;
          //           });
          //         }
          //       } else {
          //         showDialog<dynamic>(
          //             context: context,
          //             builder: (BuildContext context) {
          //               return WarningDialog(
          //                 message: Utils.getString(
          //                     context, 'edit_profile__selected_country'),
          //               );
          //             });
          //       }
          //     }),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__postal_code'),
              hintText: Utils.getString(context, 'edit_profile__postal_code'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: widget.billingPostalCodeController),
        ],
      ),
    );
  }
}
