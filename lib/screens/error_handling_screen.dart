import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class ErrorHandlingScreen extends StatefulWidget {
  const ErrorHandlingScreen({super.key});

  @override
  State<ErrorHandlingScreen> createState() => _ErrorHandlingScreenState();
}

class _ErrorHandlingScreenState extends State<ErrorHandlingScreen> {
  late Future<List<User>> _usersFuture;
  bool _forceError = false;
  int _attemptCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _attemptCount++;
      _usersFuture = ApiService.getUsers(shouldFail: _forceError);
    });
  }

  void _toggleErrorMode() {
    setState(() {
      _forceError = !_forceError;
    });
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚠️ Manejo de Errores'),
        backgroundColor: Colors.teal[100],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.teal[50],
            child: Column(
              spacing: 8,
              children: [
                const Text(
                  'Control de Errores',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Forzar Error: ${_forceError ? "SÍ" : "NO"}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _forceError ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Switch(
                      value: _forceError,
                      onChanged: (value) => _toggleErrorMode(),
                      activeTrackColor: Colors.red,
                    ),
                  ],
                ),
                Text('Intentos realizados: $_attemptCount'),
                ElevatedButton(
                  onPressed: _loadUsers,
                  child: const Text('Recargar Datos'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        Text(
                          _forceError
                              ? 'Intentando cargar (fallará)...'
                              : 'Cargando usuarios...',
                        ),
                        Text(
                          'Intento #$_attemptCount',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        spacing: 12,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const Text(
                            'Error al cargar datos',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Card(
                            color: Colors.red[50],
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                spacing: 8,
                                children: [
                                  const Text(
                                    'Detalles del Error:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.error}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            spacing: 8,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _loadUsers,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Reintentar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              if (_forceError)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _forceError = false;
                                      });
                                      _loadUsers();
                                    },
                                    icon: const Icon(Icons.check),
                                    label: const Text(
                                      'Desactivar Error y Reintentar',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          Card(
                            color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '💡 Buenas Prácticas para Errores:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '• Mostrar un mensaje claro y amigable',
                                  ),
                                  const Text(
                                    '• Ofrecer una opción para reintentar',
                                  ),
                                  const Text(
                                    '• Considerar mostrar datos en caché si están disponibles',
                                  ),
                                  const Text(
                                    '• Registrar errores para debugging',
                                  ),
                                  const Text(
                                    '• Validar la conectividad de red',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox, size: 64, color: Colors.grey),
                        const Text(
                          'No hay datos disponibles',
                          style: TextStyle(fontSize: 18),
                        ),
                        ElevatedButton(
                          onPressed: _loadUsers,
                          child: const Text('Cargar Datos'),
                        ),
                      ],
                    ),
                  );
                }

                final users = snapshot.data!;
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: Colors.green[50],
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'Datos cargados exitosamente (Intento #$_attemptCount)',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Text(
                                  user.name[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
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
    );
  }
}
