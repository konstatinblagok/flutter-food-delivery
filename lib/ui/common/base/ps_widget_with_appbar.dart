import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PsWidgetWithAppBar<T extends ChangeNotifier> extends StatefulWidget {
  const PsWidgetWithAppBar(
      {Key key,
      @required this.builder,
      @required this.initProvider,
      this.child,
      this.onProviderReady,
      @required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Widget Function(BuildContext context, T provider, Widget child) builder;
  final Function initProvider;
  final Widget child;
  final Function(T) onProviderReady;
  final String appBarTitle;
  final List<Widget> actions;

  @override
  _PsWidgetWithAppBarState<T> createState() => _PsWidgetWithAppBarState<T>();
}

class _PsWidgetWithAppBarState<T extends ChangeNotifier>
    extends State<PsWidgetWithAppBar<T>> {
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
              iconTheme: IconThemeData(
                  color: PsColors.mainColorWithWhite),
              title: Text(widget.appBarTitle,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontWeight: FontWeight.bold)
                      .copyWith(
                          color: PsColors.mainColorWithWhite)),
              actions: widget.actions,
              flexibleSpace: Container(
                height: 200,
              ),
              elevation: 0,
            ),
            body: ChangeNotifierProvider<T>(
              create: (BuildContext context) {
                final T providerObj = widget.initProvider();
                if (widget.onProviderReady != null) {
                  widget.onProviderReady(providerObj);
                }

                return providerObj;
              },
              child: Consumer<T>(
                builder: widget.builder,
                child: widget.child,
              ),
            )));
  }
}
