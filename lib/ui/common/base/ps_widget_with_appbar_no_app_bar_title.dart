import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PsWidgetWithAppBarNoAppBarTitle<T extends ChangeNotifier>
    extends StatefulWidget {
  const PsWidgetWithAppBarNoAppBarTitle(
      {Key key,
      @required this.builder,
      @required this.initProvider,
      this.child,
      this.onProviderReady,
      this.appBarTitle})
      : super(key: key);

  final Widget Function(BuildContext context, T provider, Widget child) builder;
  final Function initProvider;
  final Widget child;
  final Function(T) onProviderReady;
  final String appBarTitle;

  @override
  _PsWidgetWithAppBarState<T> createState() => _PsWidgetWithAppBarState<T>();
}

class _PsWidgetWithAppBarState<T extends ChangeNotifier>
    extends State<PsWidgetWithAppBarNoAppBarTitle<T>> {
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
                  IconThemeData(color: Theme.of(context).iconTheme.color),
              title: Text(widget.appBarTitle,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontWeight: FontWeight.bold)),
              flexibleSpace: Container(
                height: 200,
              ),
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
