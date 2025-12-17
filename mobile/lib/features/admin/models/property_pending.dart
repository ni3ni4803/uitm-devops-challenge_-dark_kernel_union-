class PropertyPending {
  final String id;
  final String title;
  final String landlordName;
  final double rentPrice;
  final DateTime submissionDate;
  final String status; // e.g., 'Pending', 'Approved', 'Rejected'

  const PropertyPending({ // 🚨 Added 'const' constructor for compile-time constants (good practice)
    required this.id,
    required this.title,
    required this.landlordName,
    required this.rentPrice,
    required this.submissionDate,
    this.status = 'Pending',
  });

  // Factory constructor for API response (optional, but good practice)
  factory PropertyPending.fromJson(Map<String, dynamic> json) {
    return PropertyPending(
      id: json['id'] as String,
      title: json['title'] as String,
      landlordName: json['landlordName'] as String,
      rentPrice: (json['rentPrice'] as num).toDouble(),
      submissionDate: DateTime.parse(json['submissionDate'] as String),
      status: json['status'] as String,
    );
  }

  // 🚨 MODIFIED: copyWith now includes all fields as optional named parameters
  PropertyPending copyWith({
    String? id,
    String? title,
    String? landlordName,
    double? rentPrice,
    DateTime? submissionDate,
    String? status,
  }) {
    return PropertyPending(
      id: id ?? this.id,
      title: title ?? this.title,
      landlordName: landlordName ?? this.landlordName,
      rentPrice: rentPrice ?? this.rentPrice,
      submissionDate: submissionDate ?? this.submissionDate,
      status: status ?? this.status, // Only status defaults to the new value if provided
    );
  }
}