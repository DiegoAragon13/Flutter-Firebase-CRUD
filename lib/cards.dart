import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'dataType/data.dart';
import 'details.dart';

class Cards extends StatelessWidget {
  const Cards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos del clima'),
      ),
      body: StreamBuilder(
        // Cambiar el stream para usar Realtime Database
        stream: FirebaseDatabase.instance.ref('clima').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(
              child: Text('No hay datos disponibles'),
            );
          }

          // Obtener los datos de Realtime Database
          var climaData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<Data> climaCard = [];
          List<String> ids = [];  // Lista para almacenar los ids

          climaData.forEach((key, value) {
            climaCard.add(Data(
              value['ciudad'] ?? '',
              value['temperatura'] ?? '',
              value['condicion'] ?? '',
              value['icon'] ?? '',
              value['imagen'] ?? '',
            ));
            ids.add(key);  // Guardamos el id correspondiente
          });

          return ListView.builder(
            itemCount: climaCard.length,
            itemBuilder: (context, index) {
              var ciudad = climaCard[index];
              var id = ids[index];  // Obtenemos el id correspondiente

              return Card(
                margin: EdgeInsets.all(7),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  leading: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(ciudad.imagen),
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text(ciudad.ciudad),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Temperatura: ${ciudad.temperatura}'),
                      Text('Condicion: ${ciudad.condicion}${ciudad.icon}'),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      // Al navegar a los detalles, también pasamos el id
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(data: ciudad, id: id),
                        ),
                      );
                    },
                    child: Icon(Icons.info_outline),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
