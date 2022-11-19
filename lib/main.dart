import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';


void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new weatherApp(),
  ));
}

class weatherApp extends StatefulWidget {
  @override
  _weatherAppState createState() => _weatherAppState();
}

class _weatherAppState extends State<weatherApp> {

  TextEditingController cityController = new TextEditingController();
  var currentCity;
  var temperature;
  var feelslike;
  var sunset,sunrise;
  var description;
  var showcityName;
  var humidity;
  var lati;
  var longi;
  var img  = "10d";


  // @override
  // initState() {
  //   getLocation();
  //
  //   super.initState();
  // }

  // geo(){
  //   setState(() {
  //     showcityName = showcityName = currentCity;
  //   });


  getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print("position = ");
    print(position);
    lati = position.latitude;
    longi = position.longitude;

    final queryparameter = {
      "lat": lati.toString(),
      "lon": longi.toString(),
      "appid": "e895bdd3ad3cd34431f90118626bb7e3"
    };

    Uri uri = Uri.https(
        "api.openweathermap.org", "/data/2.5/weather", queryparameter);
    var jsonData = await get(uri);
    var json = jsonDecode(jsonData.body);

    setState(() {
      currentCity = json["name"];
      temperature = json["main"]["temp"];
      feelslike = json["main"]["feels_like"];
      description = json["weather"][0]["description"];
      humidity = json["main"]["humidity"];
      img = json["weather"][0]["icon"];
      //img = "https://openweathermap.org/img/w/${json["weather"][0]["icon"]}.png";
    });
  }

  void getWeather() async {
    print("Method1");
    String city = cityController.text;
    print(city);

    final queryparameter = {
      "q": city,
      "appid": "e895bdd3ad3cd34431f90118626bb7e3"
    };
    Uri uri = new Uri.https(
        "api.openweathermap.org", "/data/2.5/weather", queryparameter);
    final jsonData = await get(uri);
    final json = jsonDecode(jsonData.body);
    print(json);
    setState(() {
      currentCity = json["name"];
      temperature = json["main"]["temp"];
      description = json["weather"][0]["description"];
      humidity = json["main"]["humidity"];
      feelslike = json["main"]["feels_like"];
      img = json["weather"][0]["icon"];
    //  sunrise = json["sys"]["sunrise"];
      //sunrise['sunrise'] = getClockInUtcPlus3Hours(sunrise['sunrise'] as int);
      //isOk = json["cod"];
    });
  }

  // String getClockInUtcPlus3Hours(int timeSinceEpochInSec) {
  //   final time = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSec * 1000,
  //       isUtc: true)
  //       .add(const Duration(hours: 3));
  //   return '${time.hour}:${time.second}';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.pink.shade100,
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          centerTitle: true,
          title: Text("Weather App",),
        ),

        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://images.unsplash.com/photo-1591804227855-d6fe0b648d0e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTl8fHdlYXRoZXIlMjBhcHB8ZW58MHx8MHx8&auto=format&fit=crop&w=1000&q=60"),
              fit: BoxFit.cover,
            ),

           // new NetworkImage("https://www.istockphoto.com/photo/close-up-of-a-green-tree-frog-on-a-white-background-gm144219155-3529201")
          ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Text(showcityName == null?"":showcityName.toString()),
                      new Image.network(
                          'https://openweathermap.org/img/wn/${img}@2x.png'),
                      Text("Currently in " +
                          (currentCity == null ? "Loading" : currentCity
                              .toString()),
                          style: TextStyle(fontSize: 30,)),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: cityController,
                          textAlign: TextAlign.center,
                          decoration: new InputDecoration(
                            hintText: "Enter City Name",
                            labelStyle: TextStyle(color: Colors.black12),
                          ),
                        ),
                      ),

                      Container(
                        height: 5,
                      ),
                          ElevatedButton(
                              onPressed: getLocation, child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Device Location", style: TextStyle(fontSize: 20),),
                              Icon(Icons.location_pin,
                                size: 24.0,),
                            ],
                          )
                          ),
                      Container(
                        height: 5,
                      ),

                      ElevatedButton(
                        onPressed: getWeather, child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Search",
                            style: TextStyle(fontSize: 20),
                            //buttonColor: Colors.pink.shade900,
                          ),
                          Icon(Icons.search_rounded,
                            size: 24.0,),

                        ],
                      )
                      ),

                      Container(
                      height: 10,
                      ),
                      new Row(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Temperature",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            //buttonColor: Colors.pink.shade900,
                          Text((temperature == null ? "Loading" : (temperature - 273)
                         .toStringAsFixed(2)) + "\u00B0C" , style: TextStyle(fontSize: 20, )),
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      new Row(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Feels Like",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            //buttonColor: Colors.pink.shade900,
                          ),
                          Text((feelslike == null ? "Loading" : (feelslike - 273)
                              .toStringAsFixed(2)) + "\u00B0C", style: TextStyle(fontSize: 20, ),),
                        ],
                      ),

                      Container(
                      height: 10,
                      ),

                      new Row(
                        //mainAxisSize: MainAxisSize.min,
                        //mainAxisAlignment : MainAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Humidity",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            //buttonColor: Colors.pink.shade900,
                          ),
                          Text((humidity == null ? "   Loading" : humidity
                                    .toString()),
                                style: TextStyle(fontSize: 20,)),
                        ],
                      ),

                      Container(
                      height: 10,
                      ),
                      new Row(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Description",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            //buttonColor: Colors.pink.shade900,
                          ),
                          Text(
                              (description == null ? "Loading" : description.toString()),
                              style: TextStyle(fontSize: 20),),
                        ],
                      ),
                      Container(
                        height: 10,
                      ),
                      new Row(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("  Sunrise",
                            style: TextStyle(fontSize: 20),
                            //buttonColor: Colors.pink.shade900,
                          ),
                          Text((sunrise == null ? "Loading" : (sunrise)
                              .toStringAsFixed(2)) + "\u00B0", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      // ElevatedButton(
                      //   onPressed: getWeather, child: Text("Search",
                      //   //style: TextStyle(fontSize: 20),))
                      //   //buttonColor: Colors.pink.shade900,
                      // ),
                      // ),
                      // isOk == 200 ? Text("City Name : $currentCity",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),) : Text("Check the city name"),
                    ]
                ),
              ),
            )
        )
    );
  }
}
