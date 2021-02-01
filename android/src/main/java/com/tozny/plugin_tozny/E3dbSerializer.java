package com.tozny.plugin_tozny;

import android.os.Build;

import androidx.annotation.RequiresApi;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;
import com.tozny.e3db.*;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

public class E3dbSerializer {
    private static final ObjectMapper mapper = new ObjectMapper();
    private static DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZZZZZ");

    static String recordMetaToJson(RecordMeta meta) {
        Map<String, Object> metaMap = new HashMap<>();
        metaMap.put("record_id", meta.recordId().toString());
        metaMap.put("user_id", meta.userId().toString());
        metaMap.put("writer_id", meta.writerId().toString());
        metaMap.put("created", dateFormatter.format(meta.created()));
        metaMap.put("last_modified", dateFormatter.format(meta.lastModified()));
        metaMap.put("version", meta.version());
        metaMap.put("type", meta.type());
        metaMap.put("plain", new JSONObject(meta.plain()).toString());
        metaMap.put("file_meta", fileMetaToJson(meta.file()));
        try {
            return mapper.writeValueAsString(metaMap);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    static String fileMetaToJson(FileMeta meta) {
        if (meta == null) {
            return null;
        }
        Map<String, Object> map = new HashMap<>();
        map.put("file_url", meta.fileUrl() != null ? meta.fileUrl() : "");
        map.put("file_name", meta.fileName());
        map.put("checksum", meta.checksum());
        map.put("compression", meta.compression());
        map.put("long", meta.size());
        try {
            return mapper.writeValueAsString(map);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    static String recordToJson(Record record) {
        Map<String, Object> map = new HashMap<>();
        map.put("meta_data", E3dbSerializer.recordMetaToJson(record.meta()));
        map.put("data", record.data());
        try {
            return mapper.writeValueAsString(map);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    static Realm realmFromJson(String json) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            RealmConfigSerializer realmConfig = mapper.readValue(json, RealmConfigSerializer.class);
            return new Realm(realmConfig.realmName, realmConfig.appName, realmConfig.brokerTargetURL, realmConfig.apiURL);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    static String partialIdClientToJson(PartialIdentityClient id) {
        Map<String, Object> map = new HashMap<>();
        try {
            map.put("client_credentials", id.getClient().getConfig().json());
            map.put("identity_config", E3dbSerializer.idConfigToJson(id.getIdentityConfig()));
            return mapper.writeValueAsString(map);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    static String idClientToJson(IdentityClient id) {
        Map<String, Object> map = new HashMap<>();
        try {
            map.put("client_credentials", id.getClient().getConfig().json());
            map.put("identity_config", E3dbSerializer.idConfigToJson(id.getIdentityConfig()));
            map.put("user_agent_token", E3dbSerializer.userAgentTokenToJson(id.getToken()));
            return mapper.writeValueAsString(map);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    static String userAgentTokenToJson(AgentToken tok) {
        Map<String, Object> map = new HashMap<>();
        try {
            map.put("access_token", tok.getToken());
            map.put("token_type", tok.getTokenType());
            map.put("expiry", tok.getExpiry());
            return mapper.writeValueAsString(map);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    static String idConfigToJson(IdentityConfig id) {
        try {
            Map<String, Object> map = new HashMap<>();
            map.put("api_url", id.getApiURL().getPath());
            map.put("app_name", id.getAppName());
            map.put("broker_target_url", id.getBrokerTargetUrl());
            map.put("realm_name", id.getRealmName());
            map.put("user_id", id.getUserId());
            map.put("username", id.getUsername());

            return mapper.writeValueAsString(map);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
