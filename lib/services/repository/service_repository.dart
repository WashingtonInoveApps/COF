import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/model/service_model.dart';

import 'service_interface.dart';

class ServiceRepository extends APIClient implements IServiceRepository {
  ServiceRepository(
      {required String endpoint, required String appID, required bool test})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Future<bool> save({required ServiceModel service}) async {
    try {
      final doc = colServices.doc();
      service.id = doc.id;

      await doc.set(service.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
