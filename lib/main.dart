import 'package:flutter/material.dart';

import 'countdowntimer.dart';
import 'countuptime.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}
  int _currentIndex =0;
  List<Widget> pages= [CountUpTimerPage(),CountDownTimerPage()];

class _MainPageState extends State<MainPage>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(selectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.move_down),
          label: 'CountUp',
          backgroundColor: Colors.grey,),

        BottomNavigationBarItem(

          icon: Icon(Icons.move_up),
          label: 'CountDown',
          backgroundColor: Colors.grey,),
      ],
      onTap: (index){
        setState(() {
          _currentIndex = index;
        });
      },
    ),
    );
  }
}

