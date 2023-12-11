import 'package:demo/bloc/employee_bloc.dart';
import 'package:demo/bloc/employee_event.dart';
import 'package:demo/components/custom_button.dart';
import 'package:demo/models/calenderModel.dart';
import 'package:demo/utils/colors.dart';
import 'package:demo/utils/icons.dart';
import 'package:demo/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';
import '../bloc/employee_state.dart';

// ignore: must_be_immutable
class CalenderView extends StatefulWidget {
  EmployeeBloc? demoBloc;
  Function? fromDatesaveCallBack;
  Function? toDatesaveCallBack;
  String? type;
  String? toDateInitialValue;
  CalenderView(
      {super.key,
      this.demoBloc,
      this.fromDatesaveCallBack,
      this.toDatesaveCallBack,
      this.type,
      this.toDateInitialValue});
  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  bool isTodayActive = true;
  bool isNoDateActive = false;
  bool isNextMondayActive = false;
  bool isNextTuesdayActive = false;
  bool isAfterAWeekActive = false;
  bool isSave = true;
  DateTime chosenDate = DateTime.now();
  DateTime focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print('${widget.toDateInitialValue}');
    return BlocListener<EmployeeBloc, EmployeeState>(
      bloc: widget.demoBloc,
      listener: (context, state) {
        if (state is CalenderState) {
          isTodayActive = state.calenderModel?.isTodayActive ?? false;
          isNextMondayActive = state.calenderModel?.isNextMondayActive ?? false;
          isNextTuesdayActive =
              state.calenderModel?.isNextTuesdayActive ?? false;
          chosenDate = state.calenderModel?.chosenDate ?? DateTime.now();
          focusedDate = state.calenderModel?.focusedDate ?? DateTime.now();
          isAfterAWeekActive = state.calenderModel?.isAfterAWeekActive ?? false;
          isNoDateActive = state.calenderModel?.isNoDateActive ?? false;
        }
      },
      child: BlocBuilder<EmployeeBloc, EmployeeState>(
        bloc: widget.demoBloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: Container(
              height: MediaQuery.of(context).size.height / 1.4,
              width: MediaQuery.of(context).size.width / 1.07,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.0),
                  color: AppColors.whiteColor),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 15.0, left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.type == StringConstants.noDate)
                        CustomButton(
                          title: StringConstants.noDate,
                          onPressed: () {
                            widget.demoBloc?.add(CalenderEvent(
                                calenderModel: CalenderModel(
                                    chosenDate: null,
                                    focusedDate: null,
                                    isAfterAWeekActive: false,
                                    isNextMondayActive: false,
                                    isNextTuesdayActive: false,
                                    isTodayActive: false,
                                    isNoDateActive: true)));
                          },
                          isActive: isNoDateActive,
                          width: MediaQuery.of(context).size.width / 2.45,
                          height: 36,
                          radius: 4,
                        ),
                      CustomButton(
                        title: StringConstants.today,
                        onPressed: () {
                          widget.demoBloc?.add(CalenderEvent(
                              calenderModel: CalenderModel(
                                  chosenDate: DateTime.now(),
                                  focusedDate: DateTime.now(),
                                  isAfterAWeekActive: false,
                                  isNextMondayActive: false,
                                  isNextTuesdayActive: false,
                                  isTodayActive: true,
                                  isNoDateActive: false)));
                        },
                        isActive: isTodayActive,
                        width: MediaQuery.of(context).size.width / 2.45,
                        height: 36,
                        radius: 4,
                      ),
                      if (widget.type == StringConstants.today)
                        CustomButton(
                          title: StringConstants.nextMonday,
                          onPressed: () {
                            int daysUntilNextMonday =
                                (8 - chosenDate.weekday) % 7;
                            DateTime nextMonday = chosenDate
                                .add(Duration(days: daysUntilNextMonday));
                            widget.demoBloc?.add(CalenderEvent(
                                calenderModel: CalenderModel(
                                    chosenDate: nextMonday,
                                    focusedDate: nextMonday,
                                    isAfterAWeekActive: false,
                                    isNextMondayActive: true,
                                    isNextTuesdayActive: false,
                                    isTodayActive: false)));
                          },
                          isActive: isNextMondayActive,
                          width: MediaQuery.of(context).size.width / 2.45,
                          height: 36,
                          radius: 4,
                        )
                    ],
                  ),
                ),
                if (widget.type == StringConstants.today)
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          title: StringConstants.nextTuesday,
                          onPressed: () {
                            int daysUntilNextTuesday =
                                (9 - chosenDate.weekday) % 7;
                            DateTime nextTuesday = chosenDate
                                .add(Duration(days: daysUntilNextTuesday));
                            widget.demoBloc?.add(CalenderEvent(
                                calenderModel: CalenderModel(
                                    chosenDate: nextTuesday,
                                    focusedDate: nextTuesday,
                                    isAfterAWeekActive: false,
                                    isNextMondayActive: false,
                                    isNextTuesdayActive: true,
                                    isTodayActive: false)));
                          },
                          isActive: isNextTuesdayActive,
                          width: MediaQuery.of(context).size.width / 2.45,
                          height: 36,
                          radius: 4,
                        ),
                        CustomButton(
                          title: StringConstants.afterAWeek,
                          onPressed: () {
                            DateTime nextWeek =
                                chosenDate.add(const Duration(days: 7));
                            widget.demoBloc?.add(CalenderEvent(
                                calenderModel: CalenderModel(
                                    chosenDate: nextWeek,
                                    focusedDate: nextWeek,
                                    isAfterAWeekActive: true,
                                    isNextMondayActive: false,
                                    isNextTuesdayActive: false,
                                    isTodayActive: false)));
                          },
                          isActive: isAfterAWeekActive,
                          width: MediaQuery.of(context).size.width / 2.45,
                          height: 36,
                          radius: 4,
                        )
                      ],
                    ),
                  ),
                TableCalendar(
                  firstDay: (widget.type == StringConstants.noDate)
                      ? (widget.toDateInitialValue != null)
                          ? DateFormat("d MMM yyyy")
                              .parse(widget.toDateInitialValue.toString())
                          : DateTime.now()
                      : DateTime.utc(1990, 01, 01),
                  lastDay: DateTime.utc(3000, 01, 01),
                  focusedDay: (widget.type == StringConstants.noDate)
                      ? (widget.toDateInitialValue != null)
                          ? DateFormat("d MMM yyyy")
                              .parse(widget.toDateInitialValue.toString())
                          : DateTime.now()
                      : chosenDate,
                  selectedDayPredicate: (day) => isSameDay(day, chosenDate),
                  onDaySelected: (selectedDate, focusedDate) {
                    widget.demoBloc?.add(CalenderEvent(
                        calenderModel: CalenderModel(
                            chosenDate: selectedDate,
                            focusedDate: focusedDate,
                            isAfterAWeekActive: false,
                            isNextMondayActive: false,
                            isNextTuesdayActive: false,
                            isTodayActive: false)));
                  },
                  onDayLongPressed: (selectedDay, focusedDay) {
                    widget.demoBloc?.add(CalenderEvent(
                        calenderModel: CalenderModel(
                            chosenDate: selectedDay,
                            focusedDate: focusedDay,
                            isAfterAWeekActive: false,
                            isNextMondayActive: false,
                            isNextTuesdayActive: false,
                            isTodayActive: false)));
                  },
                  onPageChanged: (date) {
                    isTodayActive = false;
                    isNextMondayActive = false;
                    isNextTuesdayActive = false;
                    isAfterAWeekActive = false;
                    focusedDate = date;
                  },
                  formatAnimationDuration: const Duration(milliseconds: 500),
                  formatAnimationCurve: Curves.linear,
                  rowHeight: 40,
                  daysOfWeekHeight: 43,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                    weekendStyle: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  calendarStyle: CalendarStyle(
                      markerDecoration: const BoxDecoration(
                        color: AppColors.darkBlueColor,
                      ),
                      selectedTextStyle: TextStyle(
                          color: isNoDateActive == true
                              ? AppColors.blackColor
                              : AppColors.whiteColor,
                          fontSize: 15),
                      selectedDecoration: BoxDecoration(
                          color: (isNoDateActive == true)
                              ? AppColors.whiteColor
                              : AppColors.darkBlueColor,
                          shape: BoxShape.circle),
                      todayDecoration: const BoxDecoration(
                          color: AppColors.whiteColor, shape: BoxShape.circle),
                      todayTextStyle: const TextStyle(
                          color: AppColors.blackColor, fontSize: 15),
                      weekendTextStyle: const TextStyle(
                          color: AppColors.blackColor, fontSize: 15),
                      weekNumberTextStyle: const TextStyle(
                          color: AppColors.blackColor, fontSize: 15),
                      outsideTextStyle: const TextStyle(
                          color: AppColors.blackColor, fontSize: 15)),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextStyle: const TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                    formatButtonVisible: false,
                    leftChevronIcon:
                        SvgPicture.asset(AppAsset.calendarLeftArrow),
                    rightChevronIcon:
                        SvgPicture.asset(AppAsset.calendarRightArrow),
                    leftChevronMargin: const EdgeInsets.only(left: 50),
                    rightChevronMargin: const EdgeInsets.only(right: 50),
                  ),
                ),
                const Spacer(),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    color: AppColors.borderColor),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 13.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            AppAsset.calenderIcon,
                          ),
                          const SizedBox(width: 10),
                          Text(
                              isNoDateActive == true
                                  ? StringConstants.noDate
                                  : StringConstants.formatDate(chosenDate),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400))
                        ],
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
                          const SizedBox(width: 15),
                          CustomButton(
                            title: StringConstants.save,
                            onPressed: () {
                              widget.demoBloc?.add(ChangeDateEvent(
                                  date: isNoDateActive == true
                                      ? StringConstants.noDate
                                      : chosenDate.toString(),
                                  type: widget.type));
                              Navigator.pop(context);
                            },
                            isActive: true,
                            width: 70,
                            height: 40,
                            radius: 6,
                          )
                        ],
                      )
                    ],
                  ),
                )
              ]),
            )),
          );
        },
      ),
    );
  }
}
