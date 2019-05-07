import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wakanow_test/screens/search_flight.dart';
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
      List<FlightInfo> flightList = List<FlightInfo>();
  FlightListState(this.searchDetails, this.bearer);
  int count = 0;
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
      this.count = this.apiResult['data'].length;
      for(int i = 0; i < count; i++){
        this.flightList.add(FlightInfo.fromMapObject(this.apiResult['data'][i], this.apiResult['dictionaries']["carriers"]));
      }
      });
    } else {
      debugPrint(response.toString());
      Scaffold.of(context).showSnackBar(
        SnackBar(
        content: Text('An error occured')
        )
      );
    }
    }
    void getFlightList() async{
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content:Row(
                        children: <Widget>[
                          new CircularProgressIndicator(),
                          new Text("  Wait...")
                        ],
                      )
        )
      );
     
      await this.getFlightLists();
    }
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
      title:  Text('Fight Search results')
      ),
      body:getFlightListView(),
          
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint('FAB clicked');
          navigateToFlight();
        },
        child: Icon(Icons.search),
      ),
      )
      )
    );
  }
  ListView getFlightListView(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color:Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.flight_takeoff, 
                color:Colors.grey,)
            ),
            title:Text(
              this.flightList[position].carrierName,
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child:  Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:Text(
                      'Departure Code: ' + this.flightList[position].departureCode
                      )
                    ),
                    Expanded(
                      child:Text(
                      'Arrival Code: ' + this.flightList[position].arrivalCode
                      )
                    )
                  ]
                ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child:Text(
                      'Arrival Time: ' + this.flightList[position].departureCode
                      )
                    ),
                    Expanded(
                      child:Text(
                      'Departure Time: ' + this.flightList[position].arrivalCode
                      )
                    )
                  ]
                )
              ],
            ),
            ),
            trailing: Text(
              'NGN ' + this.flightList[position].price
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
  void navigateToFlight() async{
   bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return SearchFlight();
    }));
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

class FlightInfo{
  String _carrierName; 
  String _carrierCode; 
  String _departureCode;
  String _arrivalCode;
  String _departureTime;
  String _arrivalTime;
  String _price;

  FlightInfo(this._carrierName,this._carrierCode, this._departureCode, this._arrivalCode, this._departureTime, this._arrivalTime, this._price);

 String get carrierName => _carrierName;
 String get carrierCode => _carrierCode;
 String get departureCode => _departureCode;
 String get arrivalCode => _arrivalCode;
 String get departureTime => _departureTime;
 String get arrivalTime => _arrivalTime;
 String get price => _price;

 
  FlightInfo.fromMapObject(Map<String, dynamic> map, map2){
    this._carrierCode = map['offerItems'][0]['services'][0]["segments"][0]["flightSegment"]["carrierCode"];
    this._carrierName = map2[this._carrierCode];
    this._departureCode = map['offerItems'][0]['services'][0]["segments"][0]["flightSegment"]["departure"]["iataCode"];
    this._arrivalCode = map['offerItems'][0]['services'][0]["segments"][0]["flightSegment"]["arrival"]["iataCode"];
    this._departureTime = map['offerItems'][0]['services'][0]["segments"][0]["flightSegment"]["departure"]["at"];
    this._arrivalTime =  map['offerItems'][0]['services'][0]["segments"][0]["flightSegment"]["arrival"]["at"];
    this._price = map['offerItems'][0]["price"]["total"];
  }
  
}

