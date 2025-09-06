import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ConnectionStateScreen extends StatefulWidget {
  const ConnectionStateScreen({super.key});

  @override
  State<ConnectionStateScreen> createState() => _ConnectionStateScreenState();
}

class _ConnectionStateScreenState extends State<ConnectionStateScreen> {
  late Future<String> _dataFuture;
  String _currentState = 'none';
  bool _isSlowRequest = false;

  @override
  void initState() {
    super.initState();
    _dataFuture = ApiService.getFastData();
  }

  void _loadFastData() {
    setState(() {
      _isSlowRequest = false;
      _dataFuture = ApiService.getFastData();
    });
  }

  void _loadSlowData() {
    setState(() {
      _isSlowRequest = true;
      _dataFuture = ApiService.getSlowData();
    });
  }

  String _getStateDescription(ConnectionState state) {
    switch (state) {
      case ConnectionState.none:
        return 'NONE - El Future aún no ha comenzado';
      case ConnectionState.waiting:
        return 'WAITING - El Future está en progreso';
      case ConnectionState.active:
        return 'ACTIVE - El Future está activo (streams)';
      case ConnectionState.done:
        return 'DONE - El Future ha terminado';
    }
  }

  Color _getStateColor(ConnectionState state) {
    switch (state) {
      case ConnectionState.none:
        return Colors.grey;
      case ConnectionState.waiting:
        return Colors.orange;
      case ConnectionState.active:
        return Colors.blue;
      case ConnectionState.done:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 ConnectionState'),
        backgroundColor: Colors.blue[100],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              spacing: 12,
              children: [
                const Text(
                  'Controles de Carga',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _loadFastData,
                        child: const Text('Carga Rápida (0.5s)'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _loadSlowData,
                        child: const Text('Carga Lenta (5s)'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<String>(
              future: _dataFuture,
              builder: (context, snapshot) {
                _currentState = snapshot.connectionState
                    .toString()
                    .split('.')
                    .last;

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        color: _getStateColor(
                          snapshot.connectionState,
                        ).withValues(alpha: 0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            spacing: 8,
                            children: [
                              Row(
                                spacing: 8,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: _getStateColor(
                                      snapshot.connectionState,
                                    ),
                                  ),
                                  Text(
                                    'Estado Actual: ${_currentState.toUpperCase()}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _getStateColor(
                                        snapshot.connectionState,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                _getStateDescription(snapshot.connectionState),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Expanded(child: _buildContentForState(snapshot)),

                      if (snapshot.connectionState == ConnectionState.waiting)
                        Card(
                          color: Colors.orange[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              spacing: 8,
                              children: [
                                Text(
                                  _isSlowRequest
                                      ? '⏳ Carga lenta en progreso...'
                                      : '⚡ Carga rápida en progreso...',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                LinearProgressIndicator(
                                  backgroundColor: Colors.orange[100],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.orange,
                                  ),
                                ),
                                const Text(
                                  '💡 Durante WAITING es importante mostrar un indicador de carga',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
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

  Widget _buildContentForState(AsyncSnapshot<String> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return const Center(
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.help_outline, size: 64, color: Colors.grey),
              Text('Ningún Future asignado', style: TextStyle(fontSize: 18)),
              Text(
                'Presiona un botón para comenzar',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );

      case ConnectionState.waiting:
        return Center(
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Text(
                _isSlowRequest
                    ? 'Cargando datos lentos...'
                    : 'Cargando datos rápidos...',
                style: const TextStyle(fontSize: 18),
              ),
              const Text(
                'Este es el momento perfecto para mostrar un loader',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );

      case ConnectionState.active:
        return const Center(
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.stream, size: 64, color: Colors.blue),
              Text('Stream Activo', style: TextStyle(fontSize: 18)),
              Text(
                'Este estado se usa principalmente con Streams',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );

      case ConnectionState.done:
        if (snapshot.hasError) {
          return Center(
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const Text(
                  'Error al cargar datos',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                Text(
                  '${snapshot.error}',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (snapshot.hasData) {
          return Center(
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 64, color: Colors.green),
                const Text(
                  'Datos Cargados Exitosamente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      snapshot.data!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Text(
                  '✅ Estado DONE con datos disponibles',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning, size: 64, color: Colors.orange),
              Text('Completado sin datos', style: TextStyle(fontSize: 18)),
              Text(
                'El Future terminó pero no devolvió datos',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
    }
  }
}
