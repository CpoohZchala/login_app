import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _initializeDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'user_data.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(User_Code TEXT, User_Display_Name TEXT, Email TEXT, User_Employee_Code TEXT, Company_Code TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> saveUserData(List<dynamic> userData) async {
    final db = await _initializeDatabase();

    for (var user in userData) {
      await db.insert(
        'users',
        {
          'User_Code': user['User_Code'],
          'User_Display_Name': user['User_Display_Name'],
          'Email': user['Email'],
          'User_Employee_Code': user['User_Employee_Code'],
          'Company_Code': user['Company_Code'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
