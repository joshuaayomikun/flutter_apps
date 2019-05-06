import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wakanow_test/screens/flight_list.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

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
  int _adults = 1;

  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController travelClassContoller = TextEditingController();
  TextEditingController passengersClassContoller = TextEditingController();
  
String fmDate(DateTime date){
return DateFormat('yyyy-MM-dd').format(date);
}

  var _date = DateFormat.yMMMd().format(DateTime.now());
  String _travelClass = "Economy";
  String _origin ="";
  String _destination ="";
  String _bearer = "";
  DateTime _departureDate =DateTime(2019,08,01);

  @override
  Widget build(BuildContext context){
    void _selectDate() async{
   final DateTime  selectedDate = await showDatePicker(
  context: context,
  initialDate: this._departureDate,
  firstDate: DateTime(2019),
  lastDate: DateTime(2030),
  builder: (BuildContext context, Widget child) {
    return Theme(
      data: ThemeData.dark(),
      child: child,
    );
  },
);
if (selectedDate != null && selectedDate != this._departureDate)
      setState(() {
        this._departureDate = selectedDate;
      });
    }
    Future _showIntDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 0,
          maxValue: 100,
          step: 1,
          initialIntegerValue: this._adults,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => this._adults = value);
      }
    });
  }
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
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    
                    child: ListTile(
                      leading: Icon(
                        Icons.location_city
                      ),
                      subtitle: DropdownButton(
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
                      title: Text('Origin'),
                    )
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  
                  Expanded(
                    child: ListTile(
                      leading: Icon(
                        Icons.location_city
                      ),
                      subtitle: DropdownButton(
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
                      title: Text('Destination'),
                    )
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: 
                    ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: (){
                        _selectDate();
                      },
                    ),
                    title: const Text('Departure date'),
                    subtitle:  Text(fmDate(this._departureDate)),
                  ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child:  ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.contacts),
                        onPressed:() {
                          _showIntDialog();
                        },
                      ),
                    title: Text(this._adults.toString() + " Adults"),
              ),),
              Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.people
                    ),
                    title: Text("Travel Class"),
                  subtitle: DropdownButton (
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
              )),
              Padding(
                  padding: EdgeInsets.only(top: 15.0),
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
                              getCredential();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
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
void getCredential() async{
   await getCredentials();
}
Future<Null> getCredentials() async{
      FirstAPIBody firstAPIBody = FirstAPIBody("client_credentials", "9EUyDJvzfPDs57kucVPODMtsYALPtmMN", "noPX4LEv2j2c5pPd");
      
      var response = await http.post("https://test.api.amadeus.com/v1/security/oauth2/token", headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json"
      }, body: firstAPIBody.toMap());
    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      setState(() {
       this._bearer =  result['token_type'] + " " + result['access_token'];
                              navigateToFlightListPage(SearchDetails(updateCityAsCityCode(this._origin), updateCityAsCityCode(this._destination), fmDate(this._departureDate), this._adults.toString(), this._travelClass), this._bearer );
                              debugPrint("Save button clicked"); 
      });
    }
    else{
    }
  }

  void navigateToFlightListPage(SearchDetails note, var bearer) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return FlightList(note, bearer);
    }));

    if(result){
      debugPrint("success");
    }
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
