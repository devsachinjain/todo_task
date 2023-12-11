
import 'database_provider.dart';
import 'models/employee_model.dart';

class DatabaseController{
  final dbClient = DatabaseProvider.dbProvider;

  Future<int> createEmployee(EmployeeModel? todo) async {
    final db = await dbClient.db;
    int result = await db.insert("todoTable", todo!.toJSON());
    return result;
  }

  Future<List<EmployeeModel>> getAllEmployee({List<String>? columns}) async {
    final db = await dbClient.db;
    var result = await db.query("todoTable",columns: columns);
    List<EmployeeModel> todos = result.isNotEmpty ? result.map((item) => EmployeeModel.fromJSON(item)).toList() : [];
    return todos;
  }

  Future<int> updateEmployee(EmployeeModel? todo) async {
    final db = await dbClient.db;
    var result = await db.update("todoTable", todo!.toJSON(),where: "id = ?", whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteEmployee(int id) async {
    final db = await dbClient.db;
    var result = await db.delete("todoTable", where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
