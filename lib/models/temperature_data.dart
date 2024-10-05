class Temperature {
  final double temperature;
  final String date;

  Temperature({required this.temperature, required this.date});

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      temperature: json['T2M'] ?? 0.0,
      date: json['date'] ?? '',
    );
  }
}
