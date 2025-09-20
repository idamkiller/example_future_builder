import 'package:example_future_builder/screens/bad_practices_connection_state_screen.dart';
import 'package:example_future_builder/screens/widgets/example_card.dart';
import 'package:flutter/material.dart';
import 'good_practices_screen.dart';
import 'bad_practices_screen.dart';
import 'stateless_example_screen.dart';
import 'stateful_example_screen.dart';
import 'connection_state_screen.dart';
import 'error_handling_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplos FutureBuilder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  ExampleCard(
                    title: '✅ Buenas Prácticas',
                    subtitle: 'Future declarado fuera del build',
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GoodPracticesScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ExampleCard(
                    title: '❌ Malas Prácticas',
                    subtitle:
                        'Future creado en el build (redibujados innecesarios)',
                    color: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BadPracticesScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ExampleCard(
                    title: '❌ Malas Prácticas connection state',
                    subtitle: 'Mala gestión de estados de conexión',
                    color: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const BadPracticesConnectionStateScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ExampleCard(
                    title: '📊 ConnectionState',
                    subtitle: 'Manejo correcto de estados de conexión',
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConnectionStateScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ExampleCard(
                    title: '🔧 StatelessWidget',
                    subtitle: 'FutureBuilder con widgets sin estado',
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatelessExampleScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ExampleCard(
                    title: '⚙️ StatefulWidget',
                    subtitle: 'FutureBuilder con widgets con estado',
                    color: Colors.purple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatefulExampleScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ExampleCard(
                    title: '⚠️ Manejo de Errores',
                    subtitle: 'Cómo manejar errores correctamente',
                    color: Colors.teal,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ErrorHandlingScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
