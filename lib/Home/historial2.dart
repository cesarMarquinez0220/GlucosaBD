// ignore_for_file: use_super_parameters

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Historial2 extends StatefulWidget {
  final String userId;
  final String imagePath;
  final String date;
  const Historial2(
      {Key? key,
      required this.imagePath,
      required this.date,
      required this.userId})
      : super(key: key);

  @override
  State<Historial2> createState() => _HistorialState();
}

class _HistorialState extends State<Historial2> {
  late String calcvrg;
  late String diferenciaMaxMinValue; // Declare the variable as non-nullable
  late String lecturaMaxima;
  late String lecturaMinima;
  bool isTimerActive = false;
  bool isTimerExpired = false;
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  //late Double num;

  Future<void> takePicture(String userId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // Navigate to the same screen with the new image
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Historial2(
            imagePath: image.path,
            date: DateFormat.yMMMd().format(DateTime.now()),
            userId: userId,
          ),
        ),
      );
    } else {
      print('No se seleccionó ninguna imagen.');
    }
  }

  Future<void> saveImageToFirebase() async {
    File imageFile = File(widget.imagePath);
    String fileName =
        '${widget.userId}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child("Imagenes de Usuarios/")
        .child(fileName);

    try {
      // Subir la imagen al almacenamiento de Firebase
      await storageRef.putFile(imageFile);
      // Imagen guardada exitosamente
      print('Imagen guardada en Firebase Storage');
      _showAlertDialog(
          'Éxito', 'Imagen guardada exitosamente en Firebase Storage');
    } catch (error) {
      // Ocurrió un error al guardar la imagen
      print('Error al guardar la imagen en Firebase Storage: $error');
      _showAlertDialog('Error',
          'Hubo un error al guardar la imagen en Firebase Storage: $error');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var containerImgW = MediaQuery.of(context).size.width;
    var containerImgH = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 46, 46, 46),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () => takePicture(widget.userId),
                  child: Text(
                    "Cancelar",
                    style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontSize: 23,
                    ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: containerImgH * .32,
                  width: containerImgW,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 107, 107, 107),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.fill,
                        height: containerImgH * .28,
                        width: containerImgW,
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          widget.date,
                          style: GoogleFonts.nunitoSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Color de la sombra
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(
                                  4, 5), // La posición de la sombra
                            ),
                          ],
                          color: const Color.fromARGB(255, 107, 107, 107),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tiempo de analisis:\n",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 22, color: Colors.white),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "Seguridad de resultado:\n",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 22, color: Colors.white),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "Diagnostico Obtenido:\n",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 22, color: Colors.white),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .18),
                    InkWell(
                      onTap: saveImageToFirebase,
                      child: Container(
                        height: MediaQuery.of(context).size.height * .06,
                        width: MediaQuery.of(context).size.width * .8,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 23, 121, 233)
                                    .withOpacity(0.5), // Color de la sombra
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(2, 3),
                              ),
                            ],
                            color: const Color(0xff003366),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          "Guardar",
                          style: GoogleFonts.nunitoSans(
                              height: 2,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
