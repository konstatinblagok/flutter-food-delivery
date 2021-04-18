import 'dart:convert';
import 'dart:io';

import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';

import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/user/user_provider.dart';
import 'package:fluttermultistoreflutter/repository/user_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/error_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/loading_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_button_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/fb_login_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/google_login_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/user_login_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  const LoginView({
    Key key,
    this.animationController,
    this.animation,
    this.onProfileSelected,
    this.onForgotPasswordSelected,
    this.onSignInSelected,
    this.onPhoneSignInSelected,
    this.onFbSignInSelected,
    this.onGoogleSignInSelected,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final Function onProfileSelected,
      onForgotPasswordSelected,
      onSignInSelected,
      onPhoneSignInSelected,
      onFbSignInSelected,
      onGoogleSignInSelected;
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserRepository repo1;
  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space28,
    );

    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, psValueHolder: psValueHolder);
        // provider.postUserLogin(userLoginParameterHolder.toMap());
        return provider;
      },
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget child) {
        return AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _HeaderIconAndTextWidget(),
                          _TextFieldAndSignInButtonWidget(
                            provider: provider,
                            text: Utils.getString(context, 'login__submit'),
                            onProfileSelected: widget.onProfileSelected,
                          ),
                          const SizedBox(
                            height: PsDimens.space8,
                          ),
                          
                          // Currently Facebook Login is still not available
                          // https://github.com/roughike/flutter_facebook_login/issues/231
                          if (Platform.isAndroid)
                            _LoginWithFbWidget(
                                userProvider: provider,
                                onFbSignInSelected: widget.onFbSignInSelected),
                          _spacingWidget,
                          _ForgotPasswordAndRegisterWidget(
                            provider: provider,
                            animationController: widget.animationController,
                            onForgotPasswordSelected:
                                widget.onForgotPasswordSelected,
                            onSignInSelected: widget.onSignInSelected,
                          ),
                          _spacingWidget,
                        ],
                      ),
                    )));
          },
        );
      }),
    ));
  }
}

class _TermsAndConCheckbox extends StatefulWidget {
  const _TermsAndConCheckbox(
      {@required this.provider, @required this.onCheckBoxClick});

  final UserProvider provider;
  final Function onCheckBoxClick;

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
            widget.onCheckBoxClick();
          },
        ),
        Expanded(
          child: InkWell(
            child: Text(Utils.getString(context, 'login__agree_privacy'),
                style: Theme.of(context).textTheme.body1),
            onTap: () {
              widget.onCheckBoxClick();
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(BuildContext context, UserProvider provider) {
  if (provider.isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
  } else {
    provider.isCheckBoxSelect = true;

    Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      Utils.getString(context, 'app_name'),
      style: Theme.of(context)
          .textTheme
          .subhead
          .copyWith(fontWeight: FontWeight.bold, color: PsColors.mainColor),
    );

    final Widget _imageWidget = Container(
      width: 90,
      height: 90,
      child: Image.asset(
        'assets/images/flutter_multi_store_icon.png',
      ),
    );
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space32,
        ),
        _imageWidget,
        const SizedBox(
          height: PsDimens.space8,
        ),
        _textWidget,
        const SizedBox(
          height: PsDimens.space52,
        ),
      ],
    );
  }
}

class _TextFieldAndSignInButtonWidget extends StatefulWidget {
  const _TextFieldAndSignInButtonWidget({
    @required this.provider,
    @required this.text,
    this.onProfileSelected,
  });

  final UserProvider provider;
  final String text;
  final Function onProfileSelected;

  @override
  __CardWidgetState createState() => __CardWidgetState();
}

class __CardWidgetState extends State<_TextFieldAndSignInButtonWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetsforCard = EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        top: PsDimens.space4,
        bottom: PsDimens.space4);
    return Column(
      children: <Widget>[
        Card(
          elevation: 0.3,
          margin: const EdgeInsets.only(
              left: PsDimens.space32, right: PsDimens.space32),
          child: Column(
            children: <Widget>[
              Container(
                margin: _marginEdgeInsetsforCard,
                child: TextField(
                  controller: emailController,
                  style: Theme.of(context).textTheme.body1.copyWith(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Utils.getString(context, 'login__email'),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: PsColors.textPrimaryLightColor),
                      icon: Icon(Icons.email,
                          color: Theme.of(context).iconTheme.color)),
                ),
              ),
              const Divider(
                height: PsDimens.space1,
              ),
              Container(
                margin: _marginEdgeInsetsforCard,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: Theme.of(context).textTheme.button.copyWith(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Utils.getString(context, 'login__password'),
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
        ),
        const SizedBox(
          height: PsDimens.space8,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space32, right: PsDimens.space32),
          child: PSButtonWidget(
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString(context, 'login__sign_in'),
            onPressed: () async {
              if (emailController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_email'));
              } else if (passwordController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_password'));
              } else {
                if (await Utils.checkInternetConnectivity()) {
                  final UserLoginParameterHolder userLoginParameterHolder =
                      UserLoginParameterHolder(
                    userEmail: emailController.text,
                    userPassword: passwordController.text,
                    deviceToken: widget.provider.psValueHolder.deviceToken,
                  );

                  final ProgressDialog progressDialog = loadingDialog(
                    context,
                  );
                  progressDialog.show();
                  final PsResource<User> _apiStatus = await widget.provider
                      .postUserLogin(userLoginParameterHolder.toMap());

                  if (_apiStatus.data != null) {
                    progressDialog.hide();

                    widget.provider.replaceVerifyUserData('', '', '', '');
                    widget.provider.replaceLoginUserId(_apiStatus.data.userId);

                    if (widget.onProfileSelected != null) {
                      await widget.provider
                          .replaceVerifyUserData('', '', '', '');
                      await widget.provider
                          .replaceLoginUserId(_apiStatus.data.userId);
                      await widget.onProfileSelected(_apiStatus.data.userId);
                    } else {
                      Navigator.pop(context, _apiStatus.data);
                    }
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
      ],
    );
  }
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

class _DividerORWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _dividerWidget = Expanded(
      child: Divider(
        height: PsDimens.space2,
        color: PsColors.white,
      ),
    );

    const Widget _spacingWidget = SizedBox(
      width: PsDimens.space8,
    );

    final Widget _textWidget =
        Text('OR', style: Theme.of(context).textTheme.subhead);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _dividerWidget,
        _spacingWidget,
        _textWidget,
        _spacingWidget,
        _dividerWidget,
      ],
    );
  }
}

class _LoginWithPhoneWidget extends StatefulWidget {
  const _LoginWithPhoneWidget(
      {@required this.onPhoneSignInSelected, @required this.provider});
  final Function onPhoneSignInSelected;
  final UserProvider provider;

  @override
  __LoginWithPhoneWidgetState createState() => __LoginWithPhoneWidgetState();
}

class __LoginWithPhoneWidgetState extends State<_LoginWithPhoneWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: PSButtonWithIconWidget(
        titleText: Utils.getString(context, 'login__phone_signin'),
        icon: Icons.phone,
        colorData: widget.provider.isCheckBoxSelect
            ? PsColors.mainColor
            : PsColors.grey,
        onPressed: () async {
          if (widget.provider.isCheckBoxSelect) {
            if (widget.onPhoneSignInSelected != null) {
              widget.onPhoneSignInSelected();
            } else {
              Navigator.pushReplacementNamed(
                context,
                RoutePaths.user_phone_signin_container,
              );
            }
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
      ),
    );
  }
}

class _LoginWithFbWidget extends StatefulWidget {
  const _LoginWithFbWidget(
      {@required this.userProvider, @required this.onFbSignInSelected});
  final UserProvider userProvider;
  final Function onFbSignInSelected;

  @override
  __LoginWithFbWidgetState createState() => __LoginWithFbWidgetState();
}

class __LoginWithFbWidgetState extends State<_LoginWithFbWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32,
          top: PsDimens.space8,
          right: PsDimens.space32),
      child: PSButtonWithIconWidget(
        titleText: Utils.getString(context, 'login__fb_signin'),
        icon: FontAwesome.facebook_official,
        colorData: widget.userProvider.isCheckBoxSelect == false
            ? PsColors.disabledFacebookLoginButtonColor
            : PsColors.facebookLoginButtonColor,
        onPressed: () async {
          if (widget.userProvider.isCheckBoxSelect) {
            //
            final FacebookLogin fbLogin = FacebookLogin();

            final dynamic result =
                await fbLogin.logIn(<String>['email', 'public_profile']);

            if (result.status == FacebookLoginStatus.loggedIn) {
              final FacebookAccessToken myToken = result.accessToken;
              FacebookAuthProvider.getCredential(accessToken: myToken.token);
              print(myToken.token);

              final String token = myToken.token;
              final dynamic graphResponse = await http.get(
                  'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
              final dynamic profile = json.decode(graphResponse.body);

              if (await Utils.checkInternetConnectivity()) {
                final FBLoginParameterHolder fbLoginParameterHolder =
                    FBLoginParameterHolder(
                        facebookId: profile['id'],
                        userName: profile['name'],
                        userEmail: profile['email'],
                        profilePhotoUrl: '',
                        deviceToken:
                            widget.userProvider.psValueHolder.deviceToken);

                final ProgressDialog progressDialog = loadingDialog(
                  context,
                );
                progressDialog.show();
                final PsResource<User> _apiStatus = await widget.userProvider
                    .postFBLogin(fbLoginParameterHolder.toMap());

                if (_apiStatus.data != null) {
                  widget.userProvider.replaceVerifyUserData('', '', '', '');
                  widget.userProvider
                      .replaceLoginUserId(_apiStatus.data.userId);

                  progressDialog.hide();
                  if (widget.onFbSignInSelected != null) {
                    widget.onFbSignInSelected(_apiStatus.data.userId);
                  } else {
                    Navigator.pop(context, _apiStatus.data);
                  }
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
      ),
    );
  }
}

class _LoginWithGoogleWidget extends StatefulWidget {
  const _LoginWithGoogleWidget(
      {@required this.userProvider, @required this.onGoogleSignInSelected});
  final UserProvider userProvider;
  final Function onGoogleSignInSelected;

  @override
  __LoginWithGoogleWidgetState createState() => __LoginWithGoogleWidgetState();
}

class __LoginWithGoogleWidgetState extends State<_LoginWithGoogleWidget> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<FirebaseUser> _handleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print('signed in' + user.displayName);
      return user;
    } catch (Exception) {
      print('not select google account');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32,
          top: PsDimens.space8,
          right: PsDimens.space32),
      child: PSButtonWithIconWidget(
        titleText: Utils.getString(context, 'login__google_signin'),
        icon: FontAwesome.google,
        colorData: widget.userProvider.isCheckBoxSelect
            ? PsColors.googleLoginButtonColor
            : PsColors.disabledGoogleLoginButtonColor,
        onPressed: () async {
          if (widget.userProvider.isCheckBoxSelect) {
            await _handleSignIn().then((FirebaseUser user) async {
              if (user != null) {
                if (await Utils.checkInternetConnectivity()) {
                  final GoogleLoginParameterHolder googleLoginParameterHolder =
                      GoogleLoginParameterHolder(
                          googleId: user.uid,
                          userName: user.displayName,
                          userEmail: user.email,
                          profilePhotoUrl: user.photoUrl,
                          deviceToken:
                              widget.userProvider.psValueHolder.deviceToken);

                  final ProgressDialog progressDialog = loadingDialog(
                    context,
                  );
                  progressDialog.show();
                  final PsResource<User> _apiStatus = await widget.userProvider
                      .postGoogleLogin(googleLoginParameterHolder.toMap());

                  if (_apiStatus.data != null) {
                    widget.userProvider.replaceVerifyUserData('', '', '', '');
                    widget.userProvider
                        .replaceLoginUserId(_apiStatus.data.userId);
                    progressDialog.hide();

                    if (widget.onGoogleSignInSelected != null) {
                      widget.onGoogleSignInSelected(_apiStatus.data.userId);
                    } else {
                      Navigator.pop(context, _apiStatus.data);
                    }
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
            });
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
      ),
    );
  }
}

class _ForgotPasswordAndRegisterWidget extends StatefulWidget {
  const _ForgotPasswordAndRegisterWidget(
      {Key key,
      this.provider,
      this.animationController,
      this.onForgotPasswordSelected,
      this.onSignInSelected})
      : super(key: key);

  final AnimationController animationController;
  final Function onForgotPasswordSelected;
  final Function onSignInSelected;
  final UserProvider provider;

  @override
  __ForgotPasswordAndRegisterWidgetState createState() =>
      __ForgotPasswordAndRegisterWidgetState();
}

class __ForgotPasswordAndRegisterWidgetState
    extends State<_ForgotPasswordAndRegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: PsDimens.space40),
      margin: const EdgeInsets.all(PsDimens.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: GestureDetector(
              child: Text(
                Utils.getString(context, 'login__forgot_password'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(
                      color: PsColors.mainColor,
                    ),
              ),
              onTap: () {
                if (widget.onForgotPasswordSelected != null) {
                  widget.onForgotPasswordSelected();
                } else {
                  Navigator.pushReplacementNamed(
                    context,
                    RoutePaths.user_forgot_password_container,
                  );
                }
              },
            ),
          ),
          Flexible(
            child: GestureDetector(
              child: Text(
                Utils.getString(context, 'login__sign_up'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(
                      color: PsColors.mainColor,
                    ),
              ),
              onTap: () async {
                if (widget.onSignInSelected != null) {
                  widget.onSignInSelected();
                } else {
                  final dynamic returnData =
                      await Navigator.pushReplacementNamed(
                    context,
                    RoutePaths.user_register_container,
                  );
                  if (returnData != null && returnData is User) {
                    final User user = returnData;
                    widget.provider.psValueHolder =
                        Provider.of<PsValueHolder>(context);
                    widget.provider.psValueHolder.loginUserId = user.userId;
                    widget.provider.psValueHolder.userIdToVerify = '';
                    widget.provider.psValueHolder.userNameToVerify = '';
                    widget.provider.psValueHolder.userEmailToVerify = '';
                    widget.provider.psValueHolder.userPasswordToVerify = '';
                    Navigator.pop(context, user);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
