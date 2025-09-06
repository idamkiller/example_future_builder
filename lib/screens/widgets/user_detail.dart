import 'package:example_future_builder/models/user.dart';
import 'package:example_future_builder/services/api_service.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  final int userId;

  const UserDetail({super.key, required this.userId});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  late Future<User> _userFuture;
  int _loadCounter = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void didUpdateWidget(UserDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _loadUser();
    }
  }

  void _loadUser() {
    setState(() {
      _loadCounter++;
      _userFuture = ApiService.getUserProfile(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detalle del Usuario ${widget.userId}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Cargas: $_loadCounter',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<User>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Cargando detalle...'),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(height: 8),
                      Text('Error: ${snapshot.error}'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadUser,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  );
                }

                if (!snapshot.hasData) {
                  return const Text('Usuario no encontrado');
                }

                final user = snapshot.data!;
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.purple,
                      child: Text(
                        user.name[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(user.email),
                          Text(user.phone),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
