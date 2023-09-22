import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_from_zero/app/data/services/locals/details_user.dart';

class HttpHandlerServices {

  final String baseUrl = '';
  Dio _dio = Dio();
  RequestOptions? rOptions;  
  
  bool isContainsPath(String path) {
    return path.contains('/customers/signUp') || path.contains('/customers/login'); // METRE ICI TOUS LES APIS QUI DEMENDE PAS DE TOKEN
  }


  HttpHandlerServices() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        EasyLoading.show(status: "CHARGEMENT EN COURS ...");
        if (!isContainsPath(options.path)) { // CHECK IF ADD TOKEN OR NO
          String? accessToken = DetailsUser().getToken();
          options.headers['Authorization'] = 'Bearer $accessToken';
          rOptions = options;
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        EasyLoading.dismiss();
        handler.next(response);
      },
      onError: (error, handler) async {
        EasyLoading.dismiss();
        EasyLoading.showError("Error Message");
        if ((error.response?.statusCode == 401)) {
          // REFRESH TOKEN HERE
        }
        return handler.next(error);
      },
  ));
  }

  Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  // --------------- TOUT LES REQUEST DE L'APPLICATION DOIVENT PASSE PAR L'UN DE CES FONCTION ---------------------------------------------------------
  Future<Response?> doFormDataPostRequest(String api, FormData data) async {
    try {
      var res = await _dio.post('$baseUrl/$api', data: data);
      return res;
    } on DioException catch (e) {
      return null;
    }
  }

  Future<Response?> doPostRequest(String api, Map<String, dynamic> data) async {
    try {
      var res = await _dio.post('$baseUrl/$api', data: data);
      return res;
    } on DioException catch (e) {
      return null;
    }
  }
  
  Future<Response?> doGetRequest(String api, {params}) async {
    try {
      var res = await _dio.get('$baseUrl/$api', queryParameters: params);
      return res;
    } on DioException catch (e) {
      return null;
    }
  }  

  Future<Response?> doPatchRequest(String api, Map<String, dynamic> data) async {
    try {
      var res = await _dio.patch('$baseUrl/$api', data: data);
      return res;
    } on DioException catch (e) {
      return null;
    }
  }

  Future<Response?> doPutRequest(String api, Map<String, dynamic> data) async {
    try {
      var res = await _dio.put('$baseUrl/$api', data: data);
      return res;
    } on DioException catch (e) {
      return null;
    }
  }
}