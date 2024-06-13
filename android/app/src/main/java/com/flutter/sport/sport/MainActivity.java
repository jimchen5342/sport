package com.flutter.sport.sport;

import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.view.WindowManager;
import android.widget.Toast;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
// import com.ixsans.text_to_speech.Tts;

public class MainActivity extends FlutterActivity {
    private MediaPlayer mPlayer = null;
    // private Tts tts;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // 在螢幕關閉後繼續執行應用程式
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        // tts = new Tts(this.getApplicationContext());
        // tts.setLanguage("en-US");
        // tts.speak("hello, jim");
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(
                flutterEngine.getDartExecutor(),
                "com.flutter/MethodChannel")
                .setMethodCallHandler(mMethodHandle);
    }

    MethodChannel.MethodCallHandler mMethodHandle = new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if(call.method.equals("beep")) {
                beep();
            }
        }
    };

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
        }
    }
}
