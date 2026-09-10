class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String iconCode;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? 'Local Desconhecido',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      iconCode: json['weather'][0]['icon'] ?? '01d',
    );
  }

  // Retorna a URL completa do ícone fornecido pela OpenWeather
  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@4x.png';
}