import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bsu_control/model/file_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:universal_html/html.dart' as html;

class APIClient {
  late Dio? dio;

  final String endpoint;
  final String appID;
  final bool test;

  String acessToken = '';

  late FirebaseFirestore? firebase;

  late DocumentReference docApp;
  late CollectionReference colCars;
  late CollectionReference colUsers;
  late CollectionReference colChecklist;
  late CollectionReference colSupplies;
  late CollectionReference colMaps;

  APIClient(
      {required this.endpoint,
      this.dio,
      required this.appID,
      required this.test,
      this.firebase}) {
    BaseOptions options = BaseOptions(receiveDataWhenStatusError: true);

    dio ??= Dio(options);
    firebase ??= FirebaseFirestore.instance;

    docApp = firebase!
        .collection(test ? 'applicationTEST' : 'application')
        .doc(appID);
    colCars = docApp.collection("cars");
    colUsers = docApp.collection("users");
    colChecklist = docApp.collection("checklist");
    colSupplies = docApp.collection("supplies");
    colMaps = docApp.collection("maps");
  }

  updateAcessToken({required String token}) {
    acessToken = token;
  }

  Future<Response> onRequest(
      {required String path,
      String? base,
      dynamic data,
      bool basicAuth = false,
      Map<String, dynamic>? params,
      String? acessToken,
      String? contentType,
      bool download = false,
      String method = 'GET'}) async {
    Map<String, dynamic> query = {'appId': appID, 'test': test};

    if (params != null) {
      query.addEntries(params.entries);
    }

    return await dio!.request('${base ?? endpoint}/$path',
        queryParameters: query,
        data: data,
        options: Options(
            method: method,
            responseType: download ? ResponseType.bytes : ResponseType.json,
            headers: {
              'Authorization': basicAuth
                  ? 'Basic ${base64Encode(utf8.encode('${acessToken ?? this.acessToken}:'))}'
                  : 'Bearer ${acessToken ?? this.acessToken}',
              'Content-Type': contentType ?? 'application/json',
              'Access-Control-Allow-Origin': '*'
            }));
  }

  Future<String?> onDownload(
      {required String path,
      required String filename,
      required String destFile}) async {
    await dio!.download(path, '$destFile/$filename');

    return destFile;
  }

  String _getMimeType(String path) {
    return lookupMimeType(path) ?? 'application/octet-stream';
  }

  Future<FileModel?> saveFile({
    required String pathStorage,
    required Uint8List data,
    required String filename,
  }) async {
    try {
      String extensionFile = path.extension(filename);

      if (extensionFile.isEmpty) extensionFile = '.png';

      final contentType = _getMimeType(extensionFile);
      final name =
          "${filename.replaceAll(extensionFile, "")}_${DateTime.now().millisecondsSinceEpoch.toString()}$extensionFile";

      log(extensionFile);
      log(contentType);

      final metadata = SettableMetadata(
        contentType: contentType,
        customMetadata: {'picked-file-path': name},
      );

      Reference ref =
          FirebaseStorage.instance.ref().child(pathStorage).child(name);

      TaskSnapshot? uploadTask = await ref.putData(data, metadata);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return FileModel(name: name, url: downloadUrl);
    } catch (e) {
      log('Erro ao salvar arquivo: ${e.toString()}');
      return null;
    }
  }

  Future<bool> deleteFile(
      {required String path, required String filename}) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child(path).child(filename);
      await ref.delete();

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<Uint8List?> readBlobAsBytes(String blobUri) async {
    final response = await html.HttpRequest.request(
      blobUri,
      responseType: 'arraybuffer',
    );

    if (response.response is ByteBuffer) {
      final buffer = response.response as ByteBuffer;
      return Uint8List.view(buffer);
    }

    return null;
  }
}
