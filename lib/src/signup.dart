import 'package:flutter/material.dart';
import 'package:glucosapp/src/Widget/bezierContainer.dart';
import 'package:glucosapp/src/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Atras',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title,
      {bool isPassword = false, required TextEditingController controller}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true)),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () async {
        // Obtén los valores de los campos de entrada
        String username = _usernameController.text.trim();
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();

        // Verifica que todos los campos estén completos
        if (username.isEmpty || email.isEmpty || password.isEmpty) {
          DialogExample.showAlertDialog(
            context,
            'Faltan credenciales',
            'Por favor, completa todos los campos.',
          );
          return;
        }

        try {
          // Comprueba si el usuario ya existe
          QuerySnapshot query = await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: username)
              .get();

          if (query.docs.isNotEmpty) {
            // El usuario ya existe, muestra el diálogo de alerta
            // ignore: use_build_context_synchronously
            DialogExample.showUserAlreadyExistsDialog(context);
          } else {
            // Registra al usuario en Firebase Authentication
            UserCredential userCredential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );

            // Obtiene el ID único del usuario registrado
            String userId = userCredential.user!.uid;

            // Guarda los datos adicionales en Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .set({
              'username': username,
              'email': email,
              // Agrega más campos si es necesario
            });

            // Navega a la página de inicio o realiza otra acción después del registro exitoso
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        } catch (e) {
          // Maneja los errores de autenticación o Firestore aquí
          // ignore: avoid_print
           DialogExample.showAlertDialog(
            context,
            'Error de Registro',
            'Ocurrió un error durante el registro. Por favor, intenta nuevamente.',
          );
          print("Error during registration: $e");
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xffF3A75B),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
        ),
        child: const Text(
          'Registrate',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ya tienes una cuenta ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Skin',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 35,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: const [
            TextSpan(
              text: 'Disease',
              style: TextStyle(color: Color(0xFFF3A75B), fontSize: 35),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Nombre de usuario", controller: _usernameController),
        _entryField("Email", controller: _emailController),
        _entryField("Contraseña",
            isPassword: true, controller: _passwordController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    const SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}

class DialogExample {
  static void showAlertDialog(
      BuildContext context, String title, String message) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color.fromARGB(255, 253, 40, 40)),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showUserAlreadyExistsDialog(BuildContext context) {
    showAlertDialog(
      context,
      'Alerta',
      'El usuario ya está registrado.',
    );
  }
}
