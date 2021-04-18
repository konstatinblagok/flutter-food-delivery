import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';

import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/user/user_provider.dart';
import 'package:fluttermultistoreflutter/repository/user_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/error_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_button_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/user_register_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView(
      {Key key,
      this.animationController,
      this.onRegisterSelected,
      this.goToLoginSelected})
      : super(key: key);
  final AnimationController animationController;
  final Function onRegisterSelected, goToLoginSelected;
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  UserRepository repo1;
  PsValueHolder valueHolder;
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    // nameController.dispose();
    // emailController.dispose();
    // passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();

    repo1 = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
        create: (BuildContext context) {
          final UserProvider provider =
              UserProvider(repo: repo1, psValueHolder: valueHolder);

          return provider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget child) {
          nameController = TextEditingController(
              text: provider.psValueHolder.userNameToVerify);
          emailController = TextEditingController(
              text: provider.psValueHolder.userEmailToVerify);
          passwordController = TextEditingController(
              text: provider.psValueHolder.userPasswordToVerify);

          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget child) {
                        return FadeTransition(
                            opacity: animation,
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  0.0, 100 * (1.0 - animation.value), 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  _HeaderIconAndTextWidget(),
                                  _TextFieldWidget(
                                    nameText: nameController,
                                    emailText: emailController,
                                    passwordText: passwordController,
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space8,
                                  ),
                                  _TermsAndConCheckbox(
                                    provider: provider,
                                    nameTextEditingController: nameController,
                                    emailTextEditingController: emailController,
                                    passwordTextEditingController:
                                        passwordController,
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space8,
                                  ),
                                  _SignInButtonWidget(
                                    provider: provider,
                                    nameTextEditingController: nameController,
                                    emailTextEditingController: emailController,
                                    passwordTextEditingController:
                                        passwordController,
                                    onRegisterSelected:
                                        widget.onRegisterSelected,
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space16,
                                  ),
                                  _TextWidget(
                                    goToLoginSelected: widget.goToLoginSelected,
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space64,
                                  ),
                                ],
                              ),
                            ));
                      }))
            ],
          );
        }),
      ),
    );
  }
}

class _TermsAndConCheckbox extends StatefulWidget {
  const _TermsAndConCheckbox({
    @required this.provider,
    @required this.nameTextEditingController,
    @required this.emailTextEditingController,
    @required this.passwordTextEditingController,
  });

  final UserProvider provider;
  final TextEditingController nameTextEditingController,
      emailTextEditingController,
      passwordTextEditingController;
  @override
  __TermsAndConCheckboxState createState() => __TermsAndConCheckboxState();
}

class __TermsAndConCheckboxState extends State<_TermsAndConCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: PsDimens.space20,
        ),
        Checkbox(
          activeColor: PsColors.mainColor,
          value: widget.provider.isCheckBoxSelect,
          onChanged: (bool value) {
            setState(() {
              updateCheckBox(
                  widget.provider.isCheckBoxSelect,
                  context,
                  widget.provider,
                  widget.nameTextEditingController,
                  widget.emailTextEditingController,
                  widget.passwordTextEditingController);
            });
          },
        ),
        Expanded(
          child: InkWell(
            child: Text(
              Utils.getString(context, 'login__agree_privacy'),
              style: Theme.of(context).textTheme.body1.copyWith(),
            ),
            onTap: () {
              setState(() {
                updateCheckBox(
                    widget.provider.isCheckBoxSelect,
                    context,
                    widget.provider,
                    widget.nameTextEditingController,
                    widget.emailTextEditingController,
                    widget.passwordTextEditingController);
              });
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(
    bool isCheckBoxSelect,
    BuildContext context,
    UserProvider provider,
    TextEditingController nameTextEditingController,
    TextEditingController emailTextEditingController,
    TextEditingController passwordTextEditingController) {
  if (isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
  } else {
    provider.isCheckBoxSelect = true;
    //it is for holder
    provider.psValueHolder.userNameToVerify = nameTextEditingController.text;
    provider.psValueHolder.userEmailToVerify = emailTextEditingController.text;
    provider.psValueHolder.userPasswordToVerify =
        passwordTextEditingController.text;
    Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}

class _TextWidget extends StatefulWidget {
  const _TextWidget({this.goToLoginSelected});
  final Function goToLoginSelected;
  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends State<_TextWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        Utils.getString(context, 'register__login'),
        style: Theme.of(context)
            .textTheme
            .body1
            .copyWith(color: PsColors.mainColor),
      ),
      onTap: () {
        if (widget.goToLoginSelected != null) {
          widget.goToLoginSelected();
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.login_container,
          );
        }
      },
    );
  }
}

class _TextFieldWidget extends StatefulWidget {
  const _TextFieldWidget({
    @required this.nameText,
    @required this.emailText,
    @required this.passwordText,
  });

  final TextEditingController nameText, emailText, passwordText;
  @override
  __TextFieldWidgetState createState() => __TextFieldWidgetState();
}

class __TextFieldWidgetState extends State<_TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetWidget = EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        top: PsDimens.space4,
        bottom: PsDimens.space4);

    const Widget _dividerWidget = Divider(
      height: PsDimens.space1,
    );
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: Column(
        children: <Widget>[
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.nameText,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__user_name'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: PsColors.textPrimaryLightColor),
                  icon: Icon(Icons.people,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          _dividerWidget,
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.emailText,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__email'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: PsColors.textPrimaryLightColor),
                  icon: Icon(Icons.email,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          _dividerWidget,
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.passwordText,
              obscureText: true,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__password'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: PsColors.textPrimaryLightColor),
                  icon: Icon(Icons.lock,
                      color: Theme.of(context).iconTheme.color)),
              // keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space32,
        ),
        Container(
          width: 90,
          height: 90,
          child: Image.asset(
            'assets/images/flutter_multi_store_icon.png',
          ),
        ),
        const SizedBox(
          height: PsDimens.space8,
        ),
        Text(
          Utils.getString(context, 'app_name'),
          style: Theme.of(context).textTheme.subhead.copyWith(
                color: PsColors.mainColor,
              ),
        ),
        const SizedBox(
          height: PsDimens.space52,
        ),
      ],
    );
  }
}

class _SignInButtonWidget extends StatefulWidget {
  const _SignInButtonWidget(
      {@required this.provider,
      @required this.nameTextEditingController,
      @required this.emailTextEditingController,
      @required this.passwordTextEditingController,
      this.onRegisterSelected});
  final UserProvider provider;
  final Function onRegisterSelected;
  final TextEditingController nameTextEditingController,
      emailTextEditingController,
      passwordTextEditingController;

  @override
  __SignInButtonWidgetState createState() => __SignInButtonWidgetState();
}

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          message: Utils.getString(context, text),
        );
      });
}

class __SignInButtonWidgetState extends State<_SignInButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space32, right: PsDimens.space32),
        child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'register__register'),
          onPressed: () async {
            if (widget.provider.isCheckBoxSelect) {
              //
              if (widget.nameTextEditingController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_name'));
              } else if (widget.emailTextEditingController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_email'));
              } else if (widget.passwordTextEditingController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_password'));
              } else {
                if (await Utils.checkInternetConnectivity()) {
                  final UserRegisterParameterHolder
                      userRegisterParameterHolder = UserRegisterParameterHolder(
                    userId: '',
                    userName: widget.nameTextEditingController.text,
                    userEmail: widget.emailTextEditingController.text,
                    userPassword: widget.passwordTextEditingController.text,
                    userPhone: '',
                    deviceToken: widget.provider.psValueHolder.deviceToken,
                  );

                  final PsResource<User> _apiStatus = await widget.provider
                      .postUserRegister(userRegisterParameterHolder.toMap());

                  if (_apiStatus.data != null) {
                    final User user = _apiStatus.data;

                    //verify
                    await widget.provider.replaceVerifyUserData(
                        _apiStatus.data.userId,
                        _apiStatus.data.userName,
                        _apiStatus.data.userEmail,
                        widget.passwordTextEditingController.text);

                    widget.provider.psValueHolder.userIdToVerify = user.userId;
                    widget.provider.psValueHolder.userNameToVerify =
                        user.userName;
                    widget.provider.psValueHolder.userEmailToVerify =
                        user.userEmail;
                    widget.provider.psValueHolder.userPasswordToVerify =
                        user.userPassword;

                    //
                    if (widget.onRegisterSelected != null) {
                      await widget.onRegisterSelected(_apiStatus.data.userId);
                    } else {
                      final dynamic returnData = await Navigator.pushNamed(
                          context, RoutePaths.user_verify_email_container,
                          arguments: _apiStatus.data.userId);

                      if (returnData != null && returnData is User) {
                        final User user = returnData;
                        if (Provider != null && Provider.of != null) {
                          widget.provider.psValueHolder =
                              Provider.of<PsValueHolder>(context);
                        }
                        widget.provider.psValueHolder.loginUserId = user.userId;
                        widget.provider.psValueHolder.userIdToVerify = '';
                        widget.provider.psValueHolder.userNameToVerify = '';
                        widget.provider.psValueHolder.userEmailToVerify = '';
                        widget.provider.psValueHolder.userPasswordToVerify = '';
                        print(user.userId);
                        Navigator.of(context).pop();
                      }
                    }
                  } else {
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
              //
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'login__warning_agree_privacy'),
                    );
                  });
            }
          },
        ));
  }
}
