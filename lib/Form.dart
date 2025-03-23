import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'dataType/data.dart';
import 'ListData.dart';

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyForm();
  }
}

class _MyForm extends State<Formulario> {
  final _controladorCiudad = TextEditingController();
  final _controladorTemperatura = TextEditingController();
  final _controladorCondicion = TextEditingController();
  final _controladorIcon = TextEditingController();
  final _controladorImagen = TextEditingController();

  Data data = Data("", "", "", "", "");
  List<Data> _datos = [];

  Future<void> guardarDatos(String ciudad, String temperatura, String condicion,
      String icon, String imagen) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('clima');
      await ref.push().set({
        'ciudad': ciudad,
        'temperatura': temperatura,
        'condicion': condicion,
        'icon': icon,
        'imagen': imagen,
      });
      print('Datos guardados correctamente');
    } catch (e) {
      print('Error al guardar datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro del clima"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(20.0)),
            TextField(
              controller: _controladorCiudad,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Ciudad",
              ),
            ),
            const Padding(padding: EdgeInsets.all(20.0)),
            TextField(
              controller: _controladorTemperatura,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Temperatura",
              ),
            ),
            const Padding(padding: EdgeInsets.all(20.0)),
            TextField(
              controller: _controladorCondicion,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Condición",
              ),
            ),
            const Padding(padding: EdgeInsets.all(20.0)),
            TextField(
              controller: _controladorIcon,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Icono (Ejemplo: ☀️)",
              ),
            ),
            const Padding(padding: EdgeInsets.all(20.0)),
            ElevatedButton(
              onPressed: () {
                if (validarNombre(_controladorCiudad.text)) {
                  data.ciudad = _controladorCiudad.text;
                  data.temperatura = _controladorTemperatura.text;
                  data.condicion = _controladorCondicion.text;
                  data.icon = _controladorIcon.text;
                  data.imagen = Data.downloadURL;
                  setState(() {
                    guardarDatos(data.ciudad, data.temperatura, data.condicion,
                        data.icon, data.imagen)
                        .then((_) {
                      Navigator.pop(context);
                    }).catchError((error) {
                      alerta(context, "Error al guardar datos");
                    });
                  });
                } else {
                  alerta(context, 'Verifique la información ingresada');
                }
              },
              child: const Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}

bool validarNombre(String cadena) {
  RegExp exp = RegExp(r'^[a-zA-Z\s]+$');
  if (cadena.isEmpty) {
    return false;
  } else if (!exp.hasMatch(cadena)) {
    return false;
  } else {
    return true;
  }
}

void alerta(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('¡Alerta!'),
        content: Text(mensaje),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
