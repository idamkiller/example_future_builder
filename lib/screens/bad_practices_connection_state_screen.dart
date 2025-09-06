import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class BadPracticesConnectionStateScreen extends StatefulWidget {
  const BadPracticesConnectionStateScreen({super.key});

  @override
  State<BadPracticesConnectionStateScreen> createState() =>
      _BadPracticesConnectionStateScreenState();
}

class _BadPracticesConnectionStateScreenState
    extends State<BadPracticesConnectionStateScreen> {
  // ✅ BUENA PRÁCTICA: Future declarado fuera del build
  // Esto evita que se ejecute nuevamente en cada rebuild
  late Future<List<User>> _usersFuture;
  int _rebuildCounter = 0;

  @override
  void initState() {
    super.initState();
    // ✅ Inicializamos el Future en initState
    _usersFuture = ApiService.getUsers();
  }

  void _triggerRebuild() {
    setState(() {
      _rebuildCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('❌ Malas Prácticas connectionState'),
        backgroundColor: Colors.red[100],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.red[50],
            child: Column(
              spacing: 8,
              children: [
                Text(
                  'Rebuilds: $_rebuildCounter',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _triggerRebuild,
                  child: const Text('Forzar Rebuild'),
                ),
                const Text(
                  '❌ El contenido del FutureBuilder no maneja correctamente los estados de conexión!',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                _rebuildCounter++;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      Text(
                        'Contenido repintado: $_rebuildCounter',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Estado de conexión: ${snapshot.connectionState}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
