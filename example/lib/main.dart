import 'package:flutter/material.dart';
import 'package:flutter_zalo/flutter_zalo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterZalo flutterZalo = FlutterZalo();

  void init() async {
    await flutterZalo.init();
  }

  void logIn() async {
    await flutterZalo.logIn();
  }

  void isAccessTokenValid() async {
    bool? isValid = await flutterZalo.isAccessTokenValid();
    print('isAccessTokenValid: $isValid');
  }

  void getAccessToken() async {
    String? accessToken = await flutterZalo.getAccessToken();
    print('getAccessToken: $accessToken');
  }

  void isRefreshAccessTokenValid() async {
    bool? isValid = await flutterZalo.isRefreshAccessTokenValid();
    print('isRefreshAccessTokenValid: $isValid');
  }

  void refreshAccessToken() async {
    bool? isRefreshed = await flutterZalo.refreshAccessToken();
    print('refreshAccessToken: $isRefreshed');
  }

  void getProfile() async {
    Map<String, dynamic>? profile = await flutterZalo.getProfile();
    print('getProfile: $profile');
  }

  void logOut() async {
    bool? isLoggedOut = await flutterZalo.logOut();
    print('logOut: $isLoggedOut');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const VerticalDivider(),
            TextButton(
              onPressed: init,
              child: const Text(
                "init",
                style: TextStyle(color: Colors.red),
              ),
              // color: Theme.of(context).accentColor,
            ),
            const VerticalDivider(),
            TextButton(
              onPressed: logIn,
              child: const Text(
                "logIn",
                style: TextStyle(color: Colors.red),
              ),
              // color: Theme.of(context).accentColor,
            ),
            const VerticalDivider(),
            TextButton(
              onPressed: isAccessTokenValid,
              child: const Text(
                "isAccessTokenValid",
                style: TextStyle(color: Colors.red),
              ),
              // color: Theme.of(context).accentColor,
            ),
            const VerticalDivider(),
            TextButton(
              onPressed: getAccessToken,
              child: const Text(
                "getAccessToken",
                style: TextStyle(color: Colors.red),
              ),
              // color: Theme.of(context).accentColor,
            ),
            const VerticalDivider(),
            TextButton(
              onPressed: isRefreshAccessTokenValid,
              child: const Text(
                "isRefreshAccessTokenValid",
                style: TextStyle(color: Colors.red),
              ),
              // color: Theme.of(context).accentColor,
            ),
            const VerticalDivider(),
            TextButton(
              onPressed: refreshAccessToken,
              child: const Text(
                "refreshAccessToken",
                style: TextStyle(color: Colors.red),
              ),
              // color: Theme.of(context).accentColor,
            ),
            const VerticalDivider(),
            TextButton(
              onPressed: getProfile,
              child: const Text(
                "getProfile",
                style: TextStyle(color: Colors.red),
              ),
              // color: Theme.of(context).accentColor,
            ),
            const VerticalDivider(),
            TextButton(
              onPressed: logOut,
              child: const Text(
                "logOut",
                style: TextStyle(color: Colors.red),
              ),
              // color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
