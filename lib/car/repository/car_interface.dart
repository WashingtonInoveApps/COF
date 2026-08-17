import 'package:bsu_control/model/checklist_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';

import '../../model/car_mapa_model.dart';
import '../../model/car_model.dart';
import '../../model/car_status_model.dart';
import '../../model/file_model.dart';

abstract class ICarRepository {
  Future<bool> save({
    required CarModel car,
    required List<FileModel?> images,
    required List<OtherChangeModel> others,
  });

  Future<bool> delete({required CarModel car});

  Future<bool> copy({required CarModel car});

  Future<bool> saveStatusCar({
    required CarModel car,
    required CarStatusModel status,
  });

  Future<bool> updateKMCar({
    required String id,
    required Map<String, dynamic> data,
  });

  Future<bool> deleteStatusCar({
    required CarModel car,
    required CarStatusModel status,
  });

  Future<List<CarStatusModel>> getStatusCar({required String carID});

  Stream<List<CarStatusModel>> listenStatusCarGeral({required DateTime date});

  Stream<List<CarMapaModel>> listenMapas({required String carId});

  Future<bool> deleteCarMapa({required String id});

  Future<bool> insertMapaCar({required CarMapaModel mapa});

  Future<List<ChecklistModel>> getChecklistByMonth({
    required DateTime reference,
  });
}
