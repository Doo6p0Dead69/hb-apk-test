import 'package:flutter/material.dart'; import 'package:provider/provider.dart'; import '../../state/tuner_model.dart'; import '../widgets/gauge.dart';
class TunerScreen extends StatelessWidget{ const TunerScreen({super.key});
  @override Widget build(BuildContext c)=>Consumer<TunerModel>(builder:(c,m,_){
    final cents=m.cents.clamp(-50,50).toDouble();
    return Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children:[
      Gauge(cents:cents), const SizedBox(height:16),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children:[_tile('Нота',m.note), _tile('Частота', m.freq>0? '${m.freq.toStringAsFixed(1)} Hz':'--'), _tile('Центы', m.freq>0? '${m.cents>=0?'+':''}${m.cents.toStringAsFixed(1)} ¢':'--')]),
      const SizedBox(height:12),
      LinearProgressIndicator(value:(m.snr/20).clamp(0,1), minHeight:8),
      Text('Чистота: ${m.snr.toStringAsFixed(1)}  ${m.reliable? '':'• Слабый/ненадёжный сигнал'}'),
      const Spacer(),
      FilledButton.icon(onPressed: ()=>m.toggle(), icon: Icon(m.mic? Icons.mic:Icons.mic_off), label: const Text('Микрофон')),
    ]));
  });
  Widget _tile(String t,String v)=>Column(children:[Text(t,style: const TextStyle(color:Colors.grey)), const SizedBox(height:6), Text(v,style: const TextStyle(fontSize:22,fontWeight: FontWeight.bold))]);
}
