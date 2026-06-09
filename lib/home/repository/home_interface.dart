import 'package:bsu_control/model/check_list_model.dart';

abstract class IHomeRepository {
  Stream<List<ChecklistModel>> listenChecklistPeriod(
      {required DateTime referenceDateStart,
      required DateTime referenceDateFinish});
}
