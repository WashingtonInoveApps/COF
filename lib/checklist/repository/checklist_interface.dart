import 'dart:typed_data';

import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/checklist_model.dart';

import '../../model/outher_changes_model.dart';

abstract class ICheckListRepository {
  Future<bool> save({
    required ChecklistModel checklist,
    required List<CarChangeModel> changes,
    required List<OtherChangeModel> others,
  });

  Future<bool> delete({
    required ChecklistModel checklist,
    required CarModel car,
  });

  Future<bool> finish({
    required ChecklistModel checklist,
    Uint8List? image,
  });

  Stream<ChecklistModel> streamChecklistByID({
    required String checklistID,
  });

  Stream<List<ChecklistModel>> streamChecklistUser({required String userID});

  Stream<List<ChecklistModel>> streamChecklistPeriod({
    required DateTime referenceDateStart,
    required DateTime referenceDateFinish,
  });
}
