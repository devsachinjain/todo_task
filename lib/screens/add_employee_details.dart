import 'package:demo/bloc/employee_bloc.dart';
import 'package:demo/screens/calender_screen.dart';
import 'package:demo/utils/colors.dart';
import 'package:demo/utils/icons.dart';
import 'package:demo/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../components/custom_button.dart';
import '../models/employee_model.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class AddEmployeeDetails extends StatefulWidget {
  EmployeeBloc demoBloc;
  String? type;
  EmployeeModel? employeeModel;
  AddEmployeeDetails(
      {super.key, required this.demoBloc, this.type, this.employeeModel});
  @override
  State<AddEmployeeDetails> createState() => _AddEmployeeDetailsState();
}

class _AddEmployeeDetailsState extends State<AddEmployeeDetails> {
  String selectedRole = StringConstants.selectedRole;
  TextEditingController nameController = TextEditingController();
  String? fromDate;
  String? tempFromDate;
  String? tempToDate;
  String? toDate;
  bool? loader;

  @override
  void initState() {
    if (widget.type == "update") {
      selectedRole =
          widget.employeeModel?.empRole ?? StringConstants.selectedRole;
      fromDate = formatDate(widget.employeeModel?.fromDate ?? "");
      tempFromDate = (widget.employeeModel?.fromDate ?? "");
      tempToDate = (widget.employeeModel?.toDate ?? "");
      if (widget.employeeModel?.toDate != null &&
          widget.employeeModel?.toDate != "") {
        toDate = formatDate(widget.employeeModel?.toDate ?? "");
      }
      nameController.text = widget.employeeModel?.empName ?? "";
    }
    super.initState();
  }

  String formatDate(String dateTime) {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime);
    String date = DateFormat("d MMM yyyy").format(tempDate);
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      bloc: widget.demoBloc,
      listener: (context, state) {
        if (state is SelectRoleState) {
          selectedRole = state.role ?? StringConstants.selectedRole;
        } else if (state is ChangeDateState) {
          if (state.type == StringConstants.today) {
            fromDate = formatDate(state.date ?? "");
            tempFromDate = state.date;
          } else {
            toDate = formatDate(state.date ?? "");
            tempToDate = state.date;
          }
        } else if (state is AddEmployeeState) {
          Navigator.pop(context, true);
        } else if (state is UpdateEmployeeState) {
          Navigator.pop(context, true);
        } else if (state is DeleteEmployeeState) {
          Navigator.pop(context, true);
        }
      },
      child: BlocBuilder<EmployeeBloc, EmployeeState>(
        bloc: widget.demoBloc,
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.darkBlueColor,
                statusBarIconBrightness: Brightness.dark,
              ),
              backgroundColor: AppColors.darkBlueColor,
              automaticallyImplyLeading: false,
              title: Text(
                widget.type == "update"
                    ? StringConstants.editEmployeeDetails
                    : StringConstants.addEmployeeDetails,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              actions: [
                if (widget.type == "update")
                  GestureDetector(
                      onTap: () {
                        widget.demoBloc.add(DeleteEmployeeEvent(
                            employeeModel: widget.employeeModel,
                            isHardDelete: true));
                      },
                      child: SvgPicture.asset(AppAsset.delete)),
                const SizedBox(width: 20),
              ],
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                nameContainer(),
                selectRole(),
                date(),
                const Spacer(),
                const Divider(
                  color: AppColors.borderColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      title: StringConstants.cancel,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      width: 70,
                      height: 40,
                      radius: 6,
                    ),
                    const SizedBox(width: 10),
                    CustomButton(
                      title: StringConstants.save,
                      onPressed: () {
                        validate();
                      },
                      isActive: true,
                      width: 70,
                      height: 40,
                      radius: 6,
                    ),
                    const SizedBox(
                      width: 16,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget nameContainer() {
    return Padding(
      padding: const EdgeInsets.all(13),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.textFieldBorderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            SvgPicture.asset(AppAsset.person),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 17),
                child: TextField(
                  cursorColor: AppColors.darkBlueColor,
                  controller: nameController,
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: AppColors.offBlackColor,
                      fontWeight: FontWeight.w400),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: StringConstants.employeeName,
                      hintStyle: TextStyle(color: AppColors.grayColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectRole() {
    return Padding(
      padding: const EdgeInsets.all(13),
      child: InkWell(
        onTap: () {
          bottomSheet();
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.textFieldBorderColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              SvgPicture.asset(AppAsset.selectDate),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: Text(
                selectedRole,
                style: TextStyle(
                    color: selectedRole == StringConstants.selectedRole
                        ? AppColors.grayColor
                        : AppColors.offBlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              )),
              SvgPicture.asset(AppAsset.dropDown),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget date() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.textFieldBorderColor,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: InkWell(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          surfaceTintColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          insetPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 90),
                          child: CalenderView(
                            demoBloc: widget.demoBloc,
                            type: StringConstants.today,
                            fromDatesaveCallBack: (val) {
                              fromDate = val.toString();
                            },
                          ),
                        );
                      });
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(AppAsset.calenderIcon),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: Text(
                      fromDate ?? StringConstants.today,
                      style: TextStyle(
                          color: fromDate?.isEmpty ?? true
                              ? AppColors.offBlackColor
                              : AppColors.offBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
        SvgPicture.asset(AppAsset.arrow),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.textFieldBorderColor,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 90),
                          child: CalenderView(
                            type: StringConstants.noDate,
                            demoBloc: widget.demoBloc,
                            toDateInitialValue: fromDate,
                            toDatesaveCallBack: (val) {
                              toDate = val.toString();
                            },
                          ),
                        );
                      });
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(AppAsset.calenderIcon),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: Text(
                      toDate ?? StringConstants.noDate,
                      style: TextStyle(
                          color: toDate?.isEmpty ?? true
                              ? AppColors.grayColor
                              : AppColors.offBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bottomSheet() {
    final List<String> items = [
      StringConstants.productDesigner,
      StringConstants.flutterDeveloper,
      StringConstants.qaTester,
      StringConstants.productOwner
    ];
    return showModalBottomSheet(
        backgroundColor: AppColors.whiteColor,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 230,
            child: Center(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                      color: AppColors.textFieldBorderColor, height: 1);
                },
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Center(
                        child: Text(
                      items[index],
                      style: const TextStyle(
                          color: AppColors.offBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    )),
                    onTap: () {
                      widget.demoBloc.add(SelectRoleEvent(role: items[index]));
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  validate() {
    if (nameController.text.isEmpty) {
      var snackBar = const SnackBar(content: Text(StringConstants.plsEnterName));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (selectedRole.isEmpty || selectedRole == StringConstants.selectedRole) {
      var snackBar = const SnackBar(content: Text(StringConstants.plsEnterRole));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (widget.type == "update") {
        widget.demoBloc.add(UpdateEmployeeEvent(
            employeeModel: EmployeeModel(
                id: widget.employeeModel?.id,
                empRole: selectedRole,
                fromDate: tempFromDate ?? DateTime.now().toString(),
                empName: nameController.text,
                toDate: tempToDate ?? "")));
      } else {
        widget.demoBloc.add(AddEmployeeEvent(
            employeeModel: EmployeeModel(
                empRole: selectedRole,
                fromDate: tempFromDate ?? DateTime.now().toString(),
                empName: nameController.text,
                toDate: tempToDate ?? "")));
      }
    }
  }
}
