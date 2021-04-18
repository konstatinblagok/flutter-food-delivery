import 'package:fluttermultistoreflutter/db/about_us_dao.dart';
import 'package:fluttermultistoreflutter/db/shop_category_dao.dart';
import 'package:fluttermultistoreflutter/db/shop_list_by_tagid_dao.dart';
import 'package:fluttermultistoreflutter/db/shop_tag_dao.dart';
import 'package:fluttermultistoreflutter/repository/about_us_repository.dart';
import 'package:fluttermultistoreflutter/repository/delete_task_repository.dart';
import 'package:fluttermultistoreflutter/repository/shipping_cost_repository.dart';
import 'package:fluttermultistoreflutter/repository/shipping_method_repository.dart';
import 'package:fluttermultistoreflutter/db/shipping_method_dao.dart';
import 'package:fluttermultistoreflutter/db/basket_dao.dart';
import 'package:fluttermultistoreflutter/db/category_map_dao.dart';
import 'package:fluttermultistoreflutter/db/comment_detail_dao.dart';
import 'package:fluttermultistoreflutter/db/comment_header_dao.dart';
import 'package:fluttermultistoreflutter/db/favourite_product_dao.dart';
import 'package:fluttermultistoreflutter/db/gallery_dao.dart';
import 'package:fluttermultistoreflutter/db/history_dao.dart';
import 'package:fluttermultistoreflutter/db/product_collection_header_dao.dart';
import 'package:fluttermultistoreflutter/db/rating_dao.dart';
import 'package:fluttermultistoreflutter/db/shipping_city_dao.dart';
import 'package:fluttermultistoreflutter/db/shipping_country_dao.dart';
import 'package:fluttermultistoreflutter/db/user_dao.dart';
import 'package:fluttermultistoreflutter/db/related_product_dao.dart';
import 'package:fluttermultistoreflutter/db/user_login_dao.dart';
import 'package:fluttermultistoreflutter/repository/Common/notification_repository.dart';
import 'package:fluttermultistoreflutter/repository/basket_repository.dart';
import 'package:fluttermultistoreflutter/repository/clear_all_data_repository.dart';
import 'package:fluttermultistoreflutter/repository/comment_detail_repository.dart';
import 'package:fluttermultistoreflutter/repository/comment_header_repository.dart';
import 'package:fluttermultistoreflutter/repository/contact_us_repository.dart';
import 'package:fluttermultistoreflutter/repository/coupon_discount_repository.dart';
import 'package:fluttermultistoreflutter/repository/gallery_repository.dart';
import 'package:fluttermultistoreflutter/repository/history_repsitory.dart';
import 'package:fluttermultistoreflutter/repository/product_collection_repository.dart';
import 'package:fluttermultistoreflutter/db/blog_dao.dart';
import 'package:fluttermultistoreflutter/db/shop_info_dao.dart';
import 'package:fluttermultistoreflutter/db/transaction_detail_dao.dart';
import 'package:fluttermultistoreflutter/db/transaction_header_dao.dart';
import 'package:fluttermultistoreflutter/repository/blog_repository.dart';
import 'package:fluttermultistoreflutter/repository/rating_repository.dart';
import 'package:fluttermultistoreflutter/repository/shipping_city_repository.dart';
import 'package:fluttermultistoreflutter/repository/shipping_country_repository.dart';
import 'package:fluttermultistoreflutter/repository/shop_category_repository.dart';
import 'package:fluttermultistoreflutter/repository/shop_repository.dart';
import 'package:fluttermultistoreflutter/repository/shop_info_repository.dart';
import 'package:fluttermultistoreflutter/repository/shop_tag_repository.dart';
import 'package:fluttermultistoreflutter/repository/tansaction_detail_repository.dart';
import 'package:fluttermultistoreflutter/repository/transaction_header_repository.dart';
import 'package:fluttermultistoreflutter/repository/user_repository.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'package:fluttermultistoreflutter/db/cateogry_dao.dart';
import 'package:fluttermultistoreflutter/db/common/ps_shared_preferences.dart';
import 'package:fluttermultistoreflutter/db/noti_dao.dart';
import 'package:fluttermultistoreflutter/db/shop_dao.dart';
import 'package:fluttermultistoreflutter/db/sub_category_dao.dart';
import 'package:fluttermultistoreflutter/db/product_dao.dart';
import 'package:fluttermultistoreflutter/db/product_map_dao.dart';
import 'package:fluttermultistoreflutter/repository/app_info_repository.dart';
import 'package:fluttermultistoreflutter/repository/category_repository.dart';
import 'package:fluttermultistoreflutter/repository/language_repository.dart';
import 'package:fluttermultistoreflutter/repository/noti_repository.dart';
import 'package:fluttermultistoreflutter/repository/product_repository.dart';
import 'package:fluttermultistoreflutter/repository/ps_theme_repository.dart';
import 'package:fluttermultistoreflutter/repository/sub_category_repository.dart';

List<SingleChildCloneableWidget> providers = <SingleChildCloneableWidget>[
  ...independentProviders,
  ..._dependentProviders,
  ..._valueProviders,
];

List<SingleChildCloneableWidget> independentProviders =
    <SingleChildCloneableWidget>[
  Provider<PsSharedPreferences>.value(value: PsSharedPreferences.instance),
  Provider<PsApiService>.value(value: PsApiService()),
  Provider<CategoryDao>.value(value: CategoryDao()),
  Provider<CategoryMapDao>.value(value: CategoryMapDao.instance),
  Provider<SubCategoryDao>.value(
      value: SubCategoryDao()), 
  Provider<ProductDao>.value(
      value: ProductDao.instance), 
  Provider<ProductMapDao>.value(value: ProductMapDao.instance),
  Provider<AboutUsDao>.value(value: AboutUsDao.instance),
  Provider<NotiDao>.value(value: NotiDao.instance),
  Provider<ProductCollectionDao>.value(value: ProductCollectionDao.instance),
  Provider<ShopInfoDao>.value(value: ShopInfoDao.instance),
  Provider<BlogDao>.value(value: BlogDao.instance),
  Provider<TransactionHeaderDao>.value(value: TransactionHeaderDao.instance),
  Provider<TransactionDetailDao>.value(value: TransactionDetailDao.instance),
  Provider<UserDao>.value(value: UserDao.instance),
  Provider<UserLoginDao>.value(value: UserLoginDao.instance),
  Provider<RelatedProductDao>.value(value: RelatedProductDao.instance),
  Provider<CommentHeaderDao>.value(value: CommentHeaderDao.instance),
  Provider<CommentDetailDao>.value(value: CommentDetailDao.instance),
  Provider<RatingDao>.value(value: RatingDao.instance),
  Provider<ShippingCountryDao>.value(value: ShippingCountryDao.instance),
  Provider<ShippingCityDao>.value(value: ShippingCityDao.instance),
  Provider<HistoryDao>.value(value: HistoryDao.instance),
  Provider<GalleryDao>.value(value: GalleryDao.instance),
  Provider<ShippingMethodDao>.value(value: ShippingMethodDao.instance),
  Provider<BasketDao>.value(value: BasketDao.instance),
  Provider<FavouriteProductDao>.value(value: FavouriteProductDao.instance),
  Provider<ShopDao>.value(value: ShopDao.instance),
  Provider<ShopCategoryDao>.value(value: ShopCategoryDao.instance),
  Provider<ShopTagDao>.value(value: ShopTagDao.instance),
  Provider<ShopListByTagIdDao>.value(value: ShopListByTagIdDao.instance),
];

List<SingleChildCloneableWidget> _dependentProviders =
    <SingleChildCloneableWidget>[
  ProxyProvider<PsSharedPreferences, PsThemeRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            PsThemeRepository psThemeRepository) =>
        PsThemeRepository(psSharedPreferences: ssSharedPreferences),
  ),
  ProxyProvider<PsApiService, AppInfoRepository>(
    update:
        (_, PsApiService psApiService, AppInfoRepository appInfoRepository) =>
            AppInfoRepository(psApiService: psApiService),
  ),
  ProxyProvider<PsSharedPreferences, LanguageRepository>(
    update: (_, PsSharedPreferences ssSharedPreferences,
            LanguageRepository languageRepository) =>
        LanguageRepository(psSharedPreferences: ssSharedPreferences),
  ),
  ProxyProvider2<PsApiService, CategoryDao, CategoryRepository>(
    update: (_, PsApiService psApiService, CategoryDao categoryDao,
            CategoryRepository categoryRepository2) =>
        CategoryRepository(
            psApiService: psApiService, categoryDao: categoryDao),
  ),
  ProxyProvider2<PsApiService, SubCategoryDao, SubCategoryRepository>(
    update: (_, PsApiService psApiService, SubCategoryDao subCategoryDao,
            SubCategoryRepository subCategoryRepository) =>
        SubCategoryRepository(
            psApiService: psApiService, subCategoryDao: subCategoryDao),
  ),
  ProxyProvider2<PsApiService, AboutUsDao, AboutUsRepository>(
    update: (_, PsApiService psApiService, AboutUsDao aboutUsDao,
            AboutUsRepository aboutUsRepository) =>
        AboutUsRepository(psApiService: psApiService, aboutUsDao: aboutUsDao),
  ),
  ProxyProvider2<PsApiService, ProductCollectionDao,
      ProductCollectionRepository>(
    update: (_,
            PsApiService psApiService,
            ProductCollectionDao productCollectionDao,
            ProductCollectionRepository productCollectionRepository) =>
        ProductCollectionRepository(
            psApiService: psApiService,
            productCollectionDao: productCollectionDao),
  ),
  ProxyProvider2<PsApiService, ProductDao, ProductRepository>(
    update: (_, PsApiService psApiService, ProductDao productDao,
            ProductRepository categoryRepository2) =>
        ProductRepository(psApiService: psApiService, productDao: productDao),
  ),
  ProxyProvider2<PsApiService, NotiDao, NotiRepository>(
    update: (_, PsApiService psApiService, NotiDao notiDao,
            NotiRepository notiRepository) =>
        NotiRepository(psApiService: psApiService, notiDao: notiDao),
  ),
  ProxyProvider2<PsApiService, ShopInfoDao, ShopInfoRepository>(
    update: (_, PsApiService psApiService, ShopInfoDao shopInfoDao,
            ShopInfoRepository shopInfoRepository) =>
        ShopInfoRepository(
            psApiService: psApiService, shopInfoDao: shopInfoDao),
  ),
  ProxyProvider2<PsApiService, ShopCategoryDao, ShopCategoryRepository>(
    update: (_, PsApiService psApiService, ShopCategoryDao shopCategoryDao,
            ShopCategoryRepository shopCategoryRepository) =>
        ShopCategoryRepository(
            psApiService: psApiService, shopCategoryDao: shopCategoryDao),
  ),
  ProxyProvider2<PsApiService, ShopTagDao, ShopTagRepository>(
    update: (_, PsApiService psApiService, ShopTagDao shopTagDao,
            ShopTagRepository shopTagRepository) =>
        ShopTagRepository(psApiService: psApiService, shopTagDao: shopTagDao),
  ),
  ProxyProvider<PsApiService, NotificationRepository>(
    update:
        (_, PsApiService psApiService, NotificationRepository userRepository) =>
            NotificationRepository(
      psApiService: psApiService,
    ),
  ),
  ProxyProvider3<PsApiService, UserDao, UserLoginDao, UserRepository>(
    update: (_, PsApiService psApiService, UserDao userDao,
            UserLoginDao userLoginDao, UserRepository userRepository) =>
        UserRepository(
            psApiService: psApiService,
            userDao: userDao,
            userLoginDao: userLoginDao),
  ),

  ProxyProvider<PsApiService, ClearAllDataRepository>(
    update: (_, PsApiService psApiService,
            ClearAllDataRepository clearAllDataRepository) =>
        ClearAllDataRepository(),
  ),

  ProxyProvider<PsApiService, DeleteTaskRepository>(
    update: (_, PsApiService psApiService,
            DeleteTaskRepository deleteTaskRepository) =>
        DeleteTaskRepository(),
  ),

  ProxyProvider2<PsApiService, BlogDao, BlogRepository>(
    update: (_, PsApiService psApiService, BlogDao blogDao,
            BlogRepository blogRepository) =>
        BlogRepository(psApiService: psApiService, blogDao: blogDao),
  ),
  ProxyProvider2<PsApiService, TransactionHeaderDao,
      TransactionHeaderRepository>(
    update: (_,
            PsApiService psApiService,
            TransactionHeaderDao transactionHeaderDao,
            TransactionHeaderRepository transactionRepository) =>
        TransactionHeaderRepository(
            psApiService: psApiService,
            transactionHeaderDao: transactionHeaderDao),
  ),
  ProxyProvider2<PsApiService, TransactionDetailDao,
      TransactionDetailRepository>(
    update: (_,
            PsApiService psApiService,
            TransactionDetailDao transactionDetailDao,
            TransactionDetailRepository transactionDetailRepository) =>
        TransactionDetailRepository(
            psApiService: psApiService,
            transactionDetailDao: transactionDetailDao),
  ),
  ProxyProvider2<PsApiService, CommentHeaderDao, CommentHeaderRepository>(
    update: (_, PsApiService psApiService, CommentHeaderDao commentHeaderDao,
            CommentHeaderRepository commentHeaderRepository) =>
        CommentHeaderRepository(
            psApiService: psApiService, commentHeaderDao: commentHeaderDao),
  ),
  ProxyProvider2<PsApiService, CommentDetailDao, CommentDetailRepository>(
    update: (_, PsApiService psApiService, CommentDetailDao commentDetailDao,
            CommentDetailRepository commentHeaderRepository) =>
        CommentDetailRepository(
            psApiService: psApiService, commentDetailDao: commentDetailDao),
  ),

  ProxyProvider2<PsApiService, RatingDao, RatingRepository>(
    update: (_, PsApiService psApiService, RatingDao ratingDao,
            RatingRepository ratingRepository) =>
        RatingRepository(psApiService: psApiService, ratingDao: ratingDao),
  ),

  ProxyProvider2<PsApiService, HistoryDao, HistoryRepository>(
    update: (_, PsApiService psApiService, HistoryDao historyDao,
            HistoryRepository historyRepository) =>
        HistoryRepository(historyDao: historyDao),
  ),

  ProxyProvider2<PsApiService, GalleryDao, GalleryRepository>(
    update: (_, PsApiService psApiService, GalleryDao galleryDao,
            GalleryRepository galleryRepository) =>
        GalleryRepository(galleryDao: galleryDao, psApiService: psApiService),
  ),

  ProxyProvider<PsApiService, ContactUsRepository>(
    update: (_, PsApiService psApiService,
            ContactUsRepository apiStatusRepository) =>
        ContactUsRepository(psApiService: psApiService),
  ),

  ProxyProvider<PsApiService, ShippingCostRepository>(
    update: (_, PsApiService psApiService,
            ShippingCostRepository apiStatusRepository) =>
        ShippingCostRepository(psApiService: psApiService),
  ),

  ProxyProvider2<PsApiService, BasketDao, BasketRepository>(
    update: (_, PsApiService psApiService, BasketDao basketDao,
            BasketRepository historyRepository) =>
        BasketRepository(basketDao: basketDao),
  ),

  ProxyProvider2<PsApiService, ShippingMethodDao, ShippingMethodRepository>(
    update: (_, PsApiService psApiService, ShippingMethodDao shippingMethodDao,
            ShippingMethodRepository shippingMethodRepository) =>
        ShippingMethodRepository(
            psApiService: psApiService, shippingMethodDao: shippingMethodDao),
  ),

  ProxyProvider2<PsApiService, ShippingCountryDao, ShippingCountryRepository>(
    update: (_,
            PsApiService psApiService,
            ShippingCountryDao shippingCountryDao,
            ShippingCountryRepository shippingCountryRepository) =>
        ShippingCountryRepository(
            shippingCountryDao: shippingCountryDao, psApiService: psApiService),
  ),

  ProxyProvider2<PsApiService, ShippingCityDao, ShippingCityRepository>(
    update: (_, PsApiService psApiService, ShippingCityDao shippingCityDao,
            ShippingCityRepository shippingCityRepository) =>
        ShippingCityRepository(
            shippingCityDao: shippingCityDao, psApiService: psApiService),
  ),

  ProxyProvider2<PsApiService, ShopDao, ShopRepository>(
    update: (_, PsApiService psApiService, ShopDao shopDao,
            ShopRepository shopRepository) =>
        ShopRepository(psApiService: psApiService, shopDao: shopDao),
  ),

  ProxyProvider<PsApiService, CouponDiscountRepository>(
    update: (_, PsApiService psApiService,
            CouponDiscountRepository couponDiscountRepository) =>
        CouponDiscountRepository(psApiService: psApiService),
  ),
];
List<SingleChildCloneableWidget> _valueProviders = <SingleChildCloneableWidget>[
  StreamProvider<PsValueHolder>(
    create: (BuildContext context) =>
        Provider.of<PsSharedPreferences>(context, listen: false).psValueHolder,
  )
];
