import 'dart:typed_data';

import 'package:bsu_control/src/car/repository/car_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../model/car_mapa_model.dart';
import '../../../model/car_model.dart';
import '../../../model/car_status_model.dart';

class CarRepository implements ICarRepository {
  final _instance = FirebaseFirestore.instance;

  @override
  Stream<List<CarStatusModel>> listenStatusCar({required String carId}) {
    return _instance
        .collection("cars")
        .doc(carId)
        .collection("status")
        .snapshots()
        .map((e) => e.docs.map((doc) {
              var carStatu = CarStatusModel.fromMap(doc.data());
              carStatu.id = doc.id;
              return carStatu;
            }).toList());
  }

  @override
  Future<bool> save(
      {required CarModel car, required String unidade, String? id}) async {
    try {
      var doc = _instance.collection("cars").doc(id);
      car.id = doc.id;

      for (var change in car.changes) {
        if (change.fileImage != null) {
          change.image = await _saveImage(
              image: change.fileImage!, unidade: unidade, id: car.id!);
        }
      }

      (id == null) ? await doc.set(car.toMap()) : await doc.update(car.toMap());

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> _saveImage(
      {required Uint8List image,
      required String unidade,
      required String id}) async {
    String arq = "${DateTime.now().millisecondsSinceEpoch.toString()}.png";
    TaskSnapshot upload = await FirebaseStorage.instance
        .ref()
        .child('imagens')
        .child(unidade.replaceAll(' ', ""))
        .child(id)
        .child(arq)
        .putData(image);

    return await upload.ref.getDownloadURL();
  }

  @override
  Future<bool> updateStatusCar(
      {required CarStatusModel status,
      required String id,
      required bool enable}) async {
    try {
      final docCar = _instance.collection('cars').doc(id);
      final docStatus = docCar.collection('status').doc();

      await _instance.runTransaction((trans) async {
        status.id = docStatus.id;
        trans.update(docCar, {'enable': enable});
        trans.set(docStatus, status.toMap());
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateKMCar(
      {required String id, required Map<String, dynamic> data}) async {
    try {
      await _instance.collection("cars").doc(id).update(data);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCar({required String id}) async {
    try {
      await _instance.collection("cars").doc(id).delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> insertMapaCar({required CarMapaModel mapa}) async {
    try {
      final docMapa = _instance.collection("mapas").doc();
      final docCar = _instance.collection("cars").doc(mapa.carId);

      mapa.id = docMapa.id;
      await _instance.runTransaction((trans) async {
        trans.update(docCar, {'km': int.parse(mapa.kmFinal)});
        trans.set(docMapa, mapa.toMap());
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCarMapa({required String id}) async {
    try {
      await _instance.collection("mapas").doc(id).delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<CarMapaModel>> listenMapas({required String carId}) {
    return _instance
        .collection("mapas")
        .where("carId", isEqualTo: carId)
        .snapshots()
        .map((e) => e.docs.map((doc) {
              var mapa = CarMapaModel.fromMap(doc.data());
              mapa.id = doc.id;
              return mapa;
            }).toList());
  }
}
