import 'dart:convert';
import 'dart:io';
import 'package:fluttermultistoreflutter/api/common/ps_api_reponse.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_object.dart';

abstract class PsApi {
  PsResource<T> psObjectConvert<T>(dynamic dataList, T data) {
    return PsResource<T>(dataList.status, dataList.message, data);
  }

  Future<List<dynamic>> getList(String url) async {
    final Client client = http.Client();
    try {
      final Response response = await client.get('${PsConfig.ps_app_url}$url');

      if (response.statusCode == 200) {
        // parse into List
        final List<dynamic> parsed = json.decode(response.body);

        //posts.addAll(SubCategory().fromJsonList(parsed));

        return parsed;
      } else {
        throw Exception('Error in loading...');
      }
    } finally {
      client.close();
    }
  }

  Future<PsResource<R>> getServerCall<T extends PsObject<dynamic>, R>(
      T obj, String url) async {
    final Client client = http.Client();
    try {
      final Response response = await client.get('${PsConfig.ps_app_url}$url');
      print('${PsConfig.ps_app_url}$url');
      final PsApiResponse psApiResponse = PsApiResponse(response);

      // return psApiResponse;
      if (psApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(response.body);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList ?? R);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, psApiResponse.errorMessage, null);
      }
    } finally {
      client.close();
    }
  }

  Future<PsResource<R>> postData<T extends PsObject<dynamic>, R>(
      T obj, String url, Map<dynamic, dynamic> jsonMap) async {
    final Client client = http.Client();
    try {
      final Response response = await client
          .post('${PsConfig.ps_app_url}$url',
              headers: <String, String>{'content-type': 'application/json'},
              body: const JsonEncoder().convert(jsonMap))
          .catchError((dynamic e) {
        print('** Error Post Data');
        print(e.error);
      });

      final PsApiResponse psApiResponse = PsApiResponse(response);

      // return psApiResponse;
      if (psApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(response.body);

        // return PsResource<R>(PsStatus.SUCCESS, "", obj.fromMap(hashMap));
        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList ?? R);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, psApiResponse.errorMessage, null);
      }
    } finally {
      client.close();
    }
  }

  Future<PsResource<R>> postUploadImage<T extends PsObject<dynamic>, R>(T obj,
      String url, String userId, String platformName, File imageFile) async {
    final Client client = http.Client();
    try {
      final ByteStream stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      final int length = await imageFile.length();

      final Uri uri = Uri.parse('${PsConfig.ps_app_url}$url');

      final MultipartRequest request = http.MultipartRequest('POST', uri);
      final MultipartFile multipartFile = http.MultipartFile(
          'file', stream, length,
          filename: basename(imageFile.path));
      //contentType: new MediaType('image', 'png'));

      request.fields['user_id'] = userId;
      request.fields['platform_name'] = platformName;
      request.files.add(multipartFile);
      final StreamedResponse response = await request.send();

      final PsApiResponse psApiResponse =
          PsApiResponse(await http.Response.fromStream(response));

      //  final PsApiResponse psApiResponse = PsApiResponse(response);

      // final PsApiResponse psApiResponse =
      // await PsApiStreamResponse().getPsApiStreamResponse(response);

      // return psApiResponse.body as dynamic;
      if (psApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(psApiResponse.body);

        // return PsResource<R>(PsStatus.SUCCESS, "", obj.fromMap(hashMap));
        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList ?? R);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, psApiResponse.errorMessage, null);
      }
    } finally {
      client.close();
    }
  }
}
