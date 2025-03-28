import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dataType/data.dart';

class Details extends StatefulWidget {
  final Data data;
  final String id;

  const Details({Key? key, required this.data, required this.id}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late TextEditingController _cityController;
  late TextEditingController _temperatureController;
  late TextEditingController _conditionController;
  late TextEditingController _iconController;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController(text: widget.data.ciudad);
    _temperatureController = TextEditingController(text: widget.data.temperatura);
    _conditionController = TextEditingController(text: widget.data.condicion);
    _iconController = TextEditingController(text: widget.data.icon);
  }

  Future<void> _updateData() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('clima/${widget.id}');
      await ref.update({
        'ciudad': _cityController.text,
        'temperatura': _temperatureController.text,
        'condicion': _conditionController.text,
        'icon': _iconController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos actualizados correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar datos: $e')),
      );
    }
  }

  Future<void> _deleteData() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('clima/${widget.id}');
      await ref.remove();
      Navigator.of(context).pop(); // Regresar a la pantalla anterior
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos eliminados correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar datos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.ciudad),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(widget.data.imagen, fit: BoxFit.cover),
            SizedBox(height: 20),
            _buildTextField(_cityController, 'Ciudad'),
            SizedBox(height: 10),
            _buildTextField(_temperatureController, 'Temperatura'),
            SizedBox(height: 10),
            _buildTextField(_conditionController, 'Condición'),
            SizedBox(height: 10),
            _buildTextField(_iconController, 'Icono'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[200], foregroundColor: Colors.black),
                  child: Text('Editar'),
                ),
                ElevatedButton(
                  //Quiero que el texto sea negro
                  onPressed: () => _showDeleteConfirmDialog(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red[200], foregroundColor: Colors.black),
                  child: Text('Eliminar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextField _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Seguro que quieres eliminar esta ciudad?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteData();
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    _temperatureController.dispose();
    _conditionController.dispose();
    _iconController.dispose();
    super.dispose();
  }
}