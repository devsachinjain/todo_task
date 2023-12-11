import 'package:demo/models/calenderModel.dart';
import 'package:flutter/cupertino.dart';

import '../models/employee_model.dart';

@immutable
abstract class EmployeeEvent {}

// ignore: must_be_immutable
class SelectRoleEvent extends EmployeeEvent {
  String? role;

  SelectRoleEvent({this.role});
}

// ignore: must_be_immutable
class AddEmployeeEvent extends EmployeeEvent {
  EmployeeModel? employeeModel;

  AddEmployeeEvent({this.employeeModel});
}

// ignore: must_be_immutable
class UpdateEmployeeEvent extends EmployeeEvent {
  EmployeeModel? employeeModel;

  UpdateEmployeeEvent({this.employeeModel});
}

// ignore: must_be_immutable
class DeleteEmployeeEvent extends EmployeeEvent {
  EmployeeModel? employeeModel;
  int? index;
  String? type;
  bool? isHardDelete;

  DeleteEmployeeEvent(
      {this.employeeModel, this.index, this.type, this.isHardDelete});
}

// ignore: must_be_immutable
class UndoEvent extends EmployeeEvent {
  EmployeeModel? employeeModel;
  int? index;
  String? type;

  UndoEvent({this.employeeModel, this.index, this.type});
}

class GetAllEmployeeEvent extends EmployeeEvent {
  GetAllEmployeeEvent();
}

// ignore: must_be_immutable
class CalenderEvent extends EmployeeEvent {
  CalenderModel? calenderModel;

  CalenderEvent({this.calenderModel});
}

// ignore: must_be_immutable
class ChangeDateEvent extends EmployeeEvent {
  String? type;
  String? date;

  ChangeDateEvent({this.type, this.date});
}

class StartLoadingEvent extends EmployeeEvent {
  StartLoadingEvent();
}

class EndLoadingEvent extends EmployeeEvent {
  EndLoadingEvent();
}
