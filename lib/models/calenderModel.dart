// ignore: file_names
class CalenderModel {
  bool? isTodayActive;
  bool? isNextMondayActive;
  bool? isNextTuesdayActive;
  bool? isAfterAWeekActive;
  bool? isNoDateActive;
  DateTime? chosenDate;
  DateTime? focusedDate;
  String? selectedDate;

  CalenderModel(
      {this.chosenDate,
      this.selectedDate,
      this.focusedDate,
      this.isAfterAWeekActive,
      this.isNextMondayActive,
      this.isNextTuesdayActive,
      this.isTodayActive,
      this.isNoDateActive});
}
