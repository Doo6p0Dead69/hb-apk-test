import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/tuner_model.dart';
import 'ui/screens/tuner_screen.dart';
import 'ui/screens/sets_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/calibration_screen.dart';
void main(){ runApp(const App()); }
class App extends StatelessWidget{ const App({super.key});
  @override Widget build(BuildContext c)=>ChangeNotifierProvider(create: (_)=>TunerModel()..init(), child: MaterialApp(
    title:'Healing Bowl Tuner', theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3:true),
    home: const Home(),
  ));
}
class Home extends StatefulWidget{ const Home({super.key}); @override State<Home> createState()=>_HomeState(); }
class _HomeState extends State<Home>{ int i=0; final pages=const [TunerScreen(),SetsScreen(),CalibrationScreen(),SettingsScreen()];
  @override Widget build(BuildContext c)=>Scaffold(
    appBar: AppBar(title: const Text('Тюнер поющих чаш')),
    body: pages[i],
    bottomNavigationBar: NavigationBar(selectedIndex:i,onDestinationSelected:(v)=>setState(()=>i=v),destinations:const[
      NavigationDestination(icon: Icon(Icons.speed), label:'Тюнер'),
      NavigationDestination(icon: Icon(Icons.collections), label:'Наборы'),
      NavigationDestination(icon: Icon(Icons.tune), label:'Калибровка'),
      NavigationDestination(icon: Icon(Icons.settings), label:'Настройки'),
    ]),
  );
}
