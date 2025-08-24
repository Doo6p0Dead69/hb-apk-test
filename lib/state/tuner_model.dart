import 'dart:typed_data'; import 'package:flutter/foundation.dart';
import '../audio/audio_stream.dart'; import '../models/settings.dart'; import '../models/bowl.dart'; import '../models/bowl_set.dart';
import '../dsp/pitch_detector.dart'; import 'package:shared_preferences/shared_preferences.dart'; import 'dart:convert';
class TunerModel extends ChangeNotifier{
  final audio=AudioStream(); final settings=Settings();
  late PitchDetector det; bool mic=false; double freq=-1, cents=0, snr=0; bool reliable=false; String note='--';
  List<int> _ring=[]; int _hop=2048; BowlSet? set;
  Future<void> init() async {
    det=PitchDetector(settings.sampleRate, settings.bufferSize); _hop=(settings.bufferSize/2).round();
    final sp=await SharedPreferences.getInstance(); final s=sp.getString('bowl_set');
    set = s!=null? BowlSet.fromJson(jsonDecode(s)) : BowlSet(name:'Набор', items: List.generate(7,(i)=>Bowl(name:'Чаша ${i+1}',targetNote:'A4')));
    notifyListeners();
  }
  Future<void> toggle() async {
    if(mic){ await audio.stop(); mic=false; notifyListeners(); return; }
    mic = await audio.start(settings.sampleRate, settings.bufferSize, _onPcm); notifyListeners();
  }
  void _onPcm(Int16List pcm){
    _ring.addAll(pcm); if(_ring.length<settings.bufferSize) return;
    final frame=_ring.take(settings.bufferSize).toList(); _ring=_ring.skip(_hop).toList();
    final x = List<double>.generate(frame.length,(i)=>frame[i]/32768.0);
    final r = det.process(x); snr=r.snr; reliable=r.reliable; freq=r.freq;
    if(freq>0){ final n = Note.fromFreq(freq, a4: settings.a4); note=n.label; cents=n.cents; } else { note='--'; cents=0; }
    notifyListeners();
  }
}
