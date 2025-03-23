import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dataType/data.dart';

class Details extends StatefulWidget {
  final Data data;
  final String id;

  Details({required this.data, required this.id});


  @override
  State<StatefulWidget> createState() {
    return _MyDetails();
  }
}

class _MyDetails extends State<Details> {
  late TextEditingController _controladorCiudad;
  late TextEditingController _controladorTemperatura;
  late TextEditingController _controladorCondicion;
  late TextEditingController _controladorIcon;

  late Data data;
  late String id;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    id = widget.id;

    _controladorCiudad = TextEditingController(text: data.ciudad);
    _controladorTemperatura = TextEditingController(text: data.temperatura);
    _controladorCondicion = TextEditingController(text: data.condicion);
    _controladorIcon = TextEditingController(text: data.icon);
  }

  Future<void> actualizarDatos(String id, String ciudad, String temperatura,
      String condicion, String icon) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('clima/$id');
      await ref.update({
        'ciudad': ciudad,
        'temperatura': temperatura,
        'condicion': condicion,
        'icon': icon,
      });
      print('Datos actualizados correctamente');
    } catch (e) {
      print('Error al actualizar datos: $e');
    }
  }


  Future<void> eliminarDatos(String id) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('clima/$id');
      await ref.remove();
      print('Datos eliminados correctamente');
    } catch (e) {
      print('Error al eliminar datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.blueGrey,
        title: Text(
          data.ciudad,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.38),
                    height: 500,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(data.imagen),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        TextField(
                          controller: _controladorCiudad,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Ciudad',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _controladorTemperatura,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Temperatura',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _controladorCondicion,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Condición',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _controladorIcon,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Icono',
                          ),
                        ),
                        SizedBox(height: 20), // Espacio antes de los botones
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // TODO EDITABLE
                                if (_controladorCiudad.text.isNotEmpty &&
                                    _controladorTemperatura.text.isNotEmpty &&
                                    _controladorCondicion.text.isNotEmpty &&
                                    _controladorIcon.text.isNotEmpty) {
                                  actualizarDatos(id,
                                    _controladorCiudad.text,
                                    _controladorTemperatura.text,
                                    _controladorCondicion.text,
                                    _controladorIcon.text,
                                  ).then((_) {
                                    setState(() {
                                      data.ciudad = _controladorCiudad.text;
                                      data.temperatura = _controladorTemperatura.text;
                                      data.condicion = _controladorCondicion.text;
                                      data.icon = _controladorIcon.text;
                                    });
                                  }).catchError((error) {
                                    print('Error al editar: $error');
                                  });
                                }
                              },
                              child: Text("Editar"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                //Todo eliminar agregar a futuro
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirmar eliminación"),
                                      content: Text("¿Seguro que quieres eliminar esta ciudad?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancelar"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            eliminarDatos(id).then((_) {
                                              Navigator.pop(context); // Cerrar la página de detalles
                                            }).catchError((error) {
                                              print('Error al eliminar: $error');
                                            });
                                          },
                                          child: Text("Eliminar"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text("Eliminar"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
