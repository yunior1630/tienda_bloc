import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:tienda_bloc/features/authentication/presentation/bloc/auth_event.dart';

class PinLoginPage extends StatefulWidget {
  @override
  _PinLoginPageState createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ingresar con PIN")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Ingresa tu PIN de acceso",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "PIN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(
                  SignInWithPinEvent(pin: _pinController.text.trim()),
                );
              },
              child: const Text("Ingresar"),
            ),
          ],
        ),
      ),
    );
  }
}
