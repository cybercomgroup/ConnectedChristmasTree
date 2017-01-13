package com.cybercom.christmastree;

import android.text.method.NumberKeyListener;

/**
 * Created by yalar1 on 2016-12-21.
 */

public class IPAddressKeyListener extends NumberKeyListener {
    @Override
    protected char[] getAcceptedChars() {
        return new char[0];
    }

    @Override
    public int getInputType() {
        return 0;
    }
}
