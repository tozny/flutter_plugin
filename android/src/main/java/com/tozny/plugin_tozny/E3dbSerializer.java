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
        // TODO filemeta
        try {
            return mapper.writeValueAsString(metaMap);
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
}
