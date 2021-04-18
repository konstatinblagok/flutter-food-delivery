import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';

class PsWidgetWithAppBarAndMultiProvider extends StatefulWidget {
  const PsWidgetWithAppBarAndMultiProvider(
      {Key key,
      this.child,
      @required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Widget child;
  final String appBarTitle;
  final List<Widget> actions;

  @override
  _PsWidgetWithAppBarAndMultiProviderState createState() =>
      _PsWidgetWithAppBarAndMultiProviderState();
}

class _PsWidgetWithAppBarAndMultiProviderState
    extends State<PsWidgetWithAppBarAndMultiProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
        data: data,
        child: Scaffold(
            appBar: AppBar(
              brightness: Utils.getBrightnessForAppBar(context),
              iconTheme:
                  IconThemeData(color: PsColors.mainColorWithWhite),
              title: Text(widget.appBarTitle,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontWeight: FontWeight.bold, color: PsColors.mainColorWithWhite)),
              actions: widget.actions,
              flexibleSpace: Container(
                height: 200,
              ),
              elevation: 0,
            ),
            body: widget.child

            //child: widget.child),
            ));
  }
}
