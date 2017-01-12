package com.cybercom.christmastree;

import android.graphics.Color;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Arrays;

/**
 * Created by yalar1 on 2016-12-26.
 */

public class RESTClient {
    private String endpoint;
    public RESTClient(String endpoint) {
        this.endpoint = endpoint;
    }

    public void changeColor(int color) {
        String[] colorValues = new String[4];
        colorValues[0] = String.format("%d", Color.red(color));
        colorValues[1] = String.format("%d", Color.green(color));
        colorValues[2] = String.format("%d", Color.blue(color));
        colorValues[3] = "1.0";

        try {
            String url = endpoint + "/changecolor";
            JSONObject json = new JSONObject();
            json.put("rgb", new JSONArray(Arrays.asList(colorValues)));

            PostRequestTaskParams params = new PostRequestTaskParams(url, json);
            PostRequestTask task = new PostRequestTask();
            task.execute(params);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
}
