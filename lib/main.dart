import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(30.048238553006417, 31.233273432438043),
    zoom: 11.5,
    tilt: 50,
  );
  GoogleMapController? _googleMapController;

  Marker ?_origin  ;
  Marker ?_destination ;

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Maps',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        actions: [
          FlatButton(
            textColor: Colors.purple,
            onPressed: () {
              if (_origin != null) {
                _googleMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                  target: _origin!.position,
                  zoom: 14,
                  tilt: 50,
                )));
              }
            },
            child: const Text('Origin'),
          ),
          FlatButton(
            textColor: Colors.purple,
            onPressed: () {
              if (_destination != null) {
                _googleMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                  target: _destination!.position,
                  zoom: 14,
                  tilt: 50,
                )));
              }
            },
            child: const Text('Destination'),
          ),
        ],
      ),
      body: GoogleMap(
        zoomControlsEnabled: false ,
        initialCameraPosition: _initialCameraPosition,
        mapType: MapType.hybrid,
        onLongPress: (position) async {
          if ((_origin == null) ||
              (_origin != null && _destination != null)) {
            setState(() {
              _origin = Marker(
                markerId: const MarkerId('origin'),
                infoWindow: const InfoWindow(title: 'Origin position'),
                position: position,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              );
              _destination = null ;
            });
          } else {
            setState(() {
              _destination = Marker(
                markerId: const MarkerId('destination'),
                infoWindow: const InfoWindow(title: 'Destination position'),
                position: position,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              );
            });
          }
        },
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _googleMapController = controller;
          });
        },
        markers:{
          _origin ?? const Marker(markerId: MarkerId('1')) ,
          _destination ?? const Marker(markerId: MarkerId('1')) ,
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
