import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/check_list_model.dart';

abstract class ICheckListRepository {
  Future<bool> save(
      {required CheckListModel checklist,
      required List<CarChangeModel> changes});

  Future<bool> finish(
      {required String kmFinal, required CheckListModel checkList});
}
