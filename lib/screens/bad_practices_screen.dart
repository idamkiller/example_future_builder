import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class BadPracticesScreen extends StatefulWidget {
  const BadPracticesScreen({super.key});

  @override
  State<BadPracticesScreen> createState() => _BadPracticesScreenState();
}

class _BadPracticesScreenState extends State<BadPracticesScreen> {
  int _rebuildCounter = 0;
  int _apiCallCounter = 0;

  void _triggerRebuild() {
    setState(() {
      _rebuildCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('❌ Malas Prácticas'),
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
                Text(
                  'Llamadas API: $_apiCallCounter',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: _triggerRebuild,
                  child: const Text('Forzar Rebuild'),
                ),
                const Text(
                  '❌ El Future se ejecuta en CADA rebuild!',
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
              // ❌ MALA PRÁCTICA: Future creado en el build
              // Esto causa que se ejecute en cada rebuild
              // future: ApiService.getUsers(),
              future: (() {
                _apiCallCounter++; // Incrementamos contador para demostrar el problema
                // print('❌ API llamada #$_apiCallCounter - Future creado en build()');
                return ApiService.getUsers();
              })(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        Text(
                          'Cargando usuarios... (Llamada #$_apiCallCounter)',
                        ),
                        const Text(
                          '⚠️ Nota: Esta llamada se repite en cada rebuild',
                          style: TextStyle(color: Colors.orange, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          '⚠️ Para reintentar, necesitas forzar un rebuild',
                          style: TextStyle(color: Colors.orange, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay usuarios disponibles'),
                  );
                }

                final users = snapshot.data!;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.orange[100],
                      width: double.infinity,
                      child: Text(
                        '⚠️ Datos cargados con la llamada #$_apiCallCounter',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(child: Text(user.name[0])),
                              title: Text(user.name),
                              subtitle: Text(user.email),
                              trailing: Text(user.phone),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.red[50],
        child: const Text(
          '💡 Problema: Cada vez que se ejecuta build(), se crea un nuevo Future y se hace una nueva llamada a la API.',
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
