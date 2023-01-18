// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CarController on _CarControllerBase, Store {
  Computed<bool>? _$enableComputed;

  @override
  bool get enable => (_$enableComputed ??=
          Computed<bool>(() => super.enable, name: '_CarControllerBase.enable'))
      .value;

  late final _$loadingAtom =
      Atom(name: '_CarControllerBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$saveCarAsyncAction =
      AsyncAction('_CarControllerBase.saveCar', context: context);

  @override
  Future<bool> saveCar({required CarModel car, String? id}) {
    return _$saveCarAsyncAction.run(() => super.saveCar(car: car, id: id));
  }

  late final _$updateKMOilAsyncAction =
      AsyncAction('_CarControllerBase.updateKMOil', context: context);

  @override
  Future<bool> updateKMOil({required String id, required int value}) {
    return _$updateKMOilAsyncAction
        .run(() => super.updateKMOil(id: id, value: value));
  }

  late final _$updateKMArrefAsyncAction =
      AsyncAction('_CarControllerBase.updateKMArref', context: context);

  @override
  Future<bool> updateKMArref({required String id, required int value}) {
    return _$updateKMArrefAsyncAction
        .run(() => super.updateKMArref(id: id, value: value));
  }

  late final _$updateStatusCarAsyncAction =
      AsyncAction('_CarControllerBase.updateStatusCar', context: context);

  @override
  Future<bool> updateStatusCar(
      {required CarStatusModel status,
      required String id,
      required bool enable}) {
    return _$updateStatusCarAsyncAction.run(
        () => super.updateStatusCar(status: status, id: id, enable: enable));
  }

  late final _$insertMapaCarAsyncAction =
      AsyncAction('_CarControllerBase.insertMapaCar', context: context);

  @override
  Future<bool> insertMapaCar({required CarMapaModel mapa}) {
    return _$insertMapaCarAsyncAction
        .run(() => super.insertMapaCar(mapa: mapa));
  }

  late final _$deleteCarMapaAsyncAction =
      AsyncAction('_CarControllerBase.deleteCarMapa', context: context);

  @override
  Future<bool> deleteCarMapa({required String id}) {
    return _$deleteCarMapaAsyncAction.run(() => super.deleteCarMapa(id: id));
  }

  @override
  String toString() {
    return '''
loading: ${loading},
enable: ${enable}
    ''';
  }
}
