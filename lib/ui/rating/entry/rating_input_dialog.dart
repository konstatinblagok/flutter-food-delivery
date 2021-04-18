import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/provider/product/product_provider.dart';
import 'package:fluttermultistoreflutter/provider/rating/rating_provider.dart';
import 'package:fluttermultistoreflutter/repository/rating_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_button_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_textfield_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/rating_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingInputDialog extends StatefulWidget {
  const RatingInputDialog({
    Key key,
    @required this.productprovider,
  }) : super(key: key);

  final ProductDetailProvider productprovider;
  @override
  _RatingInputDialogState createState() => _RatingInputDialogState();
}

class _RatingInputDialogState extends State<RatingInputDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  double rating;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RatingRepository ratingRepo = Provider.of<RatingRepository>(context);

    final Widget _headerWidget = Container(
        height: PsDimens.space52,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            color: PsColors.mainColor),
        child: Row(
          children: <Widget>[
            const SizedBox(width: PsDimens.space12),
            Icon(
              Icons.rate_review,
              color: PsColors.white,
            ),
            const SizedBox(width: PsDimens.space8),
            Text(
              Utils.getString(context, 'rating_entry__user_rating_entry'),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: PsColors.white,
              ),
            ),
          ],
        ));
    return ChangeNotifierProvider<RatingProvider>(create:
        (BuildContext context) {
      final RatingProvider provider = RatingProvider(repo: ratingRepo);
      provider.loadRatingList(widget.productprovider.productDetail.data.id);
      return provider;
    }, child: Consumer<RatingProvider>(
        builder: (BuildContext context, RatingProvider provider, Widget child) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)), //this right here
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _headerWidget,
              const SizedBox(
                height: PsDimens.space16,
              ),
              Column(
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'rating_entry__your_rating'),
                    style: Theme.of(context).textTheme.body1.copyWith(),
                  ),
                  if (rating == null)
                    SmoothStarRating(
                        allowHalfRating: false,
                        rating: 0.0,
                        starCount: 5,
                        size: PsDimens.space24,
                        color: PsColors.ratingColor,
                        onRatingChanged: (double rating1) {
                          setState(() {
                            rating = rating1;
                          });
                        },
                        borderColor: PsColors.grey.withAlpha(100),
                        spacing: 0.0)
                  else
                    SmoothStarRating(
                        allowHalfRating: false,
                        rating: rating,
                        starCount: 5,
                        size: PsDimens.space24,
                        color: PsColors.ratingColor,
                        onRatingChanged: (double rating1) {
                          setState(() {
                            rating = rating1;
                          });
                        },
                        borderColor: PsColors.grey.withAlpha(100),
                        spacing: 0.0),
                  PsTextFieldWidget(
                      titleText:
                          Utils.getString(context, 'rating_entry__title'),
                      hintText: Utils.getString(context, 'rating_entry__title'),
                      textEditingController: titleController),
                  PsTextFieldWidget(
                      height: PsDimens.space120,
                      titleText:
                          Utils.getString(context, 'rating_entry__message'),
                      hintText:
                          Utils.getString(context, 'rating_entry__message'),
                      textEditingController: descriptionController),
                  const Divider(
                    height: 0.5,
                  ),
                  const SizedBox(
                    height: PsDimens.space16,
                  ),
                  _ButtonWidget(
                    descriptionController: descriptionController,
                    provider: provider,
                    productProvider: widget.productprovider,
                    titleController: titleController,
                    rating: rating,
                  ),
                  const SizedBox(
                    height: PsDimens.space16,
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }));
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget({
    Key key,
    @required this.titleController,
    @required this.descriptionController,
    @required this.provider,
    @required this.productProvider,
    @required this.rating,
  }) : super(key: key);

  final TextEditingController titleController, descriptionController;
  final RatingProvider provider;
  final ProductDetailProvider productProvider;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: PsDimens.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: false,
                colorData: PsColors.grey,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__cancel'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: true,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__submit'),
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty &&
                      rating != null &&
                      rating.toString() != '0.0') {
                    final RatingParameterHolder commentHeaderParameterHolder =
                        RatingParameterHolder(
                            userId: productProvider.psValueHolder.loginUserId,
                            productId: productProvider.productDetail.data.id,
                            title: titleController.text,
                            description: descriptionController.text,
                            rating: rating.toString(),
                            shopId: productProvider.psValueHolder.shopId);

                    await provider
                        .postRating(commentHeaderParameterHolder.toMap());

                    Navigator.pop(context);
                  } else {
                    print('There is no comment');

                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return WarningDialog(
                            message:
                                Utils.getString(context, 'rating_entry__error'),
                          );
                        });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
