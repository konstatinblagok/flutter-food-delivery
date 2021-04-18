import 'package:fluttermultistoreflutter/provider/gallery/gallery_provider.dart';
import 'package:fluttermultistoreflutter/repository/gallery_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_appbar.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/default_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({
    Key key,
    @required this.selectedDefaultImage,
    this.onImageTap,
  }) : super(key: key);

  final DefaultPhoto selectedDefaultImage;
  final Function onImageTap;

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  @override
  Widget build(BuildContext context) {
    final GalleryRepository galleryRepo =
        Provider.of<GalleryRepository>(context);
    print(
        '............................Build UI Again ............................');
    return PsWidgetWithAppBar<GalleryProvider>(
      appBarTitle: Utils.getString(context, 'gallery__title') ?? '',
      initProvider: () {
        return GalleryProvider(repo: galleryRepo);
      },
      onProviderReady: (GalleryProvider provider) {
        provider.loadImageList(
          widget.selectedDefaultImage.imgParentId,
        );
      },
      builder: (BuildContext context, GalleryProvider provider, Widget child) {
        if (provider.galleryList != null &&
            provider.galleryList.data != null &&
            provider.galleryList.data.isNotEmpty) {
          int selectedIndex = 0;
          for (int i = 0; i < provider.galleryList.data.length; i++) {
            if (widget.selectedDefaultImage.imgId ==
                provider.galleryList.data[i].imgId) {
              selectedIndex = i;
              break;
            }
          }

          return PhotoViewGallery.builder(
            itemCount: provider.galleryList.data.length,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions.customChild(
                child: PsNetworkImage(
                  photoKey: '',
                  defaultPhoto: provider.galleryList.data[index],
                  onTap: widget.onImageTap,
                ),
                childSize: MediaQuery.of(context).size,
              );
            },
            pageController: PageController(initialPage: selectedIndex),
            scrollPhysics: const BouncingScrollPhysics(),
            loadingChild: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
