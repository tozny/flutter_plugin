import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'tozny_model.g.dart';

@JsonSerializable(nullable: false, explicitToJson: true, checked: true)
class ClientCredentials {
  
  @JsonKey(name: 'api_key_id')
  String apiKey;
  @JsonKey(name: 'api_secret')
  String apiSecret;
  @JsonKey(name: 'client_id')
  String clientId;
  @JsonKey(name: 'client_email')
  String email;
  @JsonKey(name: 'public_key')
  String publicKey;
  @JsonKey(name: 'private_key')
  String privateKey;
  @JsonKey(name: 'public_signing_key')
  String publicSignKey;
  @JsonKey(name: 'private_signing_key')
  String privateSigningKey;
  @JsonKey(name: 'api_url')
  String host;

  ClientCredentials({
    this.apiKey,
    this.apiSecret,
    this.clientId,
    this.publicKey,
    this.privateKey,
    this.publicSignKey,
    this.privateSigningKey,
    this.host,
    this.email
  });

  factory ClientCredentials.fromJson(dynamic json) => _$ClientCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$ClientCredentialsToJson(this);
}

@JsonSerializable(nullable: false, explicitToJson: true, checked: true)
class Record {
  Map data;
  @JsonKey(name: 'meta_data')
  RecordMeta metaData;

  Record({
    this.data,
    this.metaData
  });

  factory Record.fromValidJsonString(String json) {
    dynamic parsedRecord = jsonDecode(json);
    dynamic parsedMeta = jsonDecode(parsedRecord["meta_data"]);
    dynamic parsedPlain = jsonDecode(parsedMeta["plain"]);
    parsedMeta["plain"] = parsedPlain;
    parsedRecord["meta_data"] = parsedMeta;
    return Record.fromJson(parsedRecord);
  }

  factory Record.fromJson(dynamic json) => _$RecordFromJson(json);
  Map<String, dynamic> toJson() => _$RecordToJson(this);
}

@JsonSerializable(nullable: false, explicitToJson: true, checked: true)
class RecordMeta {
  @JsonKey(name: 'record_id')
  String recordID;
  @JsonKey(name: 'writer_id')
  String writerID;
  @JsonKey(name: 'user_id')
  String userID;
  @JsonKey(name: 'created')
  DateTime created;
  @JsonKey(name: 'last_modified')
  DateTime lastModified;
  @JsonKey(name: 'version')
  String version;
  @JsonKey(name: 'type')
  String type;
  @JsonKey(name: 'plain')
  Map plain;
  // TODO: add filemeta

  RecordMeta({
    this.recordID,
    this.writerID,
    this.userID,
    this.created,
    this.lastModified,
    this.version,
    this.type,
    this.plain
  });

  factory RecordMeta.fromValidJsonString(String json) {
    dynamic parsedMeta = jsonDecode(json);
    dynamic parsedPlain = jsonDecode(parsedMeta["plain"]);
    parsedMeta["plain"] = parsedPlain;
    return RecordMeta.fromJson(parsedMeta);
  }

  factory RecordMeta.fromJson(dynamic json) => _$RecordMetaFromJson(json);
  Map<String, dynamic> toJson() => _$RecordMetaToJson(this);
}

@JsonSerializable(nullable: false)
class FileMeta {
  @JsonKey(name: 'file_url')
  String fileUrl;
  @JsonKey(name: 'file_name')
  String fileName;
  String checksum;
  int size;

  FileMeta({
    this.fileUrl,
    this.fileName,
    this.checksum,
    this.size
  });

  factory FileMeta.fromJson(dynamic json) => _$FileMetaFromJson(json);
  Map<String, dynamic> toJson() => _$FileMetaToJson(this);
}
