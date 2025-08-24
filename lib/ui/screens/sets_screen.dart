import 'dart:convert'; import 'dart:io';
import 'package:flutter/material.dart'; import 'package:path_provider/path_provider.dart'; import 'package:provider/provider.dart';
import '../../state/tuner_model.dart'; import '../../models/bowl_set.dart'; import '../../models/bowl.dart';
class SetsScreen extends StatelessWidget{ const SetsScreen({super.key});
  @override Widget build(BuildContext c)=>Consumer<TunerModel>(builder:(c,m,_){ final set=m.set!;
    return Padding(padding: const EdgeInsets.all(12), child: Column(children:[
      Row(children:[ Expanded(child: Text('Набор: ${set.name}', style: const TextStyle(fontSize:18,fontWeight: FontWeight.bold))),
        IconButton(onPressed: () async { await _export(set); ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content: Text('Экспортирован bowl_set.json в Documents'))); }, icon: const Icon(Icons.upload)),
        IconButton(onPressed: () async { final s=await _import(); if(s!=null){ m.set=s; } }, icon: const Icon(Icons.download)),
      ]),
      Expanded(child: ListView.builder(itemCount:set.items.length, itemBuilder:(c,i){ final b=set.items[i]; return Card(child: ListTile(
        title: Text(b.name), subtitle: Text('Target: ${b.targetNote} • ${b.offsetCents.toStringAsFixed(1)} ¢ • ${b.direction>0?'+':'-'}'),
      )); })),
      FilledButton.icon(onPressed: (){ m.set = BowlSet(name:'Набор', items: List.generate(7,(i)=>Bowl(name:'Чаша ${i+1}',targetNote:'A4'))); }, icon: const Icon(Icons.add), label: const Text('Новый набор'))
    ]));
  });
  Future<void> _export(BowlSet set) async { final d=await getApplicationDocumentsDirectory(); final f=File('${d.path}/bowl_set.json'); await f.writeAsString(jsonEncode(set.toJson())); }
  Future<BowlSet?> _import() async { final d=await getApplicationDocumentsDirectory(); final f=File('${d.path}/bowl_set.json'); if(await f.exists()){ return BowlSet.fromJson(jsonDecode(await f.readAsString())); } return null; }
}
