import 'dart:math';
import '../models/user.dart';

class ApiService {
  static final _random = Random();

  // Simula una llamada a API que puede fallar aleatoriamente
  static Future<List<User>> getUsers({bool shouldFail = false}) async {
    await Future.delayed(const Duration(seconds: 2));

    if (shouldFail || _random.nextBool()) {
      throw Exception('Error al cargar usuarios');
    }

    return [
      User(
        id: 1,
        name: 'Juan Pérez',
        email: 'juan@example.com',
        phone: '123-456-7890',
      ),
      User(
        id: 2,
        name: 'María García',
        email: 'maria@example.com',
        phone: '098-765-4321',
      ),
      User(
        id: 3,
        name: 'Carlos López',
        email: 'carlos@example.com',
        phone: '555-123-4567',
      ),
    ];
  }

  static Future<String> getFastData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Datos cargados rápidamente';
  }

  static Future<String> getSlowData() async {
    await Future.delayed(const Duration(seconds: 5));
    return 'Datos cargados lentamente';
  }

  static Future<User> getUserProfile(int userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: userId,
      name: 'Usuario $userId',
      email: 'user$userId@example.com',
      phone: '123-456-78${userId.toString().padLeft(2, '0')}',
    );
  }
}
