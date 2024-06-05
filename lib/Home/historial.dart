// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Historial extends StatefulWidget {
  const Historial({Key? key}) : super(key: key);

  @override
  State<Historial> createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  late String calcvrg;
  late String diferenciaMaxMinValue; // Declare the variable as non-nullable
  late String lecturaMaxima;
  late String lecturaMinima;
  bool isTimerActive = false;
  bool isTimerExpired = false;
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  //late Double num;

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
          title: Container(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  "Registro No.",
                  style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontSize: 23,
                  ),
                ),
              ),
            ),
          ],
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
                // diseño sin cuadro
                Container(
                  height: MediaQuery.of(context).size.height * .32,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 107, 107, 107),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/images/vieja.jpeg",
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Aqui va la fecha",
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25))),
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
                    Container(
                      height: MediaQuery.of(context).size.height * .06,
                      width: MediaQuery.of(context).size.width * .8,
                      decoration:  BoxDecoration(
                        boxShadow: [
                            BoxShadow(
                              color:  const Color.fromARGB(255, 175, 33, 33)
                                  .withOpacity(0.5), // Color de la sombra
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(2, 3),
                            ),
                          ],
                          color: const Color.fromARGB(255, 211, 36, 36),
                          borderRadius: const BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        "Borrar Registro",
                        style: GoogleFonts.nunitoSans(
                            height: 2,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                        textAlign: TextAlign.center,
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
