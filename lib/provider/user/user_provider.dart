import 'dart:async';
import 'dart:io';
import 'package:fluttermultistoreflutter/repository/user_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/api_status.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_city.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_country.dart';
import 'package:fluttermultistoreflutter/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';

class UserProvider extends PsProvider {
  UserProvider(
      {@required UserRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('User Provider: $hashCode');
    userListStream = StreamController<PsResource<User>>.broadcast();
    subscription = userListStream.stream.listen((PsResource<User> resource) {
      if (resource != null && resource.data != null) {
        _user = resource;
        holderUser = resource.data;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  UserRepository _repo;
  PsValueHolder psValueHolder;
  User holderUser;
  ShippingCountry selectedCountry;
  ShippingCity selectedCity;
  bool isCheckBoxSelect = false;

  PsResource<User> _user = PsResource<User>(PsStatus.NOACTION, '', null);
  PsResource<User> _holderUser = PsResource<User>(PsStatus.NOACTION, '', null);
  PsResource<User> get user => _user;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get apiStatus => _apiStatus;

  StreamSubscription<PsResource<User>> subscription;
  StreamController<PsResource<User>> userListStream;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('User Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postUserRegister(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserRegister(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postUserEmailVerify(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserEmailVerify(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postImageUpload(
    String userId,
    String platformName,
    File imageFile,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postImageUpload(userId, platformName, imageFile,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postUserLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postForgotPassword(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postForgotPassword(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postChangePassword(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postChangePassword(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postProfileUpdate(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _holderUser = await _repo.postProfileUpdate(jsonMap, isConnectedToInternet,
        PsStatus.SUCCESS); //it is success for this case
    if (_holderUser.status == PsStatus.ERROR &&
        _holderUser != null &&
        _holderUser.data != null) {
      return _user;
    } else {
      _user = _holderUser;
      return _holderUser;
    }
  }

  Future<dynamic> postPhoneLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postPhoneLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postFBLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postFBLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postGoogleLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postGoogleLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postResendCode(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postResendCode(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> getUser(
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getUser(userListStream, loginUserId, isConnectedToInternet,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> getUserFromDB(String loginUserId) async {
    isLoading = true;

    await _repo.getUserFromDB(
        loginUserId, userListStream, PsStatus.PROGRESS_LOADING);
  }
}
