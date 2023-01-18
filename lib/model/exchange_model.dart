// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/user_model.dart';

class ExchangeModel {
  String? id;
  String reason;
  UserModel? requested;
  UserModel? requester;
  UserModel? authorizer;
  String baseFirst;
  String baseLast;
  String requesterID;
  String requestedID;
  String authorizerID;
  String referenceDate;
  DateTime date;
  DateTime? dateFirst;
  DateTime? dateLast;
  DateTime? requestedAuthorizedDate;
  DateTime? requesterAuthorizedDate;
  DateTime? authorizedDate;
  DateTime? at;

  ExchangeModel({
    this.id,
    this.reason = '',
    this.requested,
    this.requester,
    this.authorizer,
    this.baseFirst = '',
    this.baseLast = '',
    this.requesterID = '',
    this.requestedID = '',
    this.authorizerID = '',
    this.referenceDate = '',
    required this.date,
    this.dateFirst,
    this.dateLast,
    this.requestedAuthorizedDate,
    this.requesterAuthorizedDate,
    this.authorizedDate,
    this.at,
  });

  ExchangeModel copyWith({
    String? id,
    String? reason,
    UserModel? requested,
    UserModel? requester,
    UserModel? authorizer,
    String? baseFirst,
    String? baseLast,
    String? requesterID,
    String? requestedID,
    String? authorizerID,
    String? referenceDate,
    DateTime? date,
    DateTime? dateFirst,
    DateTime? dateLast,
    DateTime? requestedAuthorizedDate,
    DateTime? requesterAuthorizedDate,
    DateTime? authorizedDate,
    DateTime? at,
  }) {
    return ExchangeModel(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      requested: requested ?? this.requested,
      requester: requester ?? this.requester,
      authorizer: authorizer ?? this.authorizer,
      baseFirst: baseFirst ?? this.baseFirst,
      baseLast: baseLast ?? this.baseLast,
      requesterID: requesterID ?? this.requesterID,
      requestedID: requestedID ?? this.requestedID,
      authorizerID: authorizerID ?? this.authorizerID,
      referenceDate: referenceDate ?? this.referenceDate,
      date: date ?? this.date,
      dateFirst: dateFirst ?? this.dateFirst,
      dateLast: dateLast ?? this.dateLast,
      requestedAuthorizedDate:
          requestedAuthorizedDate ?? this.requestedAuthorizedDate,
      requesterAuthorizedDate:
          requesterAuthorizedDate ?? this.requesterAuthorizedDate,
      authorizedDate: authorizedDate ?? this.authorizedDate,
      at: at ?? this.at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'reason': reason,
      'requested': requested?.toMapResume(),
      'requester': requester?.toMapResume(),
      'authorizer': authorizer?.toMapResume(),
      'baseFirst': baseFirst,
      'baseLast': baseLast,
      'requesterID': requesterID,
      'requestedID': requestedID,
      'authorizerID': authorizerID,
      'date': date.millisecondsSinceEpoch,
      'dateFirst': dateFirst?.millisecondsSinceEpoch,
      'dateLast': dateLast?.millisecondsSinceEpoch,
      'requestedAuthorizedDate':
          requestedAuthorizedDate?.millisecondsSinceEpoch,
      'requesterAuthorizedDate':
          requesterAuthorizedDate?.millisecondsSinceEpoch,
      'authorizedDate': authorizedDate?.millisecondsSinceEpoch,
      'referenceDate': "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}",
      'referenceMonth': "${date.month.toString().padLeft(2, '0')}/${date.year}",
      'at': at
    };
  }

  factory ExchangeModel.fromMap(Map<String, dynamic> map) {
    return ExchangeModel(
      id: map['id'] ?? '',
      reason: map['reason'] ?? '',
      requested:
          map['requested'] != null ? UserModel.fromMapResume(map['requested']) : null,
      requester:
          map['requester'] != null ? UserModel.fromMapResume(map['requester']) : null,
      authorizer: map['authorizer'] != null
          ? UserModel.fromMapResume(map['authorizer'])
          : null,
      baseFirst: map['baseFirst'] ?? '',
      baseLast: map['baseLast'] ?? '',
      requesterID: map['requesterID'] ?? '',
      requestedID: map['requestedID'] ?? '',
      authorizerID: map['authorizerID'] ?? '',
      referenceDate: map['referenceDate'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      dateFirst: map['dateFirst'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateFirst'])
          : null,
      dateLast: map['dateLast'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateLast'])
          : null,
      requestedAuthorizedDate: map['requestedAuthorizedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['requestedAuthorizedDate'] as int)
          : null,
      requesterAuthorizedDate: map['requesterAuthorizedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['requesterAuthorizedDate'] as int)
          : null,
      authorizedDate: map['authorizedDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['authorizedDate'] as int)
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
    return 'ExchangeModel(id: $id, reason: $reason, requested: $requested, requester: $requester, authorizer: $authorizer, baseFirst: $baseFirst, baseLast: $baseLast, requesterID: $requesterID, requestedID: $requestedID, authorizerID: $authorizerID, referenceDate: $referenceDate, date: $date, dateFirst: $dateFirst, dateLast: $dateLast, requestedAuthorizedDate: $requestedAuthorizedDate, requesterAuthorizedDate: $requesterAuthorizedDate, authorizedDate: $authorizedDate, at: $at)';
  }
}
