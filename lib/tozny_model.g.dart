// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tozny_model.dart';

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
      created: $checkedConvert(json, 'created',
          (v) => v == null ? null : DateTime.parse(v as String)),
      lastModified: $checkedConvert(json, 'last_modified',
          (v) => v == null ? null : DateTime.parse(v as String)),
      version: $checkedConvert(json, 'version', (v) => v as String),
      type: $checkedConvert(json, 'type', (v) => v as String),
      plain: $checkedConvert(json, 'plain', (v) => v as Map<String, dynamic>),
      file: $checkedConvert(
          json, 'file', (v) => v == null ? null : FileMeta.fromJson(v)),
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
      'created': instance.created?.toIso8601String(),
      'last_modified': instance.lastModified?.toIso8601String(),
      'version': instance.version,
      'type': instance.type,
      'plain': instance.plain,
      'file': instance.file?.toJson(),
    };

FileMeta _$FileMetaFromJson(Map<String, dynamic> json) {
  return FileMeta(
    fileUrl: json['file_url'] as String,
    fileName: json['file_name'] as String,
    checksum: json['checksum'] as String,
    compression: json['compression'] as String,
    size: json['size'] as int,
  );
}

Map<String, dynamic> _$FileMetaToJson(FileMeta instance) => <String, dynamic>{
      'file_url': instance.fileUrl,
      'file_name': instance.fileName,
      'checksum': instance.checksum,
      'compression': instance.compression,
      'size': instance.size,
    };

RealmConfig _$RealmConfigFromJson(Map<String, dynamic> json) {
  return RealmConfig(
    realmName: json['realm_name'] as String,
    appName: json['app_name'] as String,
    brokerTargetURL: json['broker_target_url'] as String,
    apiURL: json['api_url'] as String,
  );
}

Map<String, dynamic> _$RealmConfigToJson(RealmConfig instance) =>
    <String, dynamic>{
      'realm_name': instance.realmName,
      'app_name': instance.appName,
      'broker_target_url': instance.brokerTargetURL,
      'api_url': instance.apiURL,
    };

PartialIdentityConfig _$PartialIdentityConfigFromJson(
    Map<String, dynamic> json) {
  return $checkedNew('PartialIdentityConfig', json, () {
    final val = PartialIdentityConfig(
      identityConfig: $checkedConvert(
          json, 'identity_config', (v) => IdentityConfig.fromJson(v)),
      credentials: $checkedConvert(
          json, 'client_credentials', (v) => ClientCredentials.fromJson(v)),
    );
    return val;
  }, fieldKeyMap: const {
    'identityConfig': 'identity_config',
    'credentials': 'client_credentials'
  });
}

Map<String, dynamic> _$PartialIdentityConfigToJson(
        PartialIdentityConfig instance) =>
    <String, dynamic>{
      'client_credentials': instance.credentials.toJson(),
      'identity_config': instance.identityConfig.toJson(),
    };

IdentityClientConfig _$IdentityClientConfigFromJson(Map<String, dynamic> json) {
  return $checkedNew('IdentityClientConfig', json, () {
    final val = IdentityClientConfig(
      identityConfig: $checkedConvert(
          json, 'identity_config', (v) => IdentityConfig.fromJson(v)),
      credentials: $checkedConvert(
          json, 'client_credentials', (v) => ClientCredentials.fromJson(v)),
      userAgentToken: $checkedConvert(
          json, 'user_agent_token', (v) => AgentToken.fromJson(v)),
    );
    return val;
  }, fieldKeyMap: const {
    'identityConfig': 'identity_config',
    'credentials': 'client_credentials',
    'userAgentToken': 'user_agent_token'
  });
}

Map<String, dynamic> _$IdentityClientConfigToJson(
        IdentityClientConfig instance) =>
    <String, dynamic>{
      'client_credentials': instance.credentials.toJson(),
      'identity_config': instance.identityConfig.toJson(),
      'user_agent_token': instance.userAgentToken.toJson(),
    };

AgentToken _$AgentTokenFromJson(Map<String, dynamic> json) {
  return $checkedNew('AgentToken', json, () {
    final val = AgentToken(
      accessToken: $checkedConvert(json, 'access_token', (v) => v as String),
      tokenType: $checkedConvert(json, 'token_type', (v) => v as String),
      expiry: $checkedConvert(json, 'expiry', (v) => v as int),
    );
    return val;
  }, fieldKeyMap: const {
    'accessToken': 'access_token',
    'tokenType': 'token_type'
  });
}

Map<String, dynamic> _$AgentTokenToJson(AgentToken instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expiry': instance.expiry,
    };

IdentityConfig _$IdentityConfigFromJson(Map<String, dynamic> json) {
  return $checkedNew('IdentityConfig', json, () {
    final val = IdentityConfig(
      apiURL: $checkedConvert(json, 'api_url', (v) => v as String),
      appName: $checkedConvert(json, 'appName', (v) => v as String),
      brokerTargetUrl:
          $checkedConvert(json, 'broker_target_url', (v) => v as String),
      realmName: $checkedConvert(json, 'realm_name', (v) => v as String),
      userId: $checkedConvert(json, 'user_id', (v) => v as int),
      username: $checkedConvert(json, 'username', (v) => v as String),
    );
    return val;
  }, fieldKeyMap: const {
    'apiURL': 'api_url',
    'brokerTargetUrl': 'broker_target_url',
    'realmName': 'realm_name',
    'userId': 'user_id'
  });
}

Map<String, dynamic> _$IdentityConfigToJson(IdentityConfig instance) =>
    <String, dynamic>{
      'api_url': instance.apiURL,
      'appName': instance.appName,
      'broker_target_url': instance.brokerTargetUrl,
      'realm_name': instance.realmName,
      'user_id': instance.userId,
      'username': instance.username,
    };
