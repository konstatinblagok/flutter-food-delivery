import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PsWidgetWithAppBarWithTwoProvider<T extends ChangeNotifier,
    V extends ChangeNotifier> extends StatefulWidget {
  const PsWidgetWithAppBarWithTwoProvider(
      {Key key,
      @required this.initProvider1,
      @required this.initProvider2,
      this.child,
      this.onProviderReady1,
      this.onProviderReady2,
      @required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Function initProvider1, initProvider2;
  final Widget child;
  final Function(T) onProviderReady1;
  final Function(V) onProviderReady2;
  final String appBarTitle;
  final List<Widget> actions;

  @override
  _PsWidgetWithAppBarWithTwoProviderState<T, V> createState() =>
      _PsWidgetWithAppBarWithTwoProviderState<T, V>();
}

class _PsWidgetWithAppBarWithTwoProviderState<T extends ChangeNotifier,
        V extends ChangeNotifier>
    extends State<PsWidgetWithAppBarWithTwoProvider<T, V>> {
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
                  IconThemeData(color: PsColors.mainColor),
              title: Text(widget.appBarTitle,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontWeight: FontWeight.bold,color: PsColors.mainColor)),
              actions: widget.actions,
              flexibleSpace: Container(
                height: 200,
              ),
              elevation: 0,
            ),
            body: MultiProvider(providers: <SingleChildCloneableWidget>[
              ChangeNotifierProvider<T>(
                create: (BuildContext context) {
                  final T providerObj1 = widget.initProvider1();

                  if (widget.onProviderReady1 != null) {
                    widget.onProviderReady1(providerObj1);
                  }

                  return providerObj1;
                },
              ),
              ChangeNotifierProvider<V>(
                create: (BuildContext context) {
                  final V providerObj2 = widget.initProvider2();
                  if (widget.onProviderReady2 != null) {
                    widget.onProviderReady2(providerObj2);
                  }

                  return providerObj2;
                },
              )
            ], child: widget.child)
            ));
  }
}
