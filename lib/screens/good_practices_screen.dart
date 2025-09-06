import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class GoodPracticesScreen extends StatefulWidget {
  const GoodPracticesScreen({super.key});

  @override
  State<GoodPracticesScreen> createState() => _GoodPracticesScreenState();
}

class _GoodPracticesScreenState extends State<GoodPracticesScreen> {
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

  void _refreshData() {
    setState(() {
      _usersFuture = ApiService.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('✅ Buenas Prácticas'),
        backgroundColor: Colors.green[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refrescar datos',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.green[50],
            child: Column(
              children: [
                Text(
                  'Rebuilds: $_rebuildCounter',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _triggerRebuild,
                  child: const Text('Forzar Rebuild'),
                ),
                const SizedBox(height: 8),
                const Text(
                  '✅ El Future NO se ejecuta nuevamente en cada rebuild',
                  style: TextStyle(
                    color: Colors.green,
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando usuarios...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshData,
                          child: const Text('Reintentar'),
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
                return ListView.builder(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
