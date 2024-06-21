package com.flutter.sport;
import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.speech.tts.TextToSpeech;
import android.widget.Toast;
import java.util.Calendar;
import java.util.Locale;

import io.flutter.Log;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.view.FlutterMain;

public class TimeService extends Service implements TextToSpeech.OnInitListener {
    private TextToSpeech tts;
    private Handler handler;
    private Runnable runnable;

    private FlutterEngine flutterEngine;
    private BasicMessageChannel<String> messageChannel;

    @Override
    public void onCreate() {
        super.onCreate();
        tts = new TextToSpeech(this, this);
        handler = new Handler();
        runnable = new Runnable() {
            @Override
            public void run() {
                announceTime();
                handler.postDelayed(this, 10 * 1000);
            }
        };
        handler.post(runnable);

        flutterEngine = new FlutterEngine(this);

        messageChannel = new BasicMessageChannel<>(
                flutterEngine.getDartExecutor(), // .getBinaryMessenger(),
                "com.flutter/BasicMessageChannel",
                StringCodec.INSTANCE
        );

        messageChannel.setMessageHandler((message, reply) -> {
            Log.i("TimeService", "Received message from Dart: " + message);
            reply.reply("Message received on Android side");
        });

        flutterEngine.getDartExecutor().executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
        );

        Toast.makeText(this, "startService", Toast.LENGTH_SHORT).show();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        handler.removeCallbacks(runnable);
        if (tts != null) {
            tts.stop();
            tts.shutdown();
        }
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onInit(int status) {
        if (status == TextToSpeech.SUCCESS) {
            int result = tts.setLanguage(Locale.US);
            if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                Toast.makeText(this, "Language not supported", Toast.LENGTH_SHORT).show();
            }
        } else {
            Toast.makeText(this, "TTS Initialization failed", Toast.LENGTH_SHORT).show();
        }
    }

    private void announceTime() {
        Calendar calendar = Calendar.getInstance();
        int hour = calendar.get(Calendar.HOUR_OF_DAY);
        int minute = calendar.get(Calendar.MINUTE);
        int second = calendar.get(Calendar.SECOND);
        String timeText = String.format(Locale.US, "The time is %02d:%02d:%02d", hour, minute, second);

        Toast.makeText(this, timeText, Toast.LENGTH_SHORT).show();
        tts.speak(timeText, TextToSpeech.QUEUE_FLUSH, null, null);

        messageChannel.send(timeText);
    }
}