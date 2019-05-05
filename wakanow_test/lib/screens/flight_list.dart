import 'dart:async';
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
  @override
  Widget build(BuildContext context){ 
    
  getFlightList();
    return (
      WillPopScope(
      onWillPop:(){
        moveToLastscreen();
      },
      child: Scaffold(
       appBar:AppBar(
      title:  Text('Notes')
      ),
      body: getFlightListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint('FAB clicked');
        },
        tooltip:'Add Note',
        child: Icon(Icons.add),
      ),
      )
      )
    );
  }
  ListView getFlightListView(){
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: this.apiResult['length'],
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
              this.apiResult[position].title, 
              style:titleStyle,
            ),
            subtitle: Text(this.apiResult[position].date),
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
  void moveToLastscreen() {
      Navigator.pop(context, true);
    }
  Future<dynamic> getFlightList() async{
      var e = this.searchDetails.queryStringWithValue();
      var response = await http.get('https://test.api.amadeus.com/v1/shopping/flight-offers?$e', headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer bvhFrGPpGGv7Ep6SC7yV4UFj6gtD"
      });
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      setState(() {
        this.apiResult = result;
      });
    return result;
    }
    else{
      return null;
    }
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
 set departure(String newDeparture){
   this._departureDate = newDeparture;
 }
 set adult(String newAdult){
   this._adult = newAdult;
 }
 set travelClass(String newTravelClass){
   this._travelClass = newTravelClass;
 }
 String queryStringWithValue(){
   var result = 'origin=$_origin&destination=$destination&departureDate=2019-08-01&adults=$_adult&travelClass=$travelClass&nonStop=true&currency=ngn&max=50';
   return result;
 }
}

