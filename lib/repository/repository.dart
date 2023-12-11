import '../database_controller.dart';
import '../models/employee_model.dart';

class Repository {
  final DatabaseController dbController = DatabaseController();

  Future<List<EmployeeModel>> getAllTodos() => dbController.getAllEmployee();

  Future insertTodo(EmployeeModel? todo) => dbController.createEmployee(todo);

  Future updateTodo(EmployeeModel? todo) => dbController.updateEmployee(todo);

  Future deleteTodo(int id) => dbController.deleteEmployee(id);
}
