import 'package:bsu_control/model/check_list_model.dart';

abstract class ICheckListRepository {
  Future<bool> save(
      {required CheckListModel checkList, required String unidade, String? id});
  Future<bool> finish(
      {required String kmFinal, required CheckListModel checkList});
}
