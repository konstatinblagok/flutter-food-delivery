import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/provider/about_us/about_us_provider.dart';
import 'package:fluttermultistoreflutter/repository/about_us_repository.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _TermsAndConditionsViewState createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  AboutUsRepository repo1;
  PsValueHolder psValueHolder;
  AboutUsProvider provider;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<AboutUsRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();
    return ChangeNotifierProvider<AboutUsProvider>(create:
        (BuildContext context) {
      provider = AboutUsProvider(repo: repo1, psValueHolder: psValueHolder);
      provider.loadAboutUsList();
      return provider;
    }, child: Consumer<AboutUsProvider>(builder:
        (BuildContext context, AboutUsProvider basketProvider, Widget child) {
      if (provider.aboutUsList.data == null ||
          provider.aboutUsList.data.isEmpty) {
        return Container();
      } else {
        return AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: Padding(
                  padding: const EdgeInsets.all(PsDimens.space10),
                  child: SingleChildScrollView(
                    child: Text(
                      provider.aboutUsList.data[0].privacypolicy,
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    }));
  }
}
