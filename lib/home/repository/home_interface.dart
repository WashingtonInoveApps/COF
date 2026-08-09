import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/service_model.dart';

abstract class IHomeRepository {
  Stream<List<ChecklistModel>> listenChecklistPeriod({
    required DateTime referenceDateStart,
    required DateTime referenceDateFinish,
  });

  Stream<List<ServiceModel>> listenServices({
    required DateTime referenceDateStart,
    required DateTime referenceDateFinish,
  });
}
