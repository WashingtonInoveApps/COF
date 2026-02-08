import 'dart:typed_data';

import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/check_list_model.dart';

abstract class ICheckListRepository {
  Future<bool> save(
      {required CheckListModel checklist,
      required List<CarChangeModel> changes});

  Future<bool> finish({required CheckListModel checklist, Uint8List? image});

  Stream<CheckListModel> streamChecklistByID({required String checklistID});
}
