import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/home/repository/home_interface.dart';
import 'package:bsu_control/model/check_list_model.dart';

class HomeRepository extends APIClient implements IHomeRepository {
  HomeRepository(
      {required String endpoint, required String appID, required bool test})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Stream<List<ChecklistModel>> listenChecklistPeriod({
    required DateTime operationDate,
  }) {
    try {
      // final start = referenceDateStart
      //     .copyWith(
      //         hour: 0, second: 0, minute: 0, millisecond: 0, microsecond: 0)
      //     .millisecondsSinceEpoch;
      // final finish = referenceDateFinish
      //     .copyWith(
      //       hour: 23,
      //       second: 59,
      //       minute: 59,
      //     )
      //     .millisecondsSinceEpoch;

      return colChecklist
          .where('referenceDate', isEqualTo: Core.formatDate(operationDate))
          .snapshots()
          .map((e) => e.docs.map((doc) {
                var checkList =
                    ChecklistModel.fromMap(doc.data() as Map<String, dynamic>);
                checkList.id = doc.id;
                return checkList;
              }).toList());
      // } else {
      //   log('Buscando por intervalo de data');
      //   return colChecklist
      //       .where('date', isGreaterThanOrEqualTo: start)
      //       .where('date', isLessThanOrEqualTo: finish)
      //       .orderBy('date')
      //       .snapshots()
      //       .map((e) {
      //     return e.docs
      //         .map((doc) =>
      //             ChecklistModel.fromMap(doc.data() as Map<String, dynamic>))
      //         .toList();
      //   });
      // }
    } catch (e) {
      return Stream.value([]);
    }
  }
}
