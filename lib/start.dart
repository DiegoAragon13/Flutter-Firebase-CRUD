import 'package:marmotaphilp/photo.dart';
import 'package:marmotaphilp/cards.dart';
import 'package:flutter/material.dart';


class Start extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _MyState();
  }
}
class _MyState extends State<Start>{
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    Photo(),
    Cards()
  ];
  @override
  Widget build(BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;
      void _onItemTapped(int index){
        setState(() {
          _selectedIndex= index;
        });
      }
      return Scaffold(
        body: Center(
          child: _pages[_selectedIndex]
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.yellow[300],
            selectedItemColor: Colors.black,
            unselectedItemColor: colorScheme.onSurface.withOpacity(.70),
            items: const<BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Inicio'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Registros'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Mapa'
              ),
            ]
        ),
      );
  }
}