/// Report Model
/// 
/// Implements SRS 2.9 - Report Management
/// Contains medical report details
class ReportModel {
  final String id;
  final String userId;
  final String title; // SRS 2.9.1 (SRS-126)
  final String? description;
  final String? filePath; // Local storage path
  final String? fileUrl; // Cloud storage URL
  final String reportType;
  final DateTime reportDate; // SRS 2.9.1 (SRS-126)
  final DateTime createdAt;
  final DateTime updatedAt;

  ReportModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.filePath,
    this.fileUrl,
    this.reportType = 'General',
    required this.reportDate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON (local storage)
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      filePath: json['filePath'],
      fileUrl: json['fileUrl'],
      reportType: json['reportType'] ?? 'General',
      reportDate: json['reportDate'] != null
          ? DateTime.parse(json['reportDate'])
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Convert to JSON (local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'filePath': filePath,
      'fileUrl': fileUrl,
      'reportType': reportType,
      'reportDate': reportDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create copy with updated fields
  ReportModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? filePath,
    String? fileUrl,
    String? reportType,
    DateTime? reportDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
      fileUrl: fileUrl ?? this.fileUrl,
      reportType: reportType ?? this.reportType,
      reportDate: reportDate ?? this.reportDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'ReportModel(id: $id, title: $title, date: $reportDate)';
  }
}
