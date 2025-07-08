class DailyForecastModel {
  final String date;

  // Temperature in Celsius and Fahrenheit
  final double maxTemp;
  final double minTemp;
  final double avgTemp;
  final double maxTempF;
  final double minTempF;
  final double avgTempF;

  final double maxWindMph;
  final double maxWindKph;
  final double totalPrecipMm;
  final double totalPrecipIn;
  final double totalSnowCm;
  final double avgVisibilityKm;
  final double avgVisibilityMiles;
  final int humidity;
  final int willItRain;
  final int chanceOfRain;
  final int willItSnow;
  final int chanceOfSnow;
  final String conditionText;
  final String iconUrl;
  final double uv;

  // Astro
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final String moonPhase;
  final int moonIllumination;

  DailyForecastModel({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.avgTemp,
    required this.maxTempF,
    required this.minTempF,
    required this.avgTempF,
    required this.maxWindMph,
    required this.maxWindKph,
    required this.totalPrecipMm,
    required this.totalPrecipIn,
    required this.totalSnowCm,
    required this.avgVisibilityKm,
    required this.avgVisibilityMiles,
    required this.humidity,
    required this.willItRain,
    required this.chanceOfRain,
    required this.willItSnow,
    required this.chanceOfSnow,
    required this.conditionText,
    required this.iconUrl,
    required this.uv,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.moonIllumination,
  });

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    final day = json["day"];
    final astro = json["astro"];

    return DailyForecastModel(
      date: json["date"],

      // Celsius
      maxTemp: day["maxtemp_c"].toDouble(),
      minTemp: day["mintemp_c"].toDouble(),
      avgTemp: day["avgtemp_c"].toDouble(),

      // Fahrenheit
      maxTempF: day["maxtemp_f"].toDouble(),
      minTempF: day["mintemp_f"].toDouble(),
      avgTempF: day["avgtemp_f"].toDouble(),

      maxWindMph: day["maxwind_mph"].toDouble(),
      maxWindKph: day["maxwind_kph"].toDouble(),
      totalPrecipMm: day["totalprecip_mm"].toDouble(),
      totalPrecipIn: day["totalprecip_in"].toDouble(),
      totalSnowCm: day["totalsnow_cm"].toDouble(),
      avgVisibilityKm: day["avgvis_km"].toDouble(),
      avgVisibilityMiles: day["avgvis_miles"].toDouble(),
      humidity: int.parse(day["avghumidity"].toString()),
      willItRain: day["daily_will_it_rain"],
      chanceOfRain: day["daily_chance_of_rain"],
      willItSnow: day["daily_will_it_snow"],
      chanceOfSnow: day["daily_chance_of_snow"],
      conditionText: day["condition"]["text"],
      iconUrl: day["condition"]["icon"],
      uv: day["uv"].toDouble(),

      sunrise: astro["sunrise"],
      sunset: astro["sunset"],
      moonrise: astro["moonrise"],
      moonset: astro["moonset"],
      moonPhase: astro["moon_phase"],
      moonIllumination: int.parse(astro["moon_illumination"].toString()),
    );
  }
}
