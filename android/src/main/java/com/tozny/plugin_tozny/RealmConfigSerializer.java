package com.tozny.plugin_tozny;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.net.URI;

public class RealmConfigSerializer {
    @JsonProperty("realm_name")
    public String realmName;

    @JsonProperty("app_name")
    public String appName;

    @JsonProperty("broker_target_url")
    public URI brokerTargetURL;

    @JsonProperty("api_url")
    public URI apiURL;
}
