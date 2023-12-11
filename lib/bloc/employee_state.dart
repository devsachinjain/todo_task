import 'package:demo/models/calenderModel.dart';
import 'package:flutter/cupertino.dart';

import '../models/employee_model.dart';

@immutable
class EmployeeState {}

// ignore: must_be_immutable
class SelectRoleState extends EmployeeState {
  String? role;

  SelectRoleState({this.role});
}

class AddEmployeeState extends EmployeeState {
  AddEmployeeState();
}

class UpdateEmployeeState extends EmployeeState {
  UpdateEmployeeState();
}

// ignore: must_be_immutable
class DeleteEmployeeState extends EmployeeState {
  int? index;
  String? type;
  EmployeeModel? employeeModel;
  bool? isHardDelete;

  DeleteEmployeeState(
      {this.index, this.type, this.employeeModel, this.isHardDelete});
}

// ignore: must_be_immutable
class UndoState extends EmployeeState {
  int? index;
  String? type;
  EmployeeModel? employeeModel;

  UndoState({this.index, this.type, this.employeeModel});
}

// ignore: must_be_immutable
class GetAllEmployeeState extends EmployeeState {
  List<EmployeeModel>? employeeModel;

  GetAllEmployeeState({this.employeeModel});
}

// ignore: must_be_immutable
class CalenderState extends EmployeeState {
  CalenderModel? calenderModel;

  CalenderState({this.calenderModel});
}

// ignore: must_be_immutable
class ChangeDateState extends EmployeeState {
  String? type;
  String? date;

  ChangeDateState({this.type, this.date});
}

