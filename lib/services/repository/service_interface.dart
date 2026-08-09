import 'package:bsu_control/model/service_model.dart';

abstract class IServiceRepository {
  Future<bool> save({
    required ServiceModel service,
  });

  // Future<bool> delete({
  //   required ChecklistModel checklist,
  //   required CarModel car,
  // });

  // Future<bool> finish({
  //   required ChecklistModel checklist,
  //   Uint8List? image,
  // });

  // Stream<ChecklistModel> streamChecklistByID({
  //   required String checklistID,
  // });

  // Stream<List<ChecklistModel>> streamChecklistUser({required String userID});

  // Stream<List<ChecklistModel>> streamChecklistPeriod({
  //   required DateTime referenceDateStart,
  //   required DateTime referenceDateFinish,
  // });
}
