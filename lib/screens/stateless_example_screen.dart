import 'package:example_future_builder/screens/widgets/user_profile.dart';
import 'package:example_future_builder/screens/widgets/users_list.dart';
import 'package:flutter/material.dart';

class StatelessExampleScreen extends StatelessWidget {
  const StatelessExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 StatelessWidget'),
        backgroundColor: Colors.orange[100],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: const Column(
              spacing: 8,
              children: [
                Text(
                  'FutureBuilder en StatelessWidget',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '📍 El Future se define directamente en el FutureBuilder',
                  textAlign: TextAlign.center,
                ),
                Text(
                  '⚠️ Cada rebuild del widget padre recreará el Future',
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 20,
                children: [
                  const Text(
                    'Perfil de Usuario',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const UserProfile(userId: 1),
                  const Divider(),
                  const Text(
                    'Lista de Usuarios',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Expanded(child: UsersList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RebuildDemoWidget extends StatefulWidget {
  const RebuildDemoWidget({super.key});

  @override
  State<RebuildDemoWidget> createState() => _RebuildDemoWidgetState();
}

class _RebuildDemoWidgetState extends State<RebuildDemoWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Rebuilds: $_counter'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => setState(() => _counter++),
              child: const Text('Forzar Rebuild'),
            ),
            const SizedBox(height: 8),
            const Text(
              '⚠️ Cada rebuild recreará el Future en los widgets de arriba',
              style: TextStyle(fontSize: 12, color: Colors.orange),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
