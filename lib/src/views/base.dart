import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_care/src/views/home.dart';

class Base extends ConsumerStatefulWidget {
  const Base({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _BaseState();
}

class _BaseState extends ConsumerState<Base> {
  List<Widget> widgetList =[

    HomePage(),
    HomePage(),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (val){
          setState(() {
            currentIndex=val;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: '')
        ],
        currentIndex:currentIndex,

      ),
    );
  }
}
