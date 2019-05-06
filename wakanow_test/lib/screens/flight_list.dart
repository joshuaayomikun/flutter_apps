import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wakanow_test/screens/search_flight.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class FlightList extends StatefulWidget{
  final String bearer;
  final SearchDetails searchDetails;
  FlightList(this.searchDetails, this.bearer);

  @override
  State<StatefulWidget> createState(){
    return FlightListState(this.searchDetails, this.bearer);
  }
}
    
class FlightListState extends State<FlightList>{

  final SearchDetails searchDetails;
  final String bearer;
  var apiResult;
  FlightListState(this.searchDetails, this.bearer);
  Future<Null> getFlightLists() async{
      var e = this.searchDetails.queryStringWithValue();
     var response = await http.get('https://test.api.amadeus.com/v1/shopping/flight-offers?$e', headers: {
        "authorization":this.bearer,
         "content-type":"application/json",
        "accept": "application/json"
      });
      if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      setState(() {
      this.apiResult = result;
      });
    } else {
      throw Exception('Failed to load internet');
    }
    }
    void getFlightList() async{
      await this.getFlightLists();
    }
  @override
  Widget build(BuildContext context){ 
  this.getFlightList();
    return (
      WillPopScope(
      onWillPop:(){
        moveToLastscreen();
      },
      child: Scaffold(
       appBar:AppBar(
      title:  Text('Fight Search results')
      ),
      body:
            getFlightListView(this.apiResult['data']),
          
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint('FAB clicked');
          moveToLastscreen();
        },
        child: Icon(Icons.search),
      ),
      )
      )
    );
  }
  ListView getFlightListView(snapShot){
    if(snapShot['data'] != null){
    return ListView.builder(
      itemCount: snapShot.length,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color:Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.airport_shuttle, 
                color:Colors.grey,)
            ),
            title:Text(
              this.apiResult[position]['type'],
            ),
            subtitle: Text(this.apiResult[position].type),
            trailing: GestureDetector(
              onTap:(){
              },
              child: Icon(
                Icons.delete, 
                color:Colors.grey,
              )
            ),
            onTap:(){
              debugPrint("ListTile Tapped");
            },
          ),
        );
      }
    );
  }
  else{
    return ListView(
      children:<Widget>[
      ListTile(
        leading: Icon(
          Icons.cancel
        ),
        title: Text("No data"),
      )
    ]);
  }
  }
  void moveToLastscreen() {
      Navigator.pop(context, true);
    }

  
}

class SearchDetails {
 String _origin;
 String _destination;
 String _departureDate;
 String _adult;
 String _travelClass;

 SearchDetails(this._origin, this._destination, this._departureDate, this._adult, this._travelClass);
 String get origin => _origin;
 String get destination => _destination;
 String get departure => _departureDate;
 String get adult => _adult;
 String get travelClass => _travelClass;

 set origin(String newOrigin){
   this._origin = newOrigin;
 }
 set destination(String newDestination){
   this._destination = newDestination;
 }
 set departureDate(String newDepartureDate){
   this._departureDate = newDepartureDate;
 }
 set adult(String newAdult){
   this._adult = newAdult;
 }
 set travelClass(String newTravelClass){
   this._travelClass = newTravelClass;
 }
 String queryStringWithValue(){
   
   var result = 'origin=$origin&destination=$destination&departureDate=$_departureDate&adults=$adult&travelClass=$travelClass&nonStop=true&currency=ngn&max=50';
   return result;
 }
}

