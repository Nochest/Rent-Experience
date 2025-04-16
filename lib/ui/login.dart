import 'dart:developer';
import 'dart:convert';
import 'dart:html' as html;

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesis_airbnb_web/data/appwrite_setting.dart';
import 'package:tesis_airbnb_web/repository/impl/user_repository_impl.dart';
import 'package:tesis_airbnb_web/theme/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      final r = await login(email, password);
      if (r != null) {
        final user = await UserRepositoryImpl().getUser(r.userId);

        if (user != null) {
          String jsonUser = jsonEncode(user.toJson());
          html.window.localStorage['usuario'] = jsonUser;

          switch (user.role) {
            case 'admin':
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Inicio de sesión exitoso'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go('/dashboard');
              break;
            case 'host':
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Inicio de sesión exitoso'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go('/host');
              break;
            case 'guest':
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Inicio de sesión exitoso'),
                  backgroundColor: Colors.green,
                ),
              );
              context.go('/guest');
              break;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Algo ocurrió, intenta de nuevo'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<Session?> login(String email, String password) async {
    try {
      final r = await AppwriteApiClient.account
          .createEmailPasswordSession(email: email, password: password);
      inspect(r);
      return r;
    } on AppwriteException catch (e) {
      log('login error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background-main.jpg',
            fit: BoxFit.fill,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 240),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Correo Electrónico',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingresa tu correo';
                                }
                                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                  return 'Ingresa un correo válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Contraseña',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingresa tu contraseña';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                onPressed: _login,
                                child: const Text(
                                  'Ingresar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
