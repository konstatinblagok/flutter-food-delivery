import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/provider/common/notification_provider.dart';
import 'package:fluttermultistoreflutter/repository/Common/notification_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_appbar.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/noti_register_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/noti_unregister_holder.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class NotificationSettingView extends StatefulWidget {
  @override
  _NotificationSettingViewState createState() =>
      _NotificationSettingViewState();
}

NotificationRepository notiRepository;
NotificationProvider notiProvider;
PsValueHolder _psValueHolder;
final FirebaseMessaging _fcm = FirebaseMessaging();

class _NotificationSettingViewState extends State<NotificationSettingView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    notiRepository = Provider.of<NotificationRepository>(context);
    _psValueHolder = Provider.of<PsValueHolder>(context);

    print(
        '............................Build UI Again ...........................');

    return PsWidgetWithAppBar<NotificationProvider>(
        appBarTitle:
            Utils.getString(context, 'noti_setting__toolbar_name') ?? '',
        initProvider: () {
          return NotificationProvider(
              repo: notiRepository, psValueHolder: _psValueHolder);
        },
        onProviderReady: (NotificationProvider provider) {
          notiProvider = provider;
        },
        builder: (BuildContext context, NotificationProvider provider,
            Widget child) {
          return _NotificationSettingWidget(notiProvider: provider);
        });
  }
}

class _NotificationSettingWidget extends StatefulWidget {
  const _NotificationSettingWidget({this.notiProvider});
  final NotificationProvider notiProvider;
  @override
  __NotificationSettingWidgetState createState() =>
      __NotificationSettingWidgetState();
}

class __NotificationSettingWidgetState
    extends State<_NotificationSettingWidget> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    if (notiProvider.psValueHolder.notiSetting != null) {
      isSwitched = notiProvider.psValueHolder.notiSetting;
    }
    // final Widget _switchButtonwidget = Switch(
    //     value: isSwitched,
    //     onChanged: (bool value) async {
    //       setState(() {
    //         isSwitched = value;
    //         notiProvider.replaceNotiSetting(value);
    //       });

    //       if (isSwitched == true) {
    //         _fcm.subscribeToTopic('broadcast');
    //         if (notiProvider.psValueHolder.deviceToken != null &&
    //             notiProvider.psValueHolder.deviceToken != '') {
    //           final NotiRegisterParameterHolder notiRegisterParameterHolder =
    //               NotiRegisterParameterHolder(
    //                   platformName: PsConst.PLATFORM,
    //                   deviceId: notiProvider.psValueHolder.deviceToken,
    //                   loginUserId: await Utils.checkUserLoginId(
    //                       notiProvider.psValueHolder));
    //           notiProvider
    //               .rawRegisterNotiToken(notiRegisterParameterHolder.toMap());
    //         }
    //       } else {
    //         _fcm.unsubscribeFromTopic('broadcast');
    //         if (notiProvider.psValueHolder.deviceToken != null &&
    //             notiProvider.psValueHolder.deviceToken != '') {
    //           final NotiUnRegisterParameterHolder
    //               notiUnRegisterParameterHolder = NotiUnRegisterParameterHolder(
    //                   platformName: PsConst.PLATFORM,
    //                   deviceId: notiProvider.psValueHolder.deviceToken,
    //                   loginUserId: await Utils.checkUserLoginId(
    //                       notiProvider.psValueHolder));
    //           notiProvider.rawUnRegisterNotiToken(
    //               notiUnRegisterParameterHolder.toMap());
    //         }
    //       }
    //     },
    //     activeTrackColor: PsColors.mainColor,
    //     activeColor: PsColors.mainColor);

    final Widget _notiSettingTextWidget = Text(
      Utils.getString(context, 'noti_setting__onof'),
      style: Theme.of(context).textTheme.subhead,
    );

    final Widget _messageTextWidget = Row(
      children: <Widget>[
        Icon(
          FontAwesome.bullhorn,
          size: PsDimens.space16,
        ),
        const SizedBox(
          width: PsDimens.space16,
        ),
        Text(
          Utils.getString(context, 'noti__latest_message'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subhead,
        ),
      ],
    );
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              top: PsDimens.space8,
              bottom: PsDimens.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _notiSettingTextWidget,
              //_switchButtonwidget,
              Switch(
                  value: isSwitched,
                  onChanged: (bool value) async {
                    setState(() {
                      isSwitched = value;
                      notiProvider.psValueHolder.notiSetting = value;
                      notiProvider.replaceNotiSetting(value);
                    });

                    if (isSwitched == true) {
                      _fcm.subscribeToTopic('broadcast');
                      if (notiProvider.psValueHolder.deviceToken != null &&
                          notiProvider.psValueHolder.deviceToken != '') {
                        final NotiRegisterParameterHolder
                            notiRegisterParameterHolder =
                            NotiRegisterParameterHolder(
                                platformName: PsConst.PLATFORM,
                                deviceId:
                                    notiProvider.psValueHolder.deviceToken,
                                loginUserId: await Utils.checkUserLoginId(
                                    notiProvider.psValueHolder));
                        notiProvider.rawRegisterNotiToken(
                            notiRegisterParameterHolder.toMap());
                      }
                    } else {
                      _fcm.unsubscribeFromTopic('broadcast');
                      if (notiProvider.psValueHolder.deviceToken != null &&
                          notiProvider.psValueHolder.deviceToken != '') {
                        final NotiUnRegisterParameterHolder
                            notiUnRegisterParameterHolder =
                            NotiUnRegisterParameterHolder(
                                platformName: PsConst.PLATFORM,
                                deviceId:
                                    notiProvider.psValueHolder.deviceToken,
                                loginUserId: await Utils.checkUserLoginId(
                                    notiProvider.psValueHolder));
                        notiProvider.rawUnRegisterNotiToken(
                            notiUnRegisterParameterHolder.toMap());
                      }
                    }
                  },
                  activeTrackColor: PsColors.mainColor,
                  activeColor: PsColors.mainColor)
            ],
          ),
        ),
        const Divider(
          height: PsDimens.space1,
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space20,
              bottom: PsDimens.space20,
              left: PsDimens.space8),
          child: _messageTextWidget,
        ),
      ],
    );
  }
}
