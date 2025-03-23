import 'package:marmotaphilp/dataType/data.dart';
import 'package:flutter/material.dart';

class ListData extends StatelessWidget{
  final List<Data> lista;

  const ListData(this.lista, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Datos del clima"),
      ),
      body: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, index){
          final item = lista[index];
          return ListTile(
            title: Text(item.ciudad),
            subtitle: Text(item.temperatura+" "+"\n"+item.icon+" "+"\n"+item.condicion),
            leading: Image(
              image: AssetImage("assets/"+item.imagen+".jpg"),
              fit: BoxFit.fill,
              width: 50,
            ),
          );
        },
      ),
    );
  }

}