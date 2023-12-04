import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glucosapp/Dashboard/Graph/graph_glucosa.dart';
import 'package:glucosapp/storageInfoUser/info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  late Timer _timer = Timer(const Duration(seconds: 0), () {});
  bool isTimerActive = false;
  bool isTimerExpired = false;

  List<Map<String, dynamic>> changes = [];

  // Listen for changes in the 'diferenciaMaxMin' node in the database
  final databaseReference =
      FirebaseDatabase.instance.ref('/glucoseData/calcavrg');
  final databaseReference1 =
      FirebaseDatabase.instance.ref('/glucoseData/diferenciaMaxMin');
  final databaseReference2 =
      FirebaseDatabase.instance.ref('/glucoseData/lecturaMaxima');
  final databaseReference3 =
      FirebaseDatabase.instance.ref('/glucoseData/lecturaMinima');

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
  }

  @override
  void dispose() {
    // Habilitar todas las orientaciones al salir de la pantalla
    _timer?.cancel(); // Cancelar el temporizador al salir del widget
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  // Función para iniciar el temporizador
  void startTimer() {
    print('startTimer called! isTimerActive: $isTimerActive');
    // ignore: unnecessary_null_comparison
    if (_timer != null && _timer.isActive) {
      print('Timer is already active. Cancelling.');
      _timer.cancel();
    }

    // Crea un nuevo temporizador con una duración de 20 segundos
    _timer = Timer(Duration(seconds: 20), () {
      print('Timer expired!');
      isTimerExpired = true;
      // El temporizador ha alcanzado su límite (20 segundos), ahora puedes enviar los datos a Firestore
      updateAndSaveToFirestore(changes);
      setState(() {
        isTimerActive = false;
      });
    });
  }

// Método para manejar el toque del botón
  void handleButtonTap() async {
    try {
      if (!isTimerActive) {
        _timer.cancel();
        isTimerExpired = false;
        // Inicializa la lista de cambios al iniciar el temporizador

        startTimer();
        print('isTimerActive set to true');

        // Deshabilita el botón temporalmente
        setState(() {
          isTimerActive = true;
        });
        changes = [];
        databaseReference.onValue.listen((event) {
          if (isTimerExpired) {
            return; // Stop listening once the timer expires
          }
          // Check if the value is not null
          if (event.snapshot.value != null) {
            setState(() {
              // Cast the value to a String and assign it to the variable
              calcvrg = event.snapshot.value.toString();
            });
            handleDataChange('calcvrg', calcvrg);
          }
        });

        databaseReference1.onValue.listen((event) {
          if (isTimerExpired) {
            return; // Stop listening once the timer expires
          }
          // Check if the value is not null
          if (event.snapshot.value != null) {
            setState(() {
              // Cast the value to a String and assign it to the variable
              diferenciaMaxMinValue = event.snapshot.value.toString();
            });
            handleDataChange('diferenciaMaxMinValue', diferenciaMaxMinValue);
          }
        });

        databaseReference2.onValue.listen((event) {
          if (isTimerExpired) {
            return; // Stop listening once the timer expires
          }
          // Check if the value is not null
          if (event.snapshot.value != null) {
            setState(() {
              // Cast the value to a String and assign it to the variable
              lecturaMaxima = event.snapshot.value.toString();
            });
            handleDataChange('lecturaMaxima', lecturaMaxima);
          }
        });

        databaseReference3.onValue.listen((event) {
          if (isTimerExpired) {
            return; // Stop listening once the timer expires
          }
          // Check if the value is not null
          if (event.snapshot.value != null) {
            setState(() {
              // Cast the value to a String and assign it to the variable
              lecturaMinima = event.snapshot.value.toString();
            });
            handleDataChange('lecturaMinima', lecturaMinima);
          }
        });
      } else {
        // Puedes manejar esto de acuerdo a tus necesidades, por ejemplo, mostrar un mensaje al usuario
        print('El temporizador ya está activo. Por favor, espera.');
      }
    } catch (e) {
      print("Error al guardar los datos: $e");
    }
  }

  // Función para actualizar y guardar en Firestore
  void updateAndSaveToFirestore(List<Map<String, dynamic>> changes) async {
    print('Changes length: ${changes.length}');
    print('updateAndSaveToFirestore called! with changes: $changes');
    // Verifica si hay cambios para enviar
    if (changes.isNotEmpty) {
      // Aquí deberías tener acceso al usuario actual
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        print('Saving data for user: ${user.uid}');

        // Obtener referencia a la colección "datos" del usuario en Firestore
        CollectionReference datosCollection =
            FirebaseFirestore.instance.collection('users/${user.uid}/datos');

        // Obtener referencia a la colección "grafica" del usuario en Firestore
        CollectionReference graficaCollection =
            FirebaseFirestore.instance.collection('users/${user.uid}/grafica');

        try {
          for (var change in changes) {
            // Obtener la fecha y hora actuales
            DateTime currentDateTime = DateTime.now();
            String currentTime =
                TimeOfDay.fromDateTime(currentDateTime).format(context);

            // Crear un documento en la colección "datos" con un identificador único
            await datosCollection.add({
              'calcvrg': change['calcvrg'],
              'diferenciaMaxMinValue': change['diferenciaMaxMinValue'],
              'lecturaMaxima': change['lecturaMaxima'],
              'lecturaMinima': change['lecturaMinima'],
              'horalocal': currentTime,
              'timestamp': FieldValue.serverTimestamp(),
            });

            // Crear un documento en la colección "grafica" con un identificador único
            await graficaCollection.add({
              'diferenciaMaxMinValue': change['diferenciaMaxMinValue'],
              'timestamp': FieldValue.serverTimestamp(),
            });
          }

          print('Data successfully saved to Firestore!');
        } catch (e) {
          print('Error saving data to Firestore: $e');
        }
      }
    }
  }

  // Método para manejar cambios en los datos y agregarlos a la lista
  void handleDataChange(String fieldName, String newValue) {
    // Actualiza el valor en la interfaz de usuario
    setState(() {
      switch (fieldName) {
        case 'calcvrg':
          calcvrg = newValue;
          break;
        case 'diferenciaMaxMinValue':
          diferenciaMaxMinValue = newValue;
          break;
        case 'lecturaMaxima':
          lecturaMaxima = newValue;
          break;
        case 'lecturaMinima':
          lecturaMinima = newValue;
          break;
      }
    });
    // Inicia el temporizador solo si no está activo
    if (!isTimerActive) {
      startTimer();
      setState(() {
        isTimerActive = true;
      });
    }

    // Almacena el cambio en la lista
    changes.add({
      fieldName: newValue,
    });
  }

  //widget encargado del boton para guardar los datos dependiendo del inicio de sesion
  Widget _startButton() {
    return InkWell(
      onTap: () async {
        handleButtonTap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromRGBO(251, 180, 72, 1),
              Color.fromRGBO(247, 137, 43, 1)
            ],
          ),
        ),
        child: const Text(
          'Start your track',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  // FUNCION PARA EL DE LECTURAS
  double calculateBarWidthFactor() {
    double lecturaMaximaValue, lecturaMinimaValue;

    try {
      if (lecturaMaxima.isNotEmpty && lecturaMinima.isNotEmpty) {
        lecturaMaximaValue = double.parse(lecturaMaxima);
        lecturaMinimaValue = double.parse(lecturaMinima);
      } else {
        print('Las cadenas no pueden estar vacías');
        // Maneja el error según sea necesario
        return 0.0; // Otra acción por defecto en caso de error
      }
    } catch (e) {
      print('Error al convertir a double: $e');
      // Maneja el error según sea necesario
      return 0.0; // Otra acción por defecto en caso de error
    }

    double maxRange = 200.0;

    double percentage = (lecturaMaximaValue - lecturaMinimaValue) / maxRange;

    // Asegúrate de que el porcentaje esté entre 0 y 1
    percentage = percentage.clamp(0.0, 1.0);

    return percentage;
  }

  // FUNCION PARA EL DE PROMEDIO
  double calculateWidthFactor() {
    double normalizedValue;

    try {
      if (calcvrg.isNotEmpty) {
        double minValue = 0.0;
        double maxValue = 350.0;

        // Convierte calcvrg a un valor entre 0.0 y 1.0
        normalizedValue =
            (double.parse(calcvrg) - minValue) / (maxValue - minValue);
      } else {
        print('La cadena calcvrg no puede estar vacía');
        // Maneja el error según sea necesario
        return 0.0; // Otra acción por defecto en caso de error
      }
    } catch (e) {
      print('Error al convertir a double: $e');
      // Maneja el error según sea necesario
      return 0.0; // Otra acción por defecto en caso de error
    }

    // Asegúrate de que el valor esté dentro del rango permitido
    normalizedValue = normalizedValue.clamp(0.0, 1.0);

    return normalizedValue;
  }

  @override
  Widget build(BuildContext context) {
    var imgW = MediaQuery.of(context).size.width * 0.092;
    var imgH = MediaQuery.of(context).size.height * 0.092;
    var containerImgW = MediaQuery.of(context).size.width * 0.101;
    var containerImgH = MediaQuery.of(context).size.height * 0.060;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: (Color.fromRGBO(242, 242, 242, 0.753)),
        ),
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
                      'GLUCOSAPP',
                      style: GoogleFonts.ptSans(
                        textStyle: TextStyle(
                          color: Colors.orange,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.953,
                    child: LineChartWidget(
                      userId: UserDataStorage.getUserName(),
                    )),
                const SizedBox(height: 20),
                _startButton(),
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
                            color: const Color.fromARGB(255, 0, 0, 0),
                            letterSpacing: .5,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.953,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Container(
                          height: containerImgH,
                          width: containerImgW,
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
                              'assets/images/glucosa1.png',
                              width: imgW,
                              height: imgH,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  diferenciaMaxMinValue,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.062,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  'mg/dl',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'GLUCOSA',
                              style: GoogleFonts.inconsolata(
                                textStyle: TextStyle(
                                  color: Colors.blue,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, right: 50),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.04,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Text(
                              TimeOfDay.now().format(
                                  context), // Utiliza TimeOfDay para obtener la hora actual
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.953,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Container(
                          height: containerImgH,
                          width: containerImgW,
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
                              'assets/images/lecturas.png',
                              width: imgW,
                              height: imgH,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Max ',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                  ),
                                ),
                                Text(
                                  lecturaMaxima,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Min ',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                  ),
                                ),
                                Text(
                                  lecturaMinima,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'LECTURAS',
                              style: GoogleFonts.inconsolata(
                                textStyle: TextStyle(
                                  color: Colors.blue,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, right: 25),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.04,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  '$lecturaMinima - $lecturaMaxima',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 10, // Altura de la barra indicadora
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 200, 200, 201),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor:
                                      calculateBarWidthFactor(), // función para calcular el factor de ancho
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Color.fromRGBO(247, 137, 43,
                                          1), // color del contenedor secundario según tus necesidades
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.953,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Container(
                          height: containerImgH,
                          width: containerImgW,
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
                              'assets/images/Average.png',
                              width: imgW,
                              height: imgH,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  calcvrg,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.062,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  'mg/dl',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'PROMEDIO',
                              style: GoogleFonts.inconsolata(
                                textStyle: TextStyle(
                                  color: Colors.blue,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, right: 25),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 10,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green,
                                Colors.yellow,
                                Colors.orange,
                                Colors.red,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: calculateWidthFactor() *
                                    MediaQuery.of(context).size.width *
                                    0.3,
                                child: Container(
                                  width: 2, // Ancho de la barra indicadora
                                  height: 10,
                                  color: Colors
                                      .black, // Color de la barra indicadora
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
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
