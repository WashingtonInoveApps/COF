import 'package:bsu_control/model/exchange_model.dart';
import 'package:bsu_control/src/exchange/repository/exchange_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ExchangeRepository implements IExchangeRepository {
  late FirebaseFirestore? instance;
  late Dio? dio;

  final String baseUrl =
      'https://us-central1-bsucos-function.cloudfunctions.net/app/';

  ExchangeRepository({this.dio, this.instance}) {
    BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
    );

    instance ??= FirebaseFirestore.instance;
    dio ??= Dio(options);
  }

  Future<Response> onRequest(
      {required String path,
      dynamic data,
      Map<String, dynamic>? params,
      String method = 'GET'}) async {
    Map<String, dynamic> query = {};

    if (params != null) {
      query.addEntries(params.entries);
    }

    debugPrint('BaseUrl: $baseUrl$path');
    debugPrint('Params: $query');
    debugPrint('Method: $method');
    debugPrint('Data: $data');

    return await dio!.request('$baseUrl$path',
        queryParameters: query,
        data: data ?? {},
        options: Options(
            method: method,
            contentType: Headers.jsonContentType,
            headers: {
              // 'Authorization': 'Bearer $acessToken',
              'Content-Type': 'application/json'
            }));
  }

  @override
  Future<String?> onDownload(
      {required String path,
      required String filename,
      required String destFile}) async {
    await dio!.download(path, '$destFile/$filename');

    debugPrint("Path: $path Arquivo criado.: $destFile");
    return destFile;
  }

  @override
  Future<ExchangeModel?> verifyFile({required String token}) async {
    try {
      final response =
          await onRequest(path: 'exchange/verify', params: {'token': token});

      if (response.statusCode == 200) {
        return ExchangeModel.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw e.response?.data['message'];
    } catch (e) {
      throw 'Falha não tratada.';
    }
  }

  @override
  Future<String?> save({required ExchangeModel exchange}) async {
    try {
      var doc = instance!.collection("exchanges").doc();

      exchange.id = doc.id;
      exchange.requestedID = exchange.requested?.id ?? '';
      exchange.requesterID = exchange.requester?.id ?? '';

      await doc.set(exchange.toMap());

      return doc.id;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> update({required ExchangeModel exchange}) async {
    try {
      await instance!
          .collection("exchanges")
          .doc(exchange.id)
          .update(exchange.toMap());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<ExchangeModel>> listenExchange(
      {required DateTime referenceDate}) {
    final reference =
        "${referenceDate.month.toString().padLeft(2, '0')}/${referenceDate.year}";
    return instance!
        .collection("exchanges")
        .where("referenceMonth", isEqualTo: reference)
        .snapshots()
        .map((e) => e.docs.map((doc) {
              var exchange = ExchangeModel.fromMap(doc.data());
              exchange.id = doc.id;
              return exchange;
            }).toList());
  }
}
