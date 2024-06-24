package com.flutter.sport;
import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.speech.tts.TextToSpeech;
import android.widget.Toast;
import java.util.Calendar;
import java.util.Locale;

public class TimeService extends Service implements TextToSpeech.OnInitListener {
    private TextToSpeech tts;
    private Handler handler;
    private Runnable runnable;

    static String ACTION = "";

    @Override
    public void onCreate() {
        super.onCreate();
        tts = new TextToSpeech(this, this);
        handler = new Handler();
        runnable = new Runnable() {
            @Override
            public void run() {
                announceTime();
                handler.postDelayed(this, 30 * 1000);
            }
        };
        handler.post(runnable);
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
//            int result = tts.setLanguage(Locale.TAIWAN);
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
        String timeText = String.format(Locale.US, "%02d:%02d:%02d", hour, minute, second);

        Toast.makeText(this, "Service: " + timeText, Toast.LENGTH_SHORT).show();

        Intent intent = new Intent();
        intent.setAction(ACTION);
        intent.putExtra("time",timeText);
        sendBroadcast(intent);

//        tts.speak(timeText, TextToSpeech.QUEUE_FLUSH, null, null);
    }
}