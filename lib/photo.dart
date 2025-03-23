import 'dart:io';
import 'Form.dart';
import 'package:marmotaphilp/dataType/data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Photo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPhoto();
  }
}

class _MyPhoto extends State<Photo> {
  File? imageFile;
  final picker = ImagePicker();
  String downloadURL = "";

  // Muestra la imagen seleccionada o un mensaje si no hay imagen
  Widget mostrarImagen() {
    return imageFile != null
        ? Image.file(
      imageFile!,
      width: 500,
      height: 500,
    )
        : const Text("Seleccione una imagen");
  }

  // Enviar imagen a Firebase Storage
  Future<void> enviarImagen() async {
    if (imageFile == null) {
      alerta(context, "¡No hay imagen seleccionada!");
      return;
    }
    try {
      // Generar nombre único de la foto
      String nomfoto = DateFormat.yMd().add_Hms().format(DateTime.now());
      String reffoto = "ciudad/" + nomfoto.replaceAll(RegExp(r'[\/ :]+'), "_");

      // Referencia a Firebase Storage
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref('$reffoto.png');

      // Subir archivo a Firebase Storage
      await ref.putFile(imageFile!).then((taskSnapshot) async {
        String url = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          Data.downloadURL = url;
        });

        print("✅ Imagen subida correctamente: $url");

        // Navegar al formulario después de subir la imagen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Formulario();
            },
          ),
        );
      });
    } catch (e) {
      print("⚠️ Error al subir la imagen: $e");
      alerta(context, "Error al subir la imagen. Verifica conexión y permisos.");
    }
  }
  Future<void> showSelectionDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Seleccione opción para foto"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: const Text("Galería"),
                      onTap: () {
                        seleccionarImagen(ImageSource.gallery);
                      },
                    ),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      child: const Text("Cámara"),
                      onTap: () {
                        seleccionarImagen(ImageSource.camera);
                      },
                    )
                  ],
                ),
              ));
        });
  }


  Future<void> seleccionarImagen(ImageSource source) async {
    try {
      final picture = await picker.pickImage(source: source);
      if (picture != null) {
        setState(() {
          imageFile = File(picture.path);
        });
      }
    } catch (e) {
      print("Error al seleccionar la imagen: $e");
    }
    Navigator.of(context).pop();
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(30)),
            Expanded(child: mostrarImagen()),
            const SizedBox(height: 30),
            IconButton(
              onPressed: enviarImagen,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSelectionDialog(context);
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
