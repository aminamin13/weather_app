class HourlyForecastModel {
  final String time;
  final double tempC;
  final double tempF;
  final bool isDay;
  final String conditionText;
  final String conditionIcon;
  final int conditionCode;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final double precipMm;
  final double snowCm;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double windchillC;
  final double heatindexC;
  final double dewpointC;
  final int willItRain;
  final int chanceOfRain;
  final int willItSnow;
  final int chanceOfSnow;
  final double visKm;
  final double gustMph;
  final double uv;

  HourlyForecastModel({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.conditionText,
    required this.conditionIcon,
    required this.conditionCode,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.precipMm,
    required this.snowCm,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.windchillC,
    required this.heatindexC,
    required this.dewpointC,
    required this.willItRain,
    required this.chanceOfRain,
    required this.willItSnow,
    required this.chanceOfSnow,
    required this.visKm,
    required this.gustMph,
    required this.uv,
  });

  factory HourlyForecastModel.fromJson(Map<String, dynamic> json) {
    return HourlyForecastModel(
      time: json['time'],
      tempC: (json['temp_c'] ?? 0).toDouble(),
      tempF: (json['temp_f'] ?? 0).toDouble(),
      isDay: json['is_day'] == 1,
      conditionText: json['condition']?['text'] ?? '',
      conditionIcon: json['condition']?['icon'] ?? '',
      conditionCode: json['condition']?['code'] ?? 0,
      windMph: (json['wind_mph'] ?? 0).toDouble(),
      windKph: (json['wind_kph'] ?? 0).toDouble(),
      windDegree: json['wind_degree'] ?? 0,
      windDir: json['wind_dir'] ?? '',
      pressureMb: (json['pressure_mb'] ?? 0).toDouble(),
      precipMm: (json['precip_mm'] ?? 0).toDouble(),
      snowCm: (json['snow_cm'] ?? 0).toDouble(),
      cloud: json['cloud'] ?? 0,
      feelslikeC: (json['feelslike_c'] ?? 0).toDouble(),
      windchillC: (json['windchill_c'] ?? 0).toDouble(),
      heatindexC: (json['heatindex_c'] ?? 0).toDouble(),
      dewpointC: (json['dewpoint_c'] ?? 0).toDouble(),
      willItRain: json['will_it_rain'] ?? 0,
      chanceOfRain: json['chance_of_rain'] ?? 0,
      willItSnow: json['will_it_snow'] ?? 0,
      chanceOfSnow: json['chance_of_snow'] ?? 0,
      visKm: (json['vis_km'] ?? 0).toDouble(),
      gustMph: (json['gust_mph'] ?? 0).toDouble(),
      uv: (json['uv'] ?? 0).toDouble(),
      humidity: json['humidity'] ?? 0,
    );
  }
}
