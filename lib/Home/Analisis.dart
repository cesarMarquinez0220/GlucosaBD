// ignore_for_file: use_super_parameters

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:glucosapp/Home/recepcion_img.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class Analisis extends StatefulWidget {
  final String userId;
  final String imagePath;
  final String date;
  const Analisis(
      {Key? key,
      required this.imagePath,
      required this.date,
      required this.userId})
      : super(key: key);

  @override
  State<Analisis> createState() => _AnalisisState();
}

class _AnalisisState extends State<Analisis> {
  bool isTimerActive = false;
  bool isTimerExpired = false;
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  //late Double num;
  File? _imageFile;

  Future<void> takePicture(String userId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // Navigate to the same screen with the new image
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Analisis(
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

  Future<void> _uploadImage() async {
    if (widget.imagePath == null) return;

    _showLoadingDialog(context);

    try {
      final uri = Uri.parse('https://1c5d4ee215ac.ngrok.app/process_image');
      final request = http.MultipartRequest('POST', uri);

      final mimeType = lookupMimeType(widget.imagePath);
      final contentType = mimeType != null ? mimeType : 'image/jpeg';

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          widget.imagePath,
          contentType: MediaType.parse(contentType),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');
      Navigator.pop(context);

      if (response.statusCode == 200) {
        // Convertir la respuesta a una imagen
        final decodedResponse = jsonDecode(responseBody);
        final processedImageBytes =
            _decodeImageToBytes(decodedResponse['processed_image']);
        final imageUrl = await _saveImageToFirebase(processedImageBytes);
        final image = _decodeImage(decodedResponse['processed_image']);
        final detectedObject = decodedResponse['detected_object'];
        final preProcessTime = decodedResponse['pre_process_time'];
        final inferenceTime = decodedResponse['inference_time'];
        final nmsTime = decodedResponse['nms_time'];
        final confidenceUsed = decodedResponse['confidence_used'];
        await saveAnalysisToFirestore(imageUrl, detectedObject, preProcessTime,
            inferenceTime, nmsTime, confidenceUsed);

        if (image != null) {
          // Navegar a otra pantalla con la imagen procesada
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageScreen(
                image: image,
                detectedObject: detectedObject,
                preProcessTime: preProcessTime,
                inferenceTime: inferenceTime,
                nmsTime: nmsTime,
                confidenceUsed: confidenceUsed,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al procesar la imagen')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Error al procesar la imagen:  ${response.statusCode}')));
      }
    } catch (e) {
      Navigator.pop(context); // Cerrar el diálogo de carga
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Image? _decodeImage(String base64String) {
    try {
      Uint8List bytes = base64.decode(base64String);
      return Image.memory(bytes);
    } catch (e) {
      print('Error al decodificar la imagen: $e');
      return null;
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                'Esto puede tomar un momento mientras se analiza la imagen',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> saveAnalysisToFirestore(
      String imageUrl,
      String detectedObject,
      String preProcessTime,
      String inferenceTime,
      String nmsTime,
      double confidenceUsed) async {
    try {
      // Obtener referencia al documento del usuario
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);

      // Guardar los datos del análisis dentro del documento del usuario
      await userDocRef.collection('analysis_results').add({
        'date': widget.date,
        'imageUrl': imageUrl,
        'detectedObject': detectedObject,
        'preProcessTime': preProcessTime,
        'inferenceTime': inferenceTime,
        'nmsTime': nmsTime,
        'confidenceUsed': confidenceUsed,
      });

      // Imagen guardada exitosamente en Firestore
      print('Análisis guardado en Firestore dentro del documento del usuario');
    } catch (error) {
      // Ocurrió un error al guardar el análisis
      print('Error al guardar el análisis en Firestore: $error');
    }
  }

  Uint8List _decodeImageToBytes(String base64String) {
    try {
      return base64.decode(base64String);
    } catch (e) {
      print('Error al decodificar la imagen: $e');
      return Uint8List(0);
    }
  }

  Future<String> _saveImageToFirebase(Uint8List imageBytes) async {
    String fileName =
        '${widget.userId}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

    await storageRef.putData(imageBytes);
    return await storageRef.getDownloadURL();
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
                    "Cancelar1",
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
                    InkWell(
                      onTap: _uploadImage,
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
