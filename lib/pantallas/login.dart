import 'package:flutter/material.dart';
import 'package:alimentosapp/services/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.pink.shade200, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Cotton cute food",
                  style: TextStyle(fontSize: 28, color: Colors.pinkAccent),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  child: TextField(
                    style: TextStyle(color: Colors.pink.shade200),
                    controller: _userController,
                    cursorColor: Colors.pink,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.pink.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.pink.shade300),
                      ),
                      labelText: 'Usuario',
                      labelStyle: TextStyle(color: Colors.pink.shade300),
                      prefixIcon: const Icon(Icons.person, color: Colors.pink),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  child: TextField(
                    style: TextStyle(color: Colors.pink.shade600),
                    controller: _passwordController,
                    cursorColor: Colors.pink,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.pink.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.pink.shade400),
                      ),
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Colors.pink.shade400),
                      prefixIcon: const Icon(Icons.lock, color: Colors.pink),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await login(_userController.text, _passwordController.text,
                        context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade200,
                    shadowColor: Colors.pink.shade400,
                    textStyle: const TextStyle(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(300, 50),
                  ),
                  child: const Text('Iniciar sesión'),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
