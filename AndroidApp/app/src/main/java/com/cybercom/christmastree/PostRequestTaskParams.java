package com.cybercom.christmastree;

import org.json.JSONObject;

/**
 * Created by yalar1 on 2016-12-27.
 */

public class PostRequestTaskParams {
    String url;
    JSONObject data;

    PostRequestTaskParams(String url, JSONObject data) {
        this.url = url;
        this.data = data;
    }
}
