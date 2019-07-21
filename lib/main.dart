import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save Data Locally Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Save Data Locally Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { 
  //Email address
  String _email;
  //Whether or not the app can send out notifications
  bool _notifications = true;
  //Whether or not pin codes can be used to authenticate
  bool _allowPinCodes = false;
  //Whether or not the presence of white-listed phones can be used to authenticate
  bool _allowPhonePresenceDetection = false;
  //Preferred temperature unit - fahrenheit or celsius?
  String _temperatureUnit = 'fahrenheit';

  TextEditingController emailTextEditingController;

  @override
  void initState() {
    super.initState();
    restore();
    emailTextEditingController = new TextEditingController(text: _email);
    emailTextEditingController.addListener(_emailChanged);
  }

  //Email changes need to be handled separately since we are using a TextEditingController
  _emailChanged() {
    save('email', emailTextEditingController.text);
  }

  restore() async {
    print('restoring...');
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.getKeys().forEach((k) {
      print('restored ${k} with value of ${sharedPrefs.get(k)}');
    });
    setState(() {
      _email = (sharedPrefs.getString('email') ?? '');
      emailTextEditingController.text = _email;
      _notifications = (sharedPrefs.getBool('notifications') ?? false);
      _allowPinCodes = (sharedPrefs.getBool('allowPinCodes') ?? false);
      _allowPhonePresenceDetection =
          (sharedPrefs.getBool('allowPhonePresenceDetection') ?? false);
      _temperatureUnit =
          (sharedPrefs.getString('temperatureUnit') ?? 'fahrenheit');
    });
  }

  save(String key, dynamic value) async {
    print('saving ${key} with value of ${value}');
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: new Column(children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
              Expanded(
                flex: 2,
                child: new TextFormField(
                  controller: emailTextEditingController,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.email),
                    hintText: 'Enter a email address',
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0)),
            ],
          ),
          new SwitchListTile(
            title: const Text('Notifications'),
            value: _notifications,
            onChanged: (bool value) {
              setState(() {
                _notifications = value;                
              });
              save('notifications', value);
            },
            secondary: const Icon(Icons.notifications),
          ),
          new SwitchListTile(
            title: const Text('Allow Pin Codes'),
            value: _allowPinCodes,
            onChanged: (bool value) {
              setState(() {
                _allowPinCodes = value;                
              });
              save('allowPinCodes', value);
            },
            secondary: const Icon(Icons.security),
          ),
          new SwitchListTile(
            title: const Text('Allow Phone Presence Detection'),
            value: _allowPhonePresenceDetection,
            onChanged: (bool value) {
              setState(() {
                _allowPhonePresenceDetection = value;                
              });
              save('allowPhonePresenceDetection', value);
            },
            secondary: const Icon(Icons.phone_iphone),
          ),
          new Divider(),
          new Row(
            children: <Widget>[
              new Expanded(
                flex: 1,
                child: const Icon(Icons.wb_sunny),
              ),
              Expanded(
                  flex: 11,
                  child: const Text('Preferred Temperature Unit',
                      textScaleFactor: 1.3)),
            ],
          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
              Expanded(
                flex: 2,
                child: new RadioListTile<String>(
                  title: const Text('Fahrenheit'),
                  value: 'fahrenheit',
                  groupValue: _temperatureUnit,
                  onChanged: (String value) {
                    setState(() {
                      _temperatureUnit = value;                      
                    });
                    save('temperatureUnit', value);
                  },
                ),
              ),
              new Expanded(
                flex: 2,
                child: new RadioListTile<String>(
                  title: const Text('Celsius'),
                  value: 'celsius',
                  groupValue: _temperatureUnit,
                  onChanged: (String value) {
                    setState(() {
                      _temperatureUnit = value;                      
                    });
                    save('temperatureUnit', value);
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0)),
            ],
          ),
        ]));
  }
}
