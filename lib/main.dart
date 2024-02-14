import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: RouteDrawerPage()
        // const MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String? searchedAddress;
//   String? selectedAddress;
//
//   YandexMapController? mapController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text("Location:$selectedAddress"),
//       ),
//       body: Stack(
//         children: [
//           YandexMap(
//             onMapCreated: (controller) {
//               mapController = controller;
//             },
//             onCameraPositionChanged: (cameraPos, reason, _) async {
//               final address = await YandexSearch.searchByPoint(
//                   point: cameraPos.target,
//                   searchOptions: const SearchOptions());
//               selectedAddress = (await address.result).items?.first.name;
//               setState(() {});
//             },
//           ),
//           Positioned(
//               top: 30,
//               right: 15,
//               left: 15,
//               child: Container(
//                 height: 50,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Enter Address",
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.only(left: 15, top: 15),
//                     suffixIcon: IconButton(
//                       onPressed: searchNavigate,
//                       icon: const Icon(Icons.search),
//                       iconSize: 30.0,
//                     ),
//                   ),
//                   onChanged: (v) {
//                     setState(() {
//                       selectedAddress = v;
//                     });
//                   },
//                 ),
//               )),
//           const Positioned.fill(
//             child: Center(
//               child: Icon(
//                 Icons.location_on,
//                 color: Colors.red,
//                 size: 34,
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           FloatingActionButton(
//             onPressed: () async {
//               await Geolocator.requestPermission();
//               final myPositioned = await Geolocator.getCurrentPosition();
//               mapController?.moveCamera(
//                 CameraUpdate.newCameraPosition(
//                   CameraPosition(
//                       azimuth: 1,
//                       tilt: 0,
//                       target: Point(
//                           latitude: myPositioned.latitude,
//                           longitude: myPositioned.longitude),
//                       zoom: 18),
//                 ),
//                 animation: const MapAnimation(duration: 2.5),
//               );
//             },
//             tooltip: 'Increment',
//             child: const Icon(Icons.navigation),
//           ),
//           // FloatingActionButton(
//           //   onPressed: () async {
//           //     const point = Point(
//           //       latitude: 41.2858305,
//           //       longitude: 69.2035464,
//           //     );
//           //     mapController?.moveCamera(
//           //       CameraUpdate.newCameraPosition(
//           //         const CameraPosition(target: point, zoom: 18),
//           //       ),
//           //     );
//           //   },
//           //   tooltip: 'Increment',
//           //   child: const Icon(Icons.location_on),
//           // ),
//         ],
//       ),
//       //AIzaSyC7cr2hQ_WJzj3Auuwn7F-3vUeVlLfzhZo
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//
//   @override
//   void dispose() {
//     mapController?.dispose();
//     super.dispose();
//   }
//
//   searchNavigate() {}
// }

class RouteDrawerPage extends StatefulWidget {
  const RouteDrawerPage({super.key});

  @override
  State<RouteDrawerPage> createState() => _RouteDrawerPageState();
}

class _RouteDrawerPageState extends State<RouteDrawerPage> {
   Point? source;

  Point destination = const Point(latitude: 40.943480, longitude: 71.898703);

  YandexMapController? mapController;

  var route = const PolylineMapObject(
      mapId: MapObjectId("route"), polyline: Polyline(points: []));

  Future<void> getRoute() async {
    final routeRequest = YandexDriving.requestRoutes(
      points: [
        RequestPoint(
            point: source!, requestPointType: RequestPointType.wayPoint),
        RequestPoint(
            point: destination, requestPointType: RequestPointType.wayPoint),
      ],
      drivingOptions: const DrivingOptions(
        initialAzimuth: 0,
        routesCount: 5,
        avoidTolls: true,
      ),
    );
    // print(routeRequest.session);
    final result = await routeRequest.result;
    route = PolylineMapObject(
      mapId: const MapObjectId("route"),
      polyline: Polyline(
        points: result.routes?.first.geometry ?? [],
      ),
    );
    setState(() {});
    // print(await routeRequest.result);
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        mapObjects: [

          PlacemarkMapObject(
            mapId: const MapObjectId("destination"),
            point: destination,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                scale: .05,
                image: BitmapDescriptor.fromAssetImage("lib/icon.jpg"),
              ),
            ),
          ),
          route,
        ],
        onCameraPositionChanged: (cameraPos, reason, finished) {},
        onMapCreated: (controller) async {
          Geolocator.requestPermission();
          final myPositioned =await Geolocator.getCurrentPosition();
           source = Point(
            longitude: myPositioned.longitude,
            latitude: myPositioned.latitude,
          );

          mapController?.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: source!,
                zoom: 18,
              ),
            ),
            animation: const MapAnimation(duration: 2.5),
          );

          await getRoute();
        },
      ),
    );
  }
}
