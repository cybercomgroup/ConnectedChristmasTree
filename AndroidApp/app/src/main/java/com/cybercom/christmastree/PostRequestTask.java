package com.cybercom.christmastree;

import android.os.AsyncTask;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.UnknownHostException;

/**
 * Created by yalar1 on 2016-12-27.
 */

public class PostRequestTask extends AsyncTask<PostRequestTaskParams, Void, Boolean> {
    @Override
    protected Boolean doInBackground(PostRequestTaskParams... params) {
        OutputStream out = null;
        InputStream in = null;
        HttpURLConnection conn = null;

        try {
            URL url = new URL(params[0].url);
            String message = params[0].data.toString();

            conn = (HttpURLConnection) url.openConnection();
            conn.setReadTimeout(10000);
            conn.setConnectTimeout(15000);
            conn.setRequestMethod("POST");
            conn.setDoInput(true);
            conn.setDoOutput(true);
            conn.setFixedLengthStreamingMode(message.getBytes().length);
            conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");

            conn.connect();

            out = new BufferedOutputStream(conn.getOutputStream());
            out.write(message.getBytes());

            out.flush();

            in = conn.getInputStream();
        } catch (MalformedURLException|UnknownHostException e) {
            e.printStackTrace();
            return false;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
                if (in != null) {
                    in.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            conn.disconnect();
        }

        return true;
    }

    @Override
    protected void onPostExecute(Boolean result) {
        if (result) {
            System.out.println("Data has been sent successfully");
        } else {
            System.out.println("Error sending data");
        }
    }
}
