class EmployeeModel {
  int? id;
  String? empName;
  String? empRole;
  String? fromDate;
  String? toDate;

  EmployeeModel(
      {this.id, this.empName, this.empRole, this.toDate, this.fromDate});

  factory EmployeeModel.fromJSON(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      empName: json['empName'],
      empRole: json['empRole'],
      toDate: json['toDate'],
      fromDate: json['fromDate'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'empName': empName,
      'empRole': empRole,
      'toDate': toDate,
      'fromDate': fromDate,
    };
  }
}
