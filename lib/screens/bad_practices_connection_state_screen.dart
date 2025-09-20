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
  int _rebuildCounter = 0;
  int _contentRepaintCounter = 0;

  @override
  void initState() {
    super.initState();
  }

  void _triggerRebuild() {
    setState(() {
      _rebuildCounter++;
    });
  }

  IconData _getStateIcon(ConnectionState state) {
    switch (state) {
      case ConnectionState.none:
        return Icons.help_outline;
      case ConnectionState.waiting:
        return Icons.hourglass_empty;
      case ConnectionState.active:
        return Icons.sync;
      case ConnectionState.done:
        return Icons.check_circle;
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
              future: ApiService.getUsers(),
              builder: (context, snapshot) {
                _contentRepaintCounter++;

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Icon(
                        _getStateIcon(snapshot.connectionState),
                        size: 64,
                        color: _getStateColor(snapshot.connectionState),
                      ),
                      Text(
                        'Cambios de ConnectionState: $_contentRepaintCounter',
                        style: TextStyle(
                          color: _getStateColor(snapshot.connectionState),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Estado actual: ${snapshot.connectionState.toString().split('.').last.toUpperCase()}',
                        style: TextStyle(
                          color: _getStateColor(snapshot.connectionState),
                          fontSize: 16,
                        ),
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
