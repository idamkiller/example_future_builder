import 'package:example_future_builder/models/user.dart';
import 'package:example_future_builder/services/api_service.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final int userId;

  const UserProfile({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<User>(
          // Future definido directamente aquí
          // ⚠️ Se recreará en cada rebuild del widget padre
          future: ApiService.getUserProfile(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Cargando perfil...'),
                ],
              );
            }

            if (snapshot.hasError) {
              return Column(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('Error: ${snapshot.error}'),
                ],
              );
            }

            if (!snapshot.hasData) {
              return const Text('No se encontró el usuario');
            }

            final user = snapshot.data!;
            return Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text(
                    user.name[0],
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(user.email),
                const SizedBox(height: 4),
                Text(user.phone),
              ],
            );
          },
        ),
      ),
    );
  }
}
