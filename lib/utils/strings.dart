import 'package:intl/intl.dart';

class StringConstants {
  static const String today = 'Today';
  static const String nextMonday = 'Next Monday';
  static const String nextTuesday = 'Next Tuesday';
  static const String afterAWeek = 'After 1 week';
  static const String noDate = 'No date';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String selectedRole = 'Select role';
  static const String addEmployeeDetails = 'Add Employee Details';
  static const String editEmployeeDetails = 'Edit Employee Details';
  static const String employeeName = 'Employee name';
  static const String productDesigner = 'Product Designer';
  static const String flutterDeveloper = 'Flutter Developer';
  static const String qaTester = 'QA Tester';
  static const String productOwner = 'Product Owner';
  static const String employeeList = 'Employee List';
  static const String noEmployeeRecordFound = 'No employee records found';
  static const String increment = 'Increment';
  static const String currentEmployees = 'Current employees';
  static const String previousEmployees = 'Previous employees';
  static const String current = 'Current';
  static const String previous = 'Previous';
  static const String swipeLeftToDlt = 'Swipe left to delete';
  static const String employeeDataDeleted = 'Employee data has been deleted';
  static const String undo = 'Undo';
  static const String plsEnterName = 'Please enter name';
  static const String plsEnterRole = 'Please enter role';

  static String formatDate(DateTime chosenDate) =>
      DateFormat("d MMM yyyy").format(chosenDate);
}
