class ExamPeriod {
  final DateTime startDate;
  final DateTime endDate;

  const ExamPeriod({
    required this.startDate,
    required this.endDate,
  });
}

class StudentProfileEntity {
  final int userId;
  final String? university;
  final String? faculty;
  final int? studyYear; // 1–6
  final int? monthlyIncome; // VNĐ
  final DateTime? incomeDate; // ngày nhận tiền hàng tháng
  final List<ExamPeriod> examPeriods;

  const StudentProfileEntity({
    required this.userId,
    this.university,
    this.faculty,
    this.studyYear,
    this.monthlyIncome,
    this.incomeDate,
    this.examPeriods = const [],
  });
}
