import 'dart:async';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/api_status.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';
import 'package:flutter/cupertino.dart';

class TokenProvider extends PsProvider {
  TokenProvider({@required PsApiService psApiService, int limit = 0})
      : super(null, limit) {
    _psApiService = psApiService;
    print('Token Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    tokenDataListStream = StreamController<PsResource<ApiStatus>>.broadcast();
    subscription =
        tokenDataListStream.stream.listen((PsResource<ApiStatus> resource) {
      _tokenData = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  PsResource<ApiStatus> _tokenData =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);

  PsResource<ApiStatus> get tokenData => _tokenData;
  StreamSubscription<PsResource<ApiStatus>> subscription;
  StreamController<PsResource<ApiStatus>> tokenDataListStream;
  PsApiService _psApiService;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Token Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadToken(String shopId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (isConnectedToInternet) {
      final PsResource<ApiStatus> _resource =
          await _psApiService.getToken(shopId);

      if (_resource.status == PsStatus.SUCCESS) {
        tokenDataListStream.sink.add(_resource);
      }
    }
  }
}
