// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materials_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MaterialsController on _MaterialsControllerBase, Store {
  late final _$loadingAtom =
      Atom(name: '_MaterialsControllerBase.loading', context: context);

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

  late final _$limitAtom =
      Atom(name: '_MaterialsControllerBase.limit', context: context);

  @override
  int get limit {
    _$limitAtom.reportRead();
    return super.limit;
  }

  @override
  set limit(int value) {
    _$limitAtom.reportWrite(value, super.limit, () {
      super.limit = value;
    });
  }

  late final _$pageAtom =
      Atom(name: '_MaterialsControllerBase.page', context: context);

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  late final _$_MaterialsControllerBaseActionController =
      ActionController(name: '_MaterialsControllerBase', context: context);

  @override
  dynamic setLimit(int? value) {
    final _$actionInfo = _$_MaterialsControllerBaseActionController.startAction(
        name: '_MaterialsControllerBase.setLimit');
    try {
      return super.setLimit(value);
    } finally {
      _$_MaterialsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPage(int value) {
    final _$actionInfo = _$_MaterialsControllerBaseActionController.startAction(
        name: '_MaterialsControllerBase.setPage');
    try {
      return super.setPage(value);
    } finally {
      _$_MaterialsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
limit: ${limit},
page: ${page}
    ''';
  }
}
