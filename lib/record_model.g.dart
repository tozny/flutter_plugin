// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientCredentials _$ClientCredentialsFromJson(Map<String, dynamic> json) {
  return $checkedNew('ClientCredentials', json, () {
    final val = ClientCredentials(
      apiKey: $checkedConvert(json, 'api_key_id', (v) => v as String),
      apiSecret: $checkedConvert(json, 'api_secret', (v) => v as String),
      clientId: $checkedConvert(json, 'client_id', (v) => v as String),
      publicKey: $checkedConvert(json, 'public_key', (v) => v as String),
      privateKey: $checkedConvert(json, 'private_key', (v) => v as String),
      publicSignKey:
          $checkedConvert(json, 'public_signing_key', (v) => v as String),
      privateSigningKey:
          $checkedConvert(json, 'private_signing_key', (v) => v as String),
      host: $checkedConvert(json, 'api_url', (v) => v as String),
      email: $checkedConvert(json, 'client_email', (v) => v as String),
    );
    return val;
  }, fieldKeyMap: const {
    'apiKey': 'api_key_id',
    'apiSecret': 'api_secret',
    'clientId': 'client_id',
    'publicKey': 'public_key',
    'privateKey': 'private_key',
    'publicSignKey': 'public_signing_key',
    'privateSigningKey': 'private_signing_key',
    'host': 'api_url',
    'email': 'client_email'
  });
}

Map<String, dynamic> _$ClientCredentialsToJson(ClientCredentials instance) =>
    <String, dynamic>{
      'api_key_id': instance.apiKey,
      'api_secret': instance.apiSecret,
      'client_id': instance.clientId,
      'client_email': instance.email,
      'public_key': instance.publicKey,
      'private_key': instance.privateKey,
      'public_signing_key': instance.publicSignKey,
      'private_signing_key': instance.privateSigningKey,
      'api_url': instance.host,
    };

Record _$RecordFromJson(Map<String, dynamic> json) {
  return $checkedNew('Record', json, () {
    final val = Record(
      data: $checkedConvert(json, 'data', (v) => v as Map<String, dynamic>),
      metaData:
          $checkedConvert(json, 'meta_data', (v) => RecordMeta.fromJson(v)),
    );
    return val;
  }, fieldKeyMap: const {'metaData': 'meta_data'});
}

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'data': instance.data,
      'meta_data': instance.metaData.toJson(),
    };

RecordMeta _$RecordMetaFromJson(Map<String, dynamic> json) {
  return $checkedNew('RecordMeta', json, () {
    final val = RecordMeta(
      recordID: $checkedConvert(json, 'record_id', (v) => v as String),
      writerID: $checkedConvert(json, 'writer_id', (v) => v as String),
      userID: $checkedConvert(json, 'user_id', (v) => v as String),
      created:
          $checkedConvert(json, 'created', (v) => DateTime.parse(v as String)),
      lastModified: $checkedConvert(
          json, 'last_modified', (v) => DateTime.parse(v as String)),
      version: $checkedConvert(json, 'version', (v) => v as String),
      type: $checkedConvert(json, 'type', (v) => v as String),
      plain: $checkedConvert(json, 'plain', (v) => v as Map<String, dynamic>),
    );
    return val;
  }, fieldKeyMap: const {
    'recordID': 'record_id',
    'writerID': 'writer_id',
    'userID': 'user_id',
    'lastModified': 'last_modified'
  });
}

Map<String, dynamic> _$RecordMetaToJson(RecordMeta instance) =>
    <String, dynamic>{
      'record_id': instance.recordID,
      'writer_id': instance.writerID,
      'user_id': instance.userID,
      'created': instance.created.toIso8601String(),
      'last_modified': instance.lastModified.toIso8601String(),
      'version': instance.version,
      'type': instance.type,
      'plain': instance.plain,
    };

FileMeta _$FileMetaFromJson(Map<String, dynamic> json) {
  return FileMeta(
    fileUrl: json['file_url'] as String,
    fileName: json['file_name'] as String,
    checksum: json['checksum'] as String,
    size: json['size'] as int,
  );
}

Map<String, dynamic> _$FileMetaToJson(FileMeta instance) => <String, dynamic>{
      'file_url': instance.fileUrl,
      'file_name': instance.fileName,
      'checksum': instance.checksum,
      'size': instance.size,
    };
