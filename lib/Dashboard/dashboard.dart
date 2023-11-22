import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String calcvrg;
  late String diferenciaMaxMinValue; // Declare the variable as non-nullable
  late String lecturaMaxima;
  late String lecturaMinima;

  @override
  void initState() {
    super.initState();

// Deshabilitar rotación de pantalla al cargar la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Initialize the 'diferenciaMaxMinValue' variable
    calcvrg = '';
    diferenciaMaxMinValue = '';
    lecturaMaxima = '';
    lecturaMinima = '';

    // Listen for changes in the 'diferenciaMaxMin' node in the database
    final databaseReference =
        FirebaseDatabase.instance.ref('/glucoseData/calcavrg');
    final databaseReference1 =
        FirebaseDatabase.instance.ref('/glucoseData/diferenciaMaxMin');
    final databaseReference2 =
        FirebaseDatabase.instance.ref('/glucoseData/lecturaMaxima');
    final databaseReference3 =
        FirebaseDatabase.instance.ref('/glucoseData/lecturaMinima');

    databaseReference.onValue.listen((event) {
      // Check if the value is not null
      if (event.snapshot.value != null) {
        setState(() {
          // Cast the value to a String and assign it to the variable
          calcvrg = event.snapshot.value.toString();
        });
      }
    });

    databaseReference1.onValue.listen((event) {
      // Check if the value is not null
      if (event.snapshot.value != null) {
        setState(() {
          // Cast the value to a String and assign it to the variable
          diferenciaMaxMinValue = event.snapshot.value.toString();
        });
      }
    });
    databaseReference2.onValue.listen((event) {
      // Check if the value is not null
      if (event.snapshot.value != null) {
        setState(() {
          // Cast the value to a String and assign it to the variable
          lecturaMaxima = event.snapshot.value.toString();
        });
      }
    });
    databaseReference3.onValue.listen((event) {
      // Check if the value is not null
      if (event.snapshot.value != null) {
        setState(() {
          // Cast the value to a String and assign it to the variable
          lecturaMinima = event.snapshot.value.toString();
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 206, 216, 216)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Center(
                    child: Text(
                      'HOME',
                      style: GoogleFonts.ptSans(
                        textStyle: TextStyle(
                          color: Colors.blue,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Track your health',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: const Color.fromARGB(255, 105, 103, 103),
                            letterSpacing: .5,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GLUCOSA',
                        style: GoogleFonts.inconsolata(
                          textStyle: TextStyle(
                            color: Colors.blue,
                            letterSpacing: .5,
                            fontSize: MediaQuery.of(context).size.width * 0.08,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: MediaQuery.of(context).size.width *
                            0.19, // Adjusted height for the image container
                        width: MediaQuery.of(context).size.width *
                            0.19, // Adjusted width for the image container
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 35, 173, 219),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/glucosa1.png', // Ruta de la imagen para GLUCOSA
                            width: MediaQuery.of(context).size.width *
                                0.15, // Adjusted width for the image
                            height: MediaQuery.of(context).size.width *
                                0.15, // Adjusted height for the image
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        calcvrg,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: const Color.fromARGB(255, 153, 27, 27),
                            fontSize: MediaQuery.of(context).size.width * 0.12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5), // Adjusted spacing
                      Text(
                        'mg/dl',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: const Color.fromRGBO(233, 71, 50, 1),
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'PROMEDIO',
                            style: GoogleFonts.inconsolata(
                              textStyle: TextStyle(
                                color: Colors.blue,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: MediaQuery.of(context).size.width *
                                0.19, // Adjusted height for the container
                            width: MediaQuery.of(context).size.width *
                                0.19, // Adjusted width for the container
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 35, 173, 219),
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 6.0,
                                  spreadRadius: 0.0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/Average.png', // Ruta de la imagen para PROMEDIO
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.width * 0.15,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            diferenciaMaxMinValue,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: const Color.fromARGB(255, 153, 27, 27),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.08,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'mg/dl',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: const Color.fromRGBO(233, 71, 50, 1),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'LECTURAS',
                            style: GoogleFonts.inconsolata(
                              textStyle: TextStyle(
                                color: Colors.blue,
                                letterSpacing: .5,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: MediaQuery.of(context).size.width * 0.19,
                            width: MediaQuery.of(context).size.width * 0.19,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 35, 173, 219),
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 6.0,
                                  spreadRadius: 0.0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/lecturas.png', // Ruta de la imagen para LECTURAS
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.width * 0.15,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Max ',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.055,
                                  ),
                                ),
                              ),
                              Text(
                                lecturaMaxima,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 153, 27, 27),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.055,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Min ',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.055,
                                  ),
                                ),
                              ),
                              Text(
                                lecturaMinima,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 153, 27, 27),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.055,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
