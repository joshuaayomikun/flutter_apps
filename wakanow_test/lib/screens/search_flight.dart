import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wakanow_test/screens/flight_list.dart';

class SearchFlight extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchFlightState();
  }
}
class SearchFlightState extends State<SearchFlight>{

  static var _cities = ['New york city','Madagascar'];
  static var _class = ['Economy'];

  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController departureDateController = TextEditingController();
  TextEditingController adultContoller = TextEditingController();
  TextEditingController travelClassContoller = TextEditingController();
  TextEditingController passengersClassContoller = TextEditingController();
  
  DateTime _date = new DateTime.now();
  String _travelClass = "Economy";
  String _origin ="";
  String _destination ="";
  Future<Null> selecteDate(BuildContext context) async{
   final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2020),
      
    );
    if(picked != null && picked != _date){
      setState(() {
       _date = picked;
       departureDateController.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context){
    TextStyle textStyle = Theme.of(context).textTheme.title;
  this._origin = this.getCityAsString('MAD');
  this._destination = this.getCityAsString('NYC');

    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Flights'),
          leading: Icon(
            Icons.airplanemode_active
          )
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: Container(
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: DropdownButton(
                        items: _cities.map((String dropDownStringItem){
                          return DropdownMenuItem(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
  
                        style: textStyle,

                        value: this._origin,
                        onChanged: (valueSelectedByUser){
                          setState(() {
                            this._origin = valueSelectedByUser;
                            debugPrint('User selected $valueSelectedByUser'); 
                          });
                        },
                      ),
                    )
                  ),
                  Container(width: 5.0),
                  Expanded(
                    child: ListTile(
                      title: DropdownButton(
                        items: _cities.map((String dropDownStringItem){
                          return DropdownMenuItem(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
  
                        style: textStyle,
  
                        value: this._destination,
                        onChanged: (valueSelectedByUser){
                          setState(() {
                            this._destination = valueSelectedByUser;
                            debugPrint('User selected $valueSelectedByUser'); 
                          });
                        },
                      ),
                    )
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: GestureDetector(
                    onTap: (){
                      selecteDate(context);
                    },
                    child: TextFormField(
                    style: textStyle,
                    controller: departureDateController,
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Please chose date';
                      }
                    },
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Departure Date',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 15.0
                      ),
                      hintText: 'Pick a date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                    ),
                  ),
                )
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false
                        ),
                        style:textStyle,
                        controller: adultContoller,
                        validator: (String value){
                          if(value.isEmpty){
                            return 'Please enter number of adults';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Adult',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0
                          ),
                          hintText: 'Enter number of adults',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                          )
                        ),
                      ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: DropdownButton (
                        items: _class.map((String dropDownStringItem){
                          return DropdownMenuItem(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
  
                        style: textStyle,

                        value: this._travelClass,
                        onChanged: (valueSelectedByUser){
                          setState(() {
                            this._travelClass = valueSelectedByUser;
                            debugPrint('User selected $valueSelectedByUser'); 
                          });
                        },
                      ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Search',
                            textScaleFactor:1.5,
                          ),
                          onPressed: (){
                            setState(() {
                              var bearer = this.getCredentials();
                              navigateToFlightListPage(SearchDetails(originController.text, destinationController.text, departureDateController.text, adultContoller.text, travelClassContoller.text), bearer );
                              debugPrint("Save button clicked"); 
                            });
                          },
                        ),
                      ),
                      Container(width: 5.0),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Cancel',
                            textScaleFactor:1.5,
                          ),
                          onPressed: (){
                            setState(() {
                            debugPrint("Cancel button clicked");
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
            ],
          ),
        )
      )
    );
  }
                                                             
  String getCityAsString(String cityCode) {
    String cityName;
    switch (cityCode) {
      case 'MAD':
        cityName = _cities[1];
        break;
      case 'NYC':
        cityName = _cities[0];
      break;
    }

    return cityName;
  }
                                          
  String updateCityAsCityCode(cityName) {

    String cityCode;
    switch (cityName) {
      case 'Madagascar':
        cityCode = 'MAD' ;
        break;
      case 'New york city':
        cityCode = 'NYC';
      break;
    }

    return cityCode;
  }

  Future<dynamic> getCredentials() async{
      FirstAPIBody firstAPIBody = FirstAPIBody("client_credentials", "9EUyDJvzfPDs57kucVPODMtsYALPtmMN", "client_secret");
      
      var response = await http.post("https://test.api.amadeus.com/v1/security/oauth2/token", headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json"
      }, body: firstAPIBody.toMap());
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
    return result['token_type'] + result['access_token'];
    }
    else{
      return null;
    }
  }

  void navigateToFlightListPage(SearchDetails note, var bearer) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return FlightList(note, bearer);
    }));
  }
}
  
  


class FirstAPIBody {
  String _grantType;
  String _clientId;
  String _clientSecret;

  FirstAPIBody(this._grantType, this._clientId, this._clientSecret);

  String get grantType => _grantType;
  String get clientId => _clientId;
  String get clientSecret => _clientSecret;

  set grantType(String newGrantType){
      this._grantType = grantType;
  }

  set clientId(String newClientId){
      this._clientId = clientId;
  }

  set clientSecret(String newClientSecret){
      this._clientSecret = clientSecret;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['grant_type'] = _grantType;
    map['client_id'] = _clientId;
    map['client_secret'] = _clientSecret;

    return map;
  }

  FirstAPIBody.fromMapObject(Map<String, dynamic> map){
    this._grantType = map['grant_type'];
    this._clientId = map['client_id'];
    this._clientSecret = map['client_secret'];
  }

}
