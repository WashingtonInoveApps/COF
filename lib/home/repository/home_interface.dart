import 'package:bsu_control/model/checklist_model.dart';

abstract class IHomeRepository {
  Stream<List<ChecklistModel>> listenChecklistPeriod({
    required DateTime operationDate,
  });
}
