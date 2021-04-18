import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';

class PsWidgetWithMultiProvider extends StatefulWidget {
  const PsWidgetWithMultiProvider({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _PsWidgetWithMultiProviderState createState() =>
      _PsWidgetWithMultiProviderState();
}

class _PsWidgetWithMultiProviderState extends State<PsWidgetWithMultiProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
        data: data,
        child: Scaffold(body: widget.child
            ));
  }
}
