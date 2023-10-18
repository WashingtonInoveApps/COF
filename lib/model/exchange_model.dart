// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/user_model.dart';

class ExchangeModel {
  String? id;
  String reason;
  String type;
  String function;
  String unidad;
  UserModel? requested;
  UserModel? requester;
  String baseFirst;
  String baseLast;
  String requesterID;
  String requestedID;
  String referenceDate;
  DateTime date;
  DateTime? firstDateFirst;
  DateTime? lastDateFirst;
  DateTime? firstDateLast;
  DateTime? lastDateLast;
  DateTime? at;

  ExchangeModel({
    this.id,
    this.reason = '',
    this.type = '',
    this.function = '',
    this.unidad = '',
    this.requested,
    this.requester,
    this.baseFirst = '',
    this.baseLast = '',
    this.requesterID = '',
    this.requestedID = '',
    this.referenceDate = '',
    required this.date,
    this.firstDateFirst,
    this.lastDateFirst,
    this.firstDateLast,
    this.lastDateLast,
    this.at,
  });

  ExchangeModel copyWith({
    String? id,
    String? reason,
    String? type,
    String? function,
    String? unidad,
    UserModel? requested,
    UserModel? requester,
    String? baseFirst,
    String? baseLast,
    String? requesterID,
    String? requestedID,
    String? referenceDate,
    DateTime? date,
    DateTime? firstDateFirst,
    DateTime? lastDateFirst,
    DateTime? firstDateLast,
    DateTime? lastDateLast,
    DateTime? at,
  }) {
    return ExchangeModel(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      type: type ?? this.type,
      function: function ?? this.function,
      unidad: unidad ?? this.unidad,
      requested: requested ?? this.requested,
      requester: requester ?? this.requester,
      baseFirst: baseFirst ?? this.baseFirst,
      baseLast: baseLast ?? this.baseLast,
      requesterID: requesterID ?? this.requesterID,
      requestedID: requestedID ?? this.requestedID,
      referenceDate: referenceDate ?? this.referenceDate,
      date: date ?? this.date,
      firstDateFirst: firstDateFirst ?? this.firstDateFirst,
      lastDateFirst: lastDateFirst ?? this.lastDateFirst,
      firstDateLast: firstDateLast ?? this.firstDateLast,
      lastDateLast: lastDateLast ?? this.lastDateLast,
      at: at ?? this.at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'reason': reason,
      'type': type,
      'function': function,
      'unidad': unidad,
      'requested': requested?.toMapResume(),
      'requester': requester?.toMapResume(),
      'baseFirst': baseFirst,
      'baseLast': baseLast,
      'requesterID': requesterID,
      'requestedID': requestedID,
      'referenceDate':
          '${date.day.toString().padLeft(2, '0')}/${date.year.toString()}',
      'date': date.millisecondsSinceEpoch,
      'firstDateFirst': firstDateFirst?.millisecondsSinceEpoch,
      'lastDateFirst': lastDateFirst?.millisecondsSinceEpoch,
      'firstDateLast': firstDateLast?.millisecondsSinceEpoch,
      'lastDateLast': lastDateLast?.millisecondsSinceEpoch,
      'at': at?.millisecondsSinceEpoch,
    };
  }

  factory ExchangeModel.fromMap(Map<String, dynamic> map) {
    return ExchangeModel(
      id: map['id'] != null ? map['id'] as String : null,
      reason: map['reason'] as String,
      type: map['type'] as String,
      function: map['function'] as String,
      unidad: map['unidad'] as String,
      requested: map['requested'] != null
          ? UserModel.fromMapResume(map['requested'] as Map<String, dynamic>)
          : null,
      requester: map['requester'] != null
          ? UserModel.fromMapResume(map['requester'] as Map<String, dynamic>)
          : null,
      baseFirst: map['baseFirst'] as String,
      baseLast: map['baseLast'] as String,
      requesterID: map['requesterID'] as String,
      requestedID: map['requestedID'] as String,
      referenceDate: map['referenceDate'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      firstDateFirst: map['firstDateFirst'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['firstDateFirst'] as int)
          : null,
      lastDateFirst: map['lastDateFirst'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastDateFirst'] as int)
          : null,
      firstDateLast: map['firstDateLast'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['firstDateLast'] as int)
          : null,
      lastDateLast: map['lastDateLast'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastDateLast'] as int)
          : null,
      at: map['at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['at'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExchangeModel.fromJson(String source) =>
      ExchangeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExchangeModel(id: $id, reason: $reason, type: $type, function: $function, unidad: $unidad, requested: $requested, requester: $requester, baseFirst: $baseFirst, baseLast: $baseLast, requesterID: $requesterID, requestedID: $requestedID, referenceDate: $referenceDate, date: $date, firstDateFirst: $firstDateFirst, lastDateFirst: $lastDateFirst, firstDateLast: $firstDateLast, lastDateLast: $lastDateLast, at: $at)';
  }

  @override
  bool operator ==(covariant ExchangeModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.reason == reason &&
        other.type == type &&
        other.function == function &&
        other.unidad == unidad &&
        other.requested == requested &&
        other.requester == requester &&
        other.baseFirst == baseFirst &&
        other.baseLast == baseLast &&
        other.requesterID == requesterID &&
        other.requestedID == requestedID &&
        other.referenceDate == referenceDate &&
        other.date == date &&
        other.firstDateFirst == firstDateFirst &&
        other.lastDateFirst == lastDateFirst &&
        other.firstDateLast == firstDateLast &&
        other.lastDateLast == lastDateLast &&
        other.at == at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        reason.hashCode ^
        type.hashCode ^
        function.hashCode ^
        unidad.hashCode ^
        requested.hashCode ^
        requester.hashCode ^
        baseFirst.hashCode ^
        baseLast.hashCode ^
        requesterID.hashCode ^
        requestedID.hashCode ^
        referenceDate.hashCode ^
        date.hashCode ^
        firstDateFirst.hashCode ^
        lastDateFirst.hashCode ^
        firstDateLast.hashCode ^
        lastDateLast.hashCode ^
        at.hashCode;
  }
}
