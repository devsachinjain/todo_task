import 'package:demo/models/employee_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/repository.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final Repository repository = Repository();

  EmployeeBloc() : super(EmployeeState()) {
    on<SelectRoleEvent>((event, emit) {
      emit(SelectRoleState(role: event.role));
    });

    on<AddEmployeeEvent>((event, emit) {
      repository.insertTodo(event.employeeModel);
      emit(AddEmployeeState());
    });

    on<UpdateEmployeeEvent>((event, emit) {
      repository.updateTodo(event.employeeModel);
      emit(UpdateEmployeeState());
    });

    on<GetAllEmployeeEvent>((event, emit) async {
      List<EmployeeModel> list = await repository.getAllTodos();
      emit(GetAllEmployeeState(employeeModel: list));
    });

    on<CalenderEvent>((event, emit) async {
      emit(CalenderState(calenderModel: event.calenderModel));
    });

    on<ChangeDateEvent>((event, emit) async {
      emit(ChangeDateState(type: event.type, date: event.date));
    });

    on<DeleteEmployeeEvent>((event, emit) async {
      if (event.isHardDelete ?? false) {
        repository.deleteTodo(event.employeeModel?.id ?? 0);
      }
      emit(DeleteEmployeeState(
          index: event.index,
          type: event.type,
          employeeModel: event.employeeModel,
          isHardDelete: event.isHardDelete));
    });

    on<UndoEvent>((event, emit) async {
      emit(UndoState(
          index: event.index,
          type: event.type,
          employeeModel: event.employeeModel));
    });
  }
}
