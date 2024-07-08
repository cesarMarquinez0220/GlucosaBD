import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistorialRegistro extends StatefulWidget {
  final String userId;
  const HistorialRegistro({Key? key, required this.userId}) : super(key: key);

  @override
  State<HistorialRegistro> createState() => _HistorialRegistroState();
}

class _HistorialRegistroState extends State<HistorialRegistro> {
  List<Map<String, String>> registros = []; // Lista para almacenar registros

  @override
  void initState() {
    super.initState();
    // Llamada inicial para obtener los registros del usuario
    _getRegistros();
  }

  // Función para obtener los registros del usuario desde Firestore
  Future<void> _getRegistros() async {
    try {
      String userId = widget.userId;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('analysis_results')
          .get();

      List<Map<String, String>> fetchedRegistros = [];
      querySnapshot.docs.forEach((doc) {
        fetchedRegistros.add({'fecha': doc['date']});
      });

      setState(() {
        registros = fetchedRegistros;
      });
    } catch (error) {
      print('Error al obtener registros: $error');
      // Manejar el error según sea necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 46, 46, 46),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 31,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  "Historial",
                  style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontSize: 23,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: (Color.fromRGBO(242, 242, 242, 0.753)),
          ),
          child: SingleChildScrollView(
            child: Table(
              border: const TableBorder(
                horizontalInside: BorderSide(
                  width: 2.0,
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                ),
                verticalInside: BorderSide(
                  width: 5.0,
                  color: Colors.white,
                  style: BorderStyle.solid,
                ),
                top: BorderSide(
                  width: 2.0,
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                ),
                bottom: BorderSide(
                  width: 2.0,
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                ),
                left: BorderSide(
                  width: 2.0,
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                ),
                right: BorderSide(
                  width: 2.0,
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                ),
              ),
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(4),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'No.',
                          style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Fecha de registro',
                          style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Data Rows
                ...registros.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String fecha = entry.value['fecha']!;
                  return _buildTableRow(idx + 1, fecha);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(int index, String fecha) {
    return TableRow(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : Colors.grey[500],
      ),
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              index.toString(),
              style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _mostrarDetallesYEliminar(fecha);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 12.0),
            child: SizedBox(
              height: 40, // Specify the desired height
              child: Text(
                fecha,
                style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _mostrarDetallesYEliminar(String fechaSeleccionada) {
    // Obtener los detalles desde Firestore basado en la fecha seleccionada
    String userId = widget.userId; // Reemplaza con el userId real
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('analysis_results')
        .where('date', isEqualTo: fechaSeleccionada)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Obtener los datos del primer documento (suponemos que solo hay uno por fecha)
        var doc = querySnapshot.docs.first;
        String imageUrl = doc['imageUrl'];
        String detectedObject = doc['detectedObject'];
        String preProcessTime = doc['preProcessTime'];
        String inferenceTime = doc['inferenceTime'];
        String nmsTime = doc['nmsTime'];
        double confidenceUsed = doc['confidenceUsed'];

        // Mostrar los detalles en otra pantalla
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallesScreen(
              imageUrl: imageUrl,
              detectedObject: detectedObject,
              preProcessTime: preProcessTime,
              inferenceTime: inferenceTime,
              nmsTime: nmsTime,
              confidenceUsed: confidenceUsed,
              onDelete: () {
                // Aquí implementar la lógica para eliminar el registro
                _eliminarRegistro(doc.reference);
                setState(() {
                  registros.removeWhere(
                      (element) => element['fecha'] == fechaSeleccionada);
                });
                Navigator.pop(context); // Regresar a la pantalla anterior
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se encontraron detalles para esa fecha')),
        );
      }
    }).catchError((error) {
      print('Error al obtener detalles: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener detalles')),
      );
    });
  }

  void _eliminarRegistro(DocumentReference docRef) {
    String? imageUrl;
    docRef.get().then((doc) {
      if (doc.exists) {
        imageUrl = doc['imageUrl'];

        // Eliminar el documento de Firestore
        return docRef.delete();
      } else {
        throw 'Documento no encontrado';
      }
    }).then((_) {
      // Si se eliminó correctamente el documento, eliminar la imagen en Firebase Storage
      FirebaseStorage.instance.refFromURL(imageUrl!).delete().then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro eliminado')),
        );
      }).catchError((error) {
        print('Error al eliminar imagen: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar imagen')),
        );
      });
    }).catchError((error) {
      print('Error al eliminar registro: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar registro')),
      );
    });
  }
}

class DetallesScreen extends StatelessWidget {
  final String imageUrl;
  final String detectedObject;
  final String preProcessTime;
  final String inferenceTime;
  final String nmsTime;
  final double confidenceUsed;
  final VoidCallback onDelete;

  const DetallesScreen({
    Key? key,
    required this.imageUrl,
    required this.detectedObject,
    required this.preProcessTime,
    required this.inferenceTime,
    required this.nmsTime,
    required this.confidenceUsed,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Registro'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      imageUrl,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Objeto Detectado:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    detectedObject,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Tiempo de Pre-procesamiento:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    preProcessTime,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Tiempo de Inferencia:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    inferenceTime,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Tiempo de NMS:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    nmsTime,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Confianza Usada:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    confidenceUsed.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: onDelete,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        child: Text(
                          'Borrar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
