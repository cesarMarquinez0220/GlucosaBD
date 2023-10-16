import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xff1f005c),
              Color(0xff5b0060),
              Color(0xff870160),
              Color(0xffac255e),
              Color(0xffca485c),
              Color(0xffe16b5c),
              Color(0xfff39060),
              Color(0xffffb56b), // comentario pruebafgdhdfgh
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 77, 75, 75), // Color de fondo
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(
                            255, 24, 218, 18), // Color de la sombra
                        offset: Offset(
                            0, 2), // Desplazamiento horizontal y vertical
                        blurRadius: 6.0, // Radio de difuminación
                        spreadRadius: 0.0, // Radio de propagación
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              255, 77, 75, 75), // Color de fondo
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(
                                  255, 24, 218, 18), // Color de la sombra
                              offset: Offset(
                                  0, 2), // Desplazamiento horizontal y vertical
                              blurRadius: 6.0, // Radio de difuminación
                              spreadRadius: 0.0, // Radio de propagación
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              255, 77, 75, 75), // Color de fondo
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 5, 26, 4), // Color de la sombra
                              offset: Offset(
                                  0, 2), // Desplazamiento horizontal y vertical
                              blurRadius: 6.0, // Radio de difuminación
                              spreadRadius: 0.0, // Radio de propagación
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 54,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_sharp, size: 20.0),
              label: 'Salud',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 20.0),
              label: 'Descubrir',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 20.0),
              label: 'yo',
            ),
          ],
          // Agrega aquí la lógica para manejar la navegación entre pestañas
        ),
      ),
    );
  }
}
