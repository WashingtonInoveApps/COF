import 'package:bsu_control/model/exchange_model.dart';

abstract class IExchangeRepository {
  Future<ExchangeModel?> verifyFile({required String token});
  Future<String?> save({required ExchangeModel exchange});
  Future<bool> update({required ExchangeModel exchange});
  Stream<List<ExchangeModel>> listenExchange({required DateTime referenceDate});
}