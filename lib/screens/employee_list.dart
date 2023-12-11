import 'dart:async';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:demo/models/employee_model.dart';
import 'package:demo/screens/add_employee_details.dart';
import 'package:demo/utils/colors.dart';
import 'package:demo/utils/icons.dart';
import 'package:demo/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _start = 0;
  late Timer _timer;
  EmployeeBloc demoBloc = EmployeeBloc();
  List<EmployeeModel>? list = [];
  List<EmployeeModel>? currentList = [];
  List<EmployeeModel>? previousList = [];

  String formatDate(String dateTime) {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime);
    String date = DateFormat("d MMM yyyy").format(tempDate);
    return date;
  }

  final List<String> items = [
    StringConstants.productDesigner,
    StringConstants.flutterDeveloper,
    StringConstants.qaTester,
    StringConstants.productOwner
  ];

  void startTimer(int index, EmployeeModel employeeModel) {
    const oneSec = Duration(seconds: 2);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        _start = _start++;
        if (timer.tick == 2) {
          timer.cancel();
          demoBloc.add(DeleteEmployeeEvent(
              index: index, employeeModel: employeeModel, isHardDelete: true));
        }
      },
    );
  }

  @override
  void initState() {
    demoBloc.add(GetAllEmployeeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      bloc: demoBloc,
      listener: (context, state) {
        if (state is GetAllEmployeeState) {
          list?.clear();
          previousList?.clear();
          currentList?.clear();
          list?.addAll(state.employeeModel ?? []);
          list?.forEach((element) {
            if (element.toDate != null && element.toDate != "") {
              previousList!.add(element);
            } else {
              currentList!.add(element);
            }
          });
        } else if (state is DeleteEmployeeState) {
          startTimer(state.index ?? 0, state.employeeModel ?? EmployeeModel());
          if (state.type == "current") {
            if (state.isHardDelete ?? false) {
              _timer.cancel();
            } else {
              currentList?.removeAt(state.index ?? 0);
              var snackBar = SnackBar(
                  action: SnackBarAction(
                    label: StringConstants.undo,
                    textColor: AppColors.darkBlueColor,
                    onPressed: () {
                      _timer.cancel();
                      demoBloc.add(UndoEvent(
                          type: state.type,
                          index: state.index,
                          employeeModel: state.employeeModel));
                    },
                  ),
                  content: const Text(StringConstants.employeeDataDeleted));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else {
            if (state.isHardDelete ?? false) {
              _timer.cancel();
            } else {
              previousList?.removeAt(state.index ?? 0);
              var snackBar = SnackBar(
                  action: SnackBarAction(
                    label: StringConstants.undo,
                    textColor: AppColors.darkBlueColor,
                    onPressed: () {
                      demoBloc.add(UndoEvent(
                          index: state.index,
                          employeeModel: state.employeeModel));
                      demoBloc.add(
                          AddEmployeeEvent(employeeModel: state.employeeModel));
                    },
                  ),
                  content: const Text(StringConstants.employeeDataDeleted));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
          list?.removeWhere((element) => element.id == state.employeeModel?.id);
        } else if (state is UndoState) {
          if (state.type == "current") {
            list?.insert(
                state.index ?? 0, state.employeeModel ?? EmployeeModel());
            currentList?.insert(
                state.index ?? 0, state.employeeModel ?? EmployeeModel());
          } else {
            list?.insert(
                state.index ?? 0, state.employeeModel ?? EmployeeModel());
            previousList?.insert(
                state.index ?? 0, state.employeeModel ?? EmployeeModel());
          }
        }
      },
      child: BlocBuilder<EmployeeBloc, EmployeeState>(
        bloc: demoBloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.darkBlueColor,
                statusBarIconBrightness: Brightness.dark,
              ),
              backgroundColor: AppColors.darkBlueColor,
              title: const Text(
                StringConstants.employeeList,
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
            body: list?.isNotEmpty ?? true
                ? employeeList()
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(AppAsset.noRecordFound),
                        const Text(
                          StringConstants.noEmployeeRecordFound,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.offBlackColor),
                        ),
                      ],
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.darkBlueColor,
              onPressed: () async {
                var result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddEmployeeDetails(
                          demoBloc: demoBloc,
                        )));
                if (result == true) {
                  demoBloc.add(GetAllEmployeeEvent());
                }
              },
              tooltip: StringConstants.increment,
              child: SvgPicture.asset(AppAsset.plusIcon),
            ),
          );
        },
      ),
    );
  }

  Widget employeeList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          currentList?.isEmpty ?? true
              ? Container()
              : Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  height: 56,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      StringConstants.currentEmployees,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.darkBlueColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentList?.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    var result =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddEmployeeDetails(
                                  demoBloc: demoBloc,
                                  type: "update",
                                  employeeModel: currentList?[index],
                                )));
                    if (result == true) {
                      demoBloc.add(GetAllEmployeeEvent());
                    }
                  },
                  child: SwipeActionCell(
                      key: ObjectKey(currentList?[index]),
                      trailingActions: <SwipeAction>[
                        SwipeAction(
                            icon: SvgPicture.asset(AppAsset.delete),
                            onTap: (CompletionHandler handler) async {
                              demoBloc.add(DeleteEmployeeEvent(
                                  index: index,
                                  employeeModel: currentList?[index],
                                  type: "current"));
                            },
                            color: AppColors.redColor),
                      ],
                      child: detailContainer(
                          index, currentList![index], StringConstants.current)),
                );
              }),
          currentList?.isNotEmpty ?? true
              ? Container(
                  height: 10,
                  color: AppColors.whiteColor,
                )
              : const SizedBox(),
          previousList?.isEmpty ?? true
              ? Container()
              : Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  height: 56,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      StringConstants.previousEmployees,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.darkBlueColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: previousList?.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () async {
                      var result =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddEmployeeDetails(
                                    demoBloc: demoBloc,
                                    type: "update",
                                    employeeModel: previousList?[index],
                                  )));
                      if (result == true) {
                        demoBloc.add(GetAllEmployeeEvent());
                      }
                    },
                    child: SwipeActionCell(
                        key: ObjectKey(previousList?[index]),
                        trailingActions: <SwipeAction>[
                          SwipeAction(
                              icon: SvgPicture.asset(AppAsset.delete),
                              onTap: (CompletionHandler handler) async {
                                demoBloc.add(DeleteEmployeeEvent(
                                    index: index,
                                    employeeModel: previousList?[index]));
                              },
                              color: AppColors.redColor),
                        ],
                        child: detailContainer(index, previousList![index],
                            StringConstants.previous)));
              }),
          Container(
            color: AppColors.whiteColor,
          ),
          list?.isEmpty ?? true
              ? Container()
              : const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(StringConstants.swipeLeftToDlt,
                          style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400))),
                )
        ],
      ),
    );
  }

  Widget detailContainer(int index, EmployeeModel model, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: AppColors.whiteColor,
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.empName ?? "",
                style: const TextStyle(
                    color: AppColors.offBlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                height: 5,
                color: AppColors.whiteColor,
              ),
              Text(model.empRole ?? "",
                  style: const TextStyle(
                      color: AppColors.grayColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              Container(
                height: 5,
                color: AppColors.whiteColor,
              ),
              Text(
                  model.fromDate?.isEmpty ?? true
                      ? ""
                      : type == StringConstants.current
                          ? 'From ${formatDate(model.fromDate ?? "")}'
                          : "${formatDate(model.fromDate ?? "")} - ${formatDate(model.toDate ?? "")}",
                  style: const TextStyle(
                      color: AppColors.grayColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400)),
              Container(
                height: 5,
                color: AppColors.whiteColor,
              ),
            ],
          ),
        ),
        Container(
          height: 10,
          color: AppColors.whiteColor,
        ),
        type == StringConstants.current
            ? index == ((currentList?.length ?? 0) - 1)
                ? Container()
                : Container(
                    color: AppColors.whiteColor,
                    child: const Divider(
                      color: AppColors.borderColor,
                      height: 0,
                    ))
            : index == ((previousList?.length ?? 0) - 1)
                ? Container()
                : Container(
                    color: AppColors.whiteColor,
                    child: const Divider(
                      color: AppColors.borderColor,
                      height: 0,
                    ))
      ],
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: AppColors.redColor,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [SvgPicture.asset(AppAsset.delete)],
        ),
      ),
    );
  }
}
