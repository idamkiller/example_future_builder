import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'widgets/list_text.dart';

class WhatSolvesScreen extends StatefulWidget {
  const WhatSolvesScreen({super.key});

  @override
  State<WhatSolvesScreen> createState() => _WhatSolvesScreenState();
}

class _WhatSolvesScreenState extends State<WhatSolvesScreen> {
  late Future<String> _slowDataFuture;

  @override
  void initState() {
    super.initState();
    _slowDataFuture = ApiService.getSlowData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qué soluciona FutureBuilder❓'),
        backgroundColor: Colors.green[100],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.green[50],
            child: Column(
              children: [
                ListText(
                  items: const [
                    'Evita bloqueos en la UI.',
                    'Simplifica la gestión de estados asíncronos.',
                    'Maneja estados de carga, éxito y error.',
                    'Actualiza la UI automáticamente cuando los datos están listos.',
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<String>(
              // Anatomía de FutureBuilder
              // future: Aquí es donde se pasa la operación asíncrona que se necesita ejecutar.
              future: _slowDataFuture,
              // builder: Es una función que se reconstruye cada vez que el estado del future cambia
              // retornando un widget.
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                // return Text(
                //   snapshot.data!,
                // );
                // AsyncSnapshot: Contiene el estado actual del Future.
                // snapshot.connectionState -> Estado de la conexión (none, waiting, active, done).
                // snapshot.hasData -> Verifica si hay datos disponibles.
                // snapshot.data -> Los datos devueltos por el Future (si están disponibles).
                // snapshot.hasError -> Verifica si ocurrió un error.
                // snapshot.error -> El error ocurrido (si hay alguno).

                // connectionState.none -> No se ha iniciado ninguna operación.
                if (snapshot.connectionState == ConnectionState.none) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No se ha iniciado ninguna operación.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // connectionState.waiting -> La operación está en progreso.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando datos...'),
                        SizedBox(height: 16),
                        Text(
                          'Mostrar interfaz de carga agradable.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // snapshot.hasError -> La operación falló con un error.
                if (snapshot.hasError) {
                  return Column(
                    spacing: 16,
                    children: [
                      Text(
                        '❌ Ocurrió un error al cargar los datos.',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Mostrar interfaz de error amigable.',
                        textAlign: TextAlign.center,
                      ),
                      // snapshot.error contiene el error específico.
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }

                // connectionState.done -> La operación se completó con éxito.
                if (snapshot.connectionState == ConnectionState.done &&
                    // snapshot.hasData -> Verifica si hay datos disponibles.
                    snapshot.hasData) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        snapshot.data!,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      snapshot.data!,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              // initialData: Aquí es donde se pasan los datos iniciales mientras se carga el Future.
              initialData: 'Iniciando...',
            ),
          ),
        ],
      ),
    );
  }
}
