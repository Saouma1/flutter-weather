import 'package:flutter/material.dart';
import 'weather_model.dart';
import 'rest_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CIS 3334 Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<DailyForcast>> futureWeatherForecasts;

  @override
  void initState() {
    super.initState();
    futureWeatherForecasts = fetchWeather(); // Call your API fetch method here
  }

  Widget weatherTile(DailyForcast forecast) {
    return ListTile(
      leading: weatherImage(forecast), // We will define this function next
      title: Text("High: ${forecast.temp.max}°, Low: ${forecast.temp.min}°"),
      subtitle: Text("${forecast.weather[0].description}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<DailyForcast>>(
        future: futureWeatherForecasts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No weather data available"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                child: weatherTile(snapshot.data![index]),
              );
            },
          );
        },
      ),
    );
  }

  Widget weatherImage(DailyForcast forecast) {
    String imagePath;
    switch (forecast.weather[0].main.toLowerCase()) {
      case 'clear':
        imagePath = 'graphics/sun.png';
        break;
      case 'clouds':
        imagePath = 'graphics/cloud.png';
        break;
      case 'rain':
        imagePath = 'graphics/rain.png';
        break;
    // Add more cases as needed
      default:
        imagePath = 'graphics/default.png'; // A default image for unhandled cases
    }
    return Image.asset(imagePath);
  }
}