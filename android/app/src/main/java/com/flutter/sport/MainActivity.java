package com.flutter.sport;

import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Handler;
import android.view.WindowManager;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private MediaPlayer mPlayer = null;
//    BasicMessageChannel messageChannel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // 在螢幕關閉後繼續執行應用程式
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(
                flutterEngine.getDartExecutor(),
                "com.flutter/MethodChannel")
                .setMethodCallHandler(mMethodHandle);

//        messageChannel = new BasicMessageChannel(flutterEngine.getDartExecutor(), "com.flutter/BasicMessageChannel",
//                StandardMessageCodec.INSTANCE);
//        messageChannel.setMessageHandler(mMessageHandler);

    }
    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();

    }

    MethodChannel.MethodCallHandler mMethodHandle = new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if(call.method.equals("beep")) {
                beep();
            }
        }
    };

//    BasicMessageChannel.MessageHandler<Object> mMessageHandler = new BasicMessageChannel.MessageHandler<Object>() {
//        @Override
//        public void onMessage(Object o, BasicMessageChannel.Reply<Object> reply) {
//            reply.reply("messageChannel: 返回给flutter的数据");
//        }
//    };


    void beep(){
        if(mPlayer == null) {
            String src = "beep.mp3";
            try {
                AssetManager assetManager = this.getAssets();
                AssetFileDescriptor afd = assetManager.openFd(src);
                mPlayer = new MediaPlayer();
                mPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                    @Override
                    public void onCompletion(MediaPlayer mp) {
                        mPlayer.release();
                        mPlayer = null;
                    }
                });

                mPlayer.setOnErrorListener(new MediaPlayer.OnErrorListener() {
                    @Override
                    public boolean onError(MediaPlayer mp, int what, int extra) {
                        mPlayer = null;
                        return false;
                    }
                });

                mPlayer.setDataSource(afd.getFileDescriptor(),
                        afd.getStartOffset(), afd.getLength());
                mPlayer.prepare();
                mPlayer.setLooping(false);
                mPlayer.start();
//                Toast.makeText(this, "beep: " + afd.toString(), Toast.LENGTH_LONG).show();
            } catch (Exception e) {
                e.printStackTrace();
                mPlayer = null;
            }
        } else {
            mPlayer.start();
        }
    }
}
