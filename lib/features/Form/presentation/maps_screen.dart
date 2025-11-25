import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';



class MapScreenChooseLocation extends StatefulWidget {

  final LatLong center; // نقطة المنتصف

  final void Function(PickedData pickedData) onPicked;  // لارجاع الاحداثيات المخنارة (خط الطول و خط العرض)

  final Future<LatLng> Function() onGetCurrentLocationPressed;   // مسان تحديد الموقع التلقائي


  final String limitLocation; //مشان تحصروا نتائج البحث بمحافظة او بلد معين

  final Color buttonColor;
  final Color buttonTextColor;
  final Color locationPinIconColor;
  final String buttonText;
  final String hintText;


  static Future<LatLng> nopFunction() {
    throw Exception("");
  }

  const MapScreenChooseLocation({
    super.key,
    required this.center,
    required this.onPicked,
    this.onGetCurrentLocationPressed = nopFunction,
    this.buttonColor = Colors.blue,
    this.locationPinIconColor = Colors.blue,
    this.buttonTextColor = Colors.white,
    this.buttonText = 'Set Current Location',
    this.hintText = 'Search Location', required this.limitLocation,
  });

  @override
  State<MapScreenChooseLocation> createState() =>
      _MapScreenChooseLocationState();
}

class _MapScreenChooseLocationState extends State<MapScreenChooseLocation> {

  MapController _mapController = MapController();

  final TextEditingController _searchController = TextEditingController(); // لتخزنوا فيه العنوان كإسم و وصف يعني

  final FocusNode _focusNode = FocusNode();
  List<OSMdata> _options = <OSMdata>[];
  Timer? _debounce;
  var client = http.Client();


  // لا تلعبوا فيهم
  @override
  void initState() {
    _mapController = MapController();

    _mapController.mapEventStream.listen((event) async {
      if (event is MapEventMoveEnd) {
        MediaQueryData mediaQueryData = MediaQueryData.fromWindow(window);
        String deviceModel = mediaQueryData.size.toString();

        final headers = {
          'User-Agent': "${deviceModel}3",
        };
        debugPrint("${event.center.latitude} , ${event.center.longitude}");

        var client = http.Client();
        // لا تلعبوا فيهم
        String url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=${event.center.latitude}&lon=${event.center.longitude}&zoom=18&addressdetails=1';

        var response = await client.get(Uri.parse(url,),headers: headers);
        debugPrint("response${response.body}");
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes))
        as Map<dynamic, dynamic>;

        _searchController.text = decodedResponse['display_name'];
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String? _autocompleteSelection;
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: widget.buttonColor),
    );
    OutlineInputBorder inputFocusBorder = OutlineInputBorder(
      borderSide: BorderSide(color: widget.buttonColor, width: 3.0),
    );
    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            options: MapOptions(
                center: LatLng(widget.center.latitude, widget.center.longitude),
                zoom: 15.0,
                maxZoom: 18,
                minZoom: 6,
                maxBounds:LatLngBounds(LatLng(27.1401861, 31.5494106),LatLng(42.1401861, 	46.5494106))),
            mapController: _mapController,
            children: [
              // لا تلعبوا فيهم
              TileLayer(
                urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
            ],
          ),),
        Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Icon(
                  Icons.location_pin,
                  size: 50,
                  color: widget.locationPinIconColor,
                ),
              ),
            )),
        Positioned(
            bottom: 60,
            right: 5,
            child: FloatingActionButton(
              heroTag: 'btn3',
              backgroundColor: widget.buttonColor,
              onPressed: () async {
                try {
                  // LatLng position =
                  // await widget.onGetCurrentLocationPressed.call();
                  // _mapController.move(
                  //     LatLng(position.latitude, position.longitude),
                  //     _mapController.zoom);
                  Position? pos = await _determinePosition();
                  _mapController.move(
                      LatLng(pos!.latitude, pos!.longitude),
                      _mapController.zoom);

                } catch (e) {
                  debugPrint(e.toString());
                  // _mapController.move(
                  //     LatLng(widget.center.latitude, widget.center.longitude),
                  //     _mapController.zoom);
                } finally {
                  setNameCurrentPos();
                }
              },
              child: Icon(
                Icons.my_location,
                color: widget.buttonTextColor,
              ),
            )),
        Positioned(
          top: MediaQuery.of(context).size.height*0.1,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.height*0.015),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: (){
                          _searchController.clear();
                        }, icon: Icon(Icons.clear,color: Colors.blueGrey,size: MediaQuery.of(context).size.height*0.03,)),

                        hintText: widget.hintText,
                        border: inputBorder,
                        focusedBorder: inputFocusBorder,

                        fillColor: Colors.white,
                        filled: true
                    ),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize:
                        MediaQuery.of(context).size.height * 0.018,
                        fontWeight: FontWeight.bold),
                    onChanged: (String value) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();

                      _debounce =
                          Timer(const Duration(milliseconds: 2000), () async {
                            if (kDebugMode) {
                              debugPrint(value);
                            }
                            var client = http.Client();
                            try {
                              MediaQueryData mediaQueryData = MediaQueryData.fromWindow(window);
                              String deviceModel = mediaQueryData.size.toString();

                              final headers = {
                                'User-Agent': "${deviceModel}6",
                              };


                              // لا تلعبوا فيه
                              String url =
                                  'https://nominatim.openstreetmap.org/search?q=$value&format=json&polygon_geojson=1&addressdetails=1';
                              if (kDebugMode) {
                                debugPrint(url);
                              }
                              var response = await client.get(Uri.parse(url),headers: headers);
                              debugPrint(response.body);
                              var decodedResponse =
                              jsonDecode(utf8.decode(response.bodyBytes))
                              as List<dynamic>;
                              if (kDebugMode) {
                                debugPrint(decodedResponse.toString());
                              }

                              List<OSMdata> tempOptions = <OSMdata>[];

                              tempOptions = decodedResponse
                                  .map((e) => OSMdata(
                                  displayName: e['display_name'],
                                  lat: double.parse(e['lat']),
                                  lon: double.parse(e['lon'])))
                                  .toList();



                              _options= tempOptions.where((element) => element.displayName.contains(widget.limitLocation)).toList();
                              setState(() {});
                            } finally {
                              client.close();
                            }

                            setState(() {});
                          });
                    }),
                StatefulBuilder(builder: ((context, setState) {
                  return Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.007),
                    decoration: const BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))),
                    child: ListView.separated(
                        separatorBuilder: (context,index)=>(const Divider(color: Colors.grey)),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _options.length > 5 ? 5 : _options.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_options[index].displayName,
                                style:TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                    MediaQuery.of(context).size.height * 0.0145,
                                    fontWeight: FontWeight.bold)),
                            onTap: () {
                              debugPrint("lat:${_options[index].lat}");
                              debugPrint("long:${_options[index].lon}");
                              _mapController.move(
                                LatLng(
                                    _options[index].lat, _options[index].lon),
                                19.0,);


                              _focusNode.unfocus();
                              _options.clear();
                              setState(() {});
                            },
                          );
                        }),
                  );
                })),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Padding(
                padding:  EdgeInsets.all(MediaQuery.of(context).size.height*0.008),
                child: GestureDetector(
                    onTap: () async {
                      pickData().then((value) {
                        widget.onPicked(value);
                        Navigator.of(context).pop();
                      });
                    },
                    child:Container(
                        height: MediaQuery.of(context).size.height*0.055,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: widget.buttonColor,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child:
                          Text(widget.buttonText,
                            style:TextStyle(
                                color: Colors.white,
                                fontSize:
                                MediaQuery.of(context).size.height * 0.024,
                                ),),
                        )
                    )
                )
            ),
          ),
        )
      ],
    );
  }


  // تابع بيجيبلكم اسم الموقع من احداثيات الطول و العرض تبعه
  void setNameCurrentPos() async {
    double latitude = _mapController.center.latitude;
    double longitude = _mapController.center.longitude;
    if (kDebugMode) {
      debugPrint(latitude.toString());
    }
    if (kDebugMode) {
      debugPrint(longitude.toString());
    }
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(window);
    String deviceModel = mediaQueryData.size.toString();

    final headers = {
      'User-Agent': deviceModel,
    };
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';

    var response = await client.get(Uri.parse(url),headers: headers);
    var decodedResponse =
    jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;

    _searchController.text =
        decodedResponse['display_name'] ?? "MOVE TO CURRENT POSITION";
    setState(() {});
  }


  // مشان يحدد الموقع بشكل تلقائس
  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<PickedData> pickData() async {
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(window);
    String deviceModel = mediaQueryData.size.toString();

    final headers = {
      'User-Agent': deviceModel,
    };
    LatLong center = LatLong(
        _mapController.center.latitude, _mapController.center.longitude);
    var client = http.Client();
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${_mapController.center.latitude}&lon=${_mapController.center.longitude}&zoom=18&addressdetails=1';

    var response = await client.get(Uri.parse(url),headers: headers);
    debugPrint(response.body);
    var decodedResponse =
    jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;
    String displayName = decodedResponse['display_name'];
    return PickedData(center, displayName);
  }
}


class OSMdata {
  final String displayName;
  final double lat;
  final double lon;
  OSMdata({required this.displayName, required this.lat, required this.lon});
  @override
  String toString() {
    return '$displayName, $lat, $lon';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is OSMdata && other.displayName == displayName;
  }

  @override
  int get hashCode => Object.hash(displayName, lat, lon);
}

class LatLong {
  final double latitude;
  final double longitude;
  LatLong(this.latitude, this.longitude);
}

class PickedData {
  final LatLong latLong;
  final String address;

  PickedData(this.latLong, this.address);
}



