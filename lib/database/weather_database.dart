import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../home/weather_model.dart';

class WeatherDatabase {
  static Database? _db;

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'weather.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
  CREATE TABLE weather (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cityname TEXT,
    temperature REAL,
    description TEXT,
    humidity INTEGER,
    winSpeed REAL,
    uvIndex INTEGER,
    icon TEXT
    )''');
      },
    );
  }

  Future<Database> get db async {
    return _db ??= await initDB();
  }

  Future<int> add(WeatherModel weatherModel) async {
    final database = await db;
    return await database.insert('weather', weatherModel.toMap());
  }

  Future<int> deleteWeather(int id) async {
    final database = await db;
    return await database.delete('weather', where: 'id = ?', whereArgs: [id]);
  }

  // метод для чтение
  Future<List<WeatherModel>> queryWeather(String cityname) async {
    final database = await db;
    final result = await database.query('weather', where: 'cityname = ?', whereArgs: [cityname]);
    return result.map((map) => WeatherModel.fromMap(map)).toList();
  }

}
