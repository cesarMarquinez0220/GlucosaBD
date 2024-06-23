// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glucosapp/Home/Analisis.dart';
import 'package:glucosapp/Home/tabla.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Dashboard extends StatefulWidget {
  final String userId;
  const Dashboard({Key? key, required this.userId}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String calcvrg;
  late String diferenciaMaxMinValue; // Declare the variable as non-nullable
  late String lecturaMaxima;
  late String lecturaMinima;
  final picker = ImagePicker();
  final pageController = PageController();
  bool isTimerActive = false;
  bool isTimerExpired = false;
  File? _image;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    // Deshabilitar rotación de pantalla al cargar la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Habilitar todas las orientaciones al salir de la pantalla

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  Future<void> requestPermissions() async {
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;

    if (cameraStatus.isDenied) {
      cameraStatus = await Permission.camera.request();
    }

    if (storageStatus.isDenied) {
      storageStatus = await Permission.storage.request();
    }

    if (cameraStatus.isDenied && storageStatus.isDenied) {
      // Cerrar la aplicación si ambos permisos son denegados
      exit(0);
    }
  }

  Future<bool> checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
      if (status.isDenied) {
        // Manejar el caso de denegación del permiso
        return false;
      }
    }
    return true;
  }

  Future<bool> checkStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      status = await Permission.storage.request();
      if (status.isDenied) {
        // Manejar el caso de denegación del permiso
        return false;
      }
    }
    return true;
  }

  Future getImage(String userId) async {
    bool hasStoragePermission = await checkStoragePermission();
    if (hasStoragePermission) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Analisis(
              imagePath: image.path,
              date: DateTime.now().toString(),
              userId: userId,
            ),
          ),
        );
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    } else {
      print('Permiso de almacenamiento denegado.');
    }
  }

  Future<void> takepicture(String userId) async {
    bool hasCameraPermission = await checkCameraPermission();
    if (hasCameraPermission) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        Navigator.push(
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
    } else {
      print('Permiso de cámara denegado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var imgW = MediaQuery.of(context).size.width * 0.092;
    var imgH = MediaQuery.of(context).size.height * 0.092;
    var containerImgW = MediaQuery.of(context).size.width * 0.101;
    var containerImgH = MediaQuery.of(context).size.height * 0.060;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Container(
                height: containerImgH,
                width: containerImgW,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image(
                  image: const AssetImage('assets/images/logo.png'),
                  height: imgH * 0.9,
                  width: imgW * 0.9,
                ),
              ),
              const SizedBox(width: 8), // Espaciado entre la imagen y el texto
              Expanded(
                child: Row(
                  children: [
                    Text(
                      "Skin",
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      " Disease",
                      style: GoogleFonts.nunitoSans(
                          color: const Color(0xFFF3A75B),
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: containerImgH,
                width: containerImgW,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 240, 240),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Image(
                  image: AssetImage('assets/images/icono.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/fondo.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: (Colors.transparent),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .34,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Color(0xffEAEAEA),
                            ),
                            child: PageView(
                              controller: pageController,
                              children: [
                                Image.asset('assets/images/carrusel3.png'),
                                Image.asset('assets/images/carrusel1.png'),
                                Image.asset('assets/images/carrusel2.png'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SmoothPageIndicator(
                            // Color(0xFFF3A75B)
                            controller: pageController,
                            count: 3,
                            effect: const ExpandingDotsEffect(
                              dotHeight: 16,
                              dotWidth: 16,
                              activeDotColor: Color(0xFFF3A75B),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // caudro de camara para tomar foto
                                  GestureDetector(
                                    onTap: () => takepicture(widget.userId),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8,
                                          right: 8,
                                          top: 8,
                                          bottom: 16),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 58, 58, 58)
                                                  .withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: const Offset(4, 5),
                                            ),
                                          ],
                                          color: const Color.fromARGB(
                                              255, 107, 107, 107),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(35.0),
                                          child: Image.asset(
                                            "assets/images/camera.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // cuadro de cargar foto desde galeria
                                  GestureDetector(
                                    onTap: () => getImage(widget.userId),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8,
                                          right: 8,
                                          top: 8,
                                          bottom: 16),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .2,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .45,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 58, 58, 58)
                                                  .withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: const Offset(4, 5),
                                            ),
                                          ],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                          color: const Color.fromARGB(
                                              255, 107, 107, 107),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(45.0),
                                          child: Image.asset(
                                            "assets/images/cargar.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to second route when tapped.
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HistorialRegistro(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .17,
                                  width:
                                      MediaQuery.of(context).size.width * .94,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 58, 58, 58)
                                            .withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(4, 5),
                                      ),
                                    ],
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    color: const Color.fromARGB(
                                        255, 107, 107, 107),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset(
                                      "assets/images/historial.png",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
