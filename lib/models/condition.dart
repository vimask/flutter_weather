//https://app.quicktype.io/
// To parse this JSON data, do
//
//     final wCondition = wConditionFromJson(jsonString);

import 'dart:convert';

WCondition wConditionFromJson(String str) {
    final jsonData = json.decode(str);
    return WCondition.fromJson(jsonData);
}

class WCondition {
    City city;
    String cityName;
    String cod;
    double message;
    int cnt;
    List<ListElement> list;

    WCondition({
        this.city,
        this.cityName,
        this.cod,
        this.message,
        this.cnt,
        this.list,
    });

    factory WCondition.fromJson(Map<String, dynamic> json) => new WCondition(
        city: City.fromJson(json["city"]),
        cityName: json["name"] == null ? null : json["name"],
        cod: json["cod"],
        message: json["message"].toDouble(),
        cnt: json["cnt"],
        list: json["list"] == null ? null : List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
    );
}

class City {
    int id;
    String name;
    String country;
    int population;

    City({
        this.id,
        this.name,
        this.country,
        this.population,
    });

    factory City.fromJson(Map<String, dynamic> json) => new City(
        id: json["id"],
        name: json["name"],
        country: json["country"],
        population: json["population"],
    );
}

class ListElement {
    int dt;
    Temp temp;
    Main main;
    double pressure;
    int humidity;
    List<Weather> weather;
    double speed;
    int deg;

    String timeHour() {
      var date = new DateTime.fromMillisecondsSinceEpoch(dt*1000);
      var hour = date.hour;
      return (hour < 12) ? "$hour AM" : "${hour - 12} PM";
    }

    String date() {
      var date = new DateTime.fromMillisecondsSinceEpoch(dt*1000);
      return "${date.day}/${date.month}/${date.year}";
    }

    ListElement({
        this.dt,
        this.temp,
        this.main,
        this.pressure,
        this.humidity,
        this.weather,
        this.speed,
        this.deg,
    });

    factory ListElement.fromJson(Map<String, dynamic> json) => new ListElement(
        dt: json["dt"],
        temp: json["temp"] == null ? null : Temp.fromJson(json["temp"]),
        main: json["main"] == null ? null : Main.fromJson(json["main"]),
        pressure: json["pressure"] == null ? null : json["pressure"].toDouble(),
        humidity: json["humidity"] == null ? null : json["humidity"],
        weather: new List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
        speed: json["speed"] == null ? null : json["speed"].toDouble(),
        deg: json["deg"] == null ? null : json["deg"],
    );
}

class Temp {
    int day;
    double min;
    double max;
    double night;
    double eve;
    double morn;

    Temp({
        this.day,
        this.min,
        this.max,
        this.night,
        this.eve,
        this.morn,
    });

    factory Temp.fromJson(Map<String, dynamic> json) => new Temp(
        day: json["day"].toInt(),
        min: json["min"].toDouble(),
        max: json["max"].toDouble(),
        night: json["night"].toDouble(),
        eve: json["eve"].toDouble(),
        morn: json["morn"].toDouble(),
    );
}

class Main {
    int temp;
    double tempMin;
    double tempMax;
    double pressure;
    double seaLevel;
    double grndLevel;
    int humidity;

    Main({
        this.temp,
        this.tempMin,
        this.tempMax,
        this.pressure,
        this.seaLevel,
        this.grndLevel,
        this.humidity,
    });

    factory Main.fromJson(Map<String, dynamic> json) => new Main(
        temp: json["temp"].toInt(),
        tempMin: json["temp_min"].toDouble(),
        tempMax: json["temp_max"].toDouble(),
        pressure: json["pressure"].toDouble(),
        seaLevel: json["sea_level"] == null ? null : json["sea_level"].toDouble(),
        grndLevel: json["grnd_level"] == null ? null : json["grnd_level"].toDouble(),
        humidity: json["humidity"],
    );
}

class Weather {

    Map<String, String> icons = {
      "01d" : "weather-clear",
      "02d" : "weather-few",
      "03d" : "weather-few",
      "04d" : "weather-broken",
      "09d" : "weather-shower",
      "10d" : "weather-rain",
      "11d" : "weather-tstorm",
      "13d" : "weather-snow",
      "50d" : "weather-mist",
      "01n" : "weather-moon",
      "02n" : "weather-few-night",
      "03n" : "weather-few-night",
      "04n" : "weather-broken",
      "09n" : "weather-shower",
      "10n" : "weather-rain-night",
      "11n" : "weather-tstorm",
      "13n" : "weather-snow",
      "50n" : "weather-mist",
    };

    String assetIcon() {
      return "assets/${icons[icon]}.png";
    }

    int id;
    String main;
    String description;
    String icon;

    Weather({
        this.id,
        this.main,
        this.description,
        this.icon,
    });

    factory Weather.fromJson(Map<String, dynamic> json) => new Weather(
        id: json["id"],
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
    );
}


class CurrentWeather {
    Coord coord;
    List<Weather> weather;
    String base;
    Main main;
    int visibility;
    Clouds clouds;
    int dt;
    Sys sys;
    int id;
    String name;
    int cod;

    CurrentWeather({
        this.coord,
        this.weather,
        this.base,
        this.main,
        this.visibility,
        this.clouds,
        this.dt,
        this.sys,
        this.id,
        this.name,
        this.cod,
    });

    factory CurrentWeather.fromJson(Map<String, dynamic> json) => new CurrentWeather(
        coord: Coord.fromJson(json["coord"]),
        weather: new List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
        base: json["base"],
        main: json["main"] == null ? null : Main.fromJson(json["main"]),
        visibility: json["visibility"] == null ? null : json["visibility"],
        clouds: json["clouds"] == null ? null :Clouds.fromJson(json["clouds"]),
        dt: json["dt"] == null ? null :json["dt"],
        sys: json["sys"] == null ? null :Sys.fromJson(json["sys"]),
        id: json["id"] == null ? null :json["id"],
        name: json["name"] == null ? null :json["name"],
        cod: json["cod"] == null ? null :json["cod"],
    );

}

class Clouds {
    int all;

    Clouds({
        this.all,
    });

    factory Clouds.fromJson(Map<String, dynamic> json) => new Clouds(
        all: json["all"],
    );

    Map<String, dynamic> toJson() => {
        "all": all,
    };
}

class Coord {
    double lon;
    double lat;

    Coord({
        this.lon,
        this.lat,
    });

    factory Coord.fromJson(Map<String, dynamic> json) => new Coord(
        lon: json["lon"].toDouble(),
        lat: json["lat"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
    };
}

class Sys {
    int type;
    int id;
    double message;
    String country;
    int sunrise;
    int sunset;

    Sys({
        this.type,
        this.id,
        this.message,
        this.country,
        this.sunrise,
        this.sunset,
    });

    factory Sys.fromJson(Map<String, dynamic> json) => new Sys(
        type: json["type"],
        id: json["id"],
        message: json["message"].toDouble(),
        country: json["country"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "message": message,
        "country": country,
        "sunrise": sunrise,
        "sunset": sunset,
    };
}



