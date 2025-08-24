import 'dart:typed_data'; import 'package:flutter/services.dart'; import 'package:permission_handler/permission_handler.dart';
class AudioStream{
  static const _method=MethodChannel('hb_audio_control'); static const _event=EventChannel('hb_audio_stream');
  Stream<dynamic>? _stream;
  Future<bool> start(int sr,int bs,void Function(Int16List) onData) async {
    final mic=await Permission.microphone.request(); if(!mic.isGranted) return false;
    _stream=_event.receiveBroadcastStream(); _stream!.listen((e){ if(e is List){ onData(Int16List.fromList(List<int>.from(e))); } });
    await _method.invokeMethod('start', {'sampleRate':sr,'bufferSize':bs}); return true;
  }
  Future<void> stop() async { await _method.invokeMethod('stop'); }
}
