package com.healingbowl.tuner
import android.media.*
import android.os.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
class MainActivity: FlutterActivity() {
  private val METHOD="hb_audio_control"; private val EVENT="hb_audio_stream"
  private var audioRecord: AudioRecord?=null; private var isRecording=false
  private var sampleRate=48000; private var bufSize=4096; private var streamSink: EventChannel.EventSink?=null; private var thread: Thread?=null
  override fun configureFlutterEngine(engine: FlutterEngine) {
    super.configureFlutterEngine(engine)
    MethodChannel(engine.dartExecutor.binaryMessenger, METHOD).setMethodCallHandler { call, result ->
      when(call.method){ "start"->{ start(call.argument<Int>("sampleRate")?:48000, call.argument<Int>("bufferSize")?:4096); result.success(true) }
                        "stop"->{ stopRec(); result.success(true) }
                        else -> result.notImplemented() } }
    EventChannel(engine.dartExecutor.binaryMessenger, EVENT).setStreamHandler(object: EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) { streamSink=eventSink }
      override fun onCancel(arguments: Any?) { streamSink=null }
    })
  }
  private fun start(sr:Int, bs:Int){
    if(isRecording) return; sampleRate=sr; bufSize=bs
    val minBuf=AudioRecord.getMinBufferSize(sampleRate, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT)
    val finalBuf = if (minBuf>bs) minBuf else bs
    audioRecord = AudioRecord.Builder().setAudioSource(MediaRecorder.AudioSource.VOICE_RECOGNITION)
      .setAudioFormat(AudioFormat.Builder().setEncoding(AudioFormat.ENCODING_PCM_16BIT).setSampleRate(sampleRate).setChannelMask(AudioFormat.CHANNEL_IN_MONO).build())
      .setBufferSizeInBytes(finalBuf*2).build()
    audioRecord?.startRecording(); isRecording=true
    thread = Thread {
      val buf = ShortArray(bufSize)
      while(isRecording){
        val r = audioRecord?.read(buf,0,buf.size)?:0
        if(r>0){ Handler(Looper.getMainLooper()).post { streamSink?.success(buf.take(r)) } }
      }
    }; thread?.start()
  }
  private fun stopRec(){ isRecording=false; thread?.join(200); thread=null; audioRecord?.stop(); audioRecord?.release(); audioRecord=null }
}
