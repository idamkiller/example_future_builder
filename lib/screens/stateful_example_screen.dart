import 'package:example_future_builder/screens/widgets/user_detail.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class StatefulExampleScreen extends StatefulWidget {
  const StatefulExampleScreen({super.key});

  @override
  State<StatefulExampleScreen> createState() => _StatefulExampleScreenState();
}

class _StatefulExampleScreenState extends State<StatefulExampleScreen> {
  late Future<List<User>> _usersFuture;
  int _selectedUserId = 1;
  int _rebuildCounter = 0;

  @override
  void initState() {
    super.initState();
    _usersFuture = ApiService.getUsers();
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = ApiService.getUsers();
    });
  }

  void _changeSelectedUser(int userId) {
    setState(() {
      _selectedUserId = userId;
    });
  }

  void _triggerRebuild() {
    setState(() {
      _rebuildCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ StatefulWidget'),
        backgroundColor: Colors.purple[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshUsers,
            tooltip: 'Refrescar usuarios',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.purple[50],
            child: Column(
              children: [
                const Text(
                  'FutureBuilder en StatefulWidget',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Rebuilds: $_rebuildCounter'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _triggerRebuild,
                  child: const Text('Forzar Rebuild'),
                ),
                const SizedBox(height: 8),
                const Text(
                  '✅ El Future se mantiene estable entre rebuilds',
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Detalle de Usuario Seleccionado',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [1, 2, 3].map((id) {
                              return ElevatedButton(
                                onPressed: () => _changeSelectedUser(id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedUserId == id
                                      ? Colors.purple
                                      : Colors.grey[300],
                                ),
                                child: Text(
                                  'Usuario $id',
                                  style: TextStyle(
                                    color: _selectedUserId == id
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  UserDetail(userId: _selectedUserId),
                  const SizedBox(height: 16),
                  const Text(
                    'Lista de Todos los Usuarios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: FutureBuilder<List<User>>(
                      future: _usersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                const Icon(
                                  Icons.error,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _refreshUsers,
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
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final isSelected = user.id == _selectedUserId;
                            return Card(
                              color: isSelected ? Colors.purple[50] : null,
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isSelected
                                      ? Colors.purple
                                      : null,
                                  child: Text(user.name[0]),
                                ),
                                title: Text(user.name),
                                subtitle: Text(user.email),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.purple,
                                      )
                                    : Text(user.phone),
                                onTap: () => _changeSelectedUser(user.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
