import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mangalyan_web/html_asset_page.dart';
import 'package:mangalyan_web/screens/admin.dart';
import 'package:mangalyan_web/screens/login.dart';
import 'package:mangalyan_web/services/stats_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html';

import 'constants.dart';

bool isSignedIn = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (window.location.hostname == 'localhost') {
    debugPrint("running local");
    FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
    FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.


  @override
  initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      isSignedIn = event !=null;
      if(event == null){
        debugPrint("Logged out");
      }else {
        debugPrint("Logged-In");
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sewa SELF',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MyHomePage(title: 'Sewa SELF'),
        '/privacy': (context) =>
            const HtmlAssetPage('Privacy Policy', 'assets/privacy.html'),
        '/login': (context) => const LoginPage(),
        '/about': (context) => const HtmlAssetPage('About Us', 'assets/about.html'),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ShadowsIntoLight'
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final StatsService _service = StatsService();
  bool initialized = false;
  late Map<String,dynamic> statsData;

  @override
  initState(){
    super.initState();
    //_getData();
  }

  _getData() async {
    statsData = await _service.getStats();
    MapEntry<String,dynamic> entry;
    for(entry in statsData.entries){
      debugPrint("${entry.key}: ${entry.value}");
    }
    setState(() {
      initialized = true;
    });
  }

  Widget _appList(){
    return ListView.builder(
        itemCount: Constants.apps.length,
        itemBuilder: (context, index) {
          return _buildCards(context, Constants.apps[index]);
        }
    );
  }

  _logout(){
    FirebaseAuth.instance.signOut();
    setState(() {
      isSignedIn = false;
    });
  }

  Widget _buildCards(BuildContext context, AppDetails appDetails) {
    return Card(
      child: SizedBox(
        width: 400,
        child: Column(
          children: [
            ListTile(
              title: Text(
                appDetails.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'ShadowsIntoLight'),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text(appDetails.descr),
              ),
              leading: CircleAvatar(
                backgroundColor: appDetails.color,
                child: appDetails.icon,
                radius: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  appDetails.appstore_url != ""? InkWell(
                    child: SvgPicture.asset(
                      'assets/images/app_store_w.svg',
                      height: 40,
                    ),
                    onTap: () => launch(
                        appDetails.appstore_url),
                  ): const Text(""),
                  const SizedBox(
                    width: 10,
                  ),
                  appDetails.playstore_url != "" ? InkWell(
                    child: Image.asset(
                      'assets/images/play_store.png',
                      height: 40,
                    ),
                    onTap: () => launch(
                        appDetails.playstore_url),
                  ): const Text(""),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _getAppsWidgets() {
    List<Widget> t = [];
    t.add(const SizedBox(height: 16));
    t.add(InkWell(
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Sewa International",
            style: TextStyle(color: Colors.blue, fontSize: 24)),
      ),
      onTap: () => launch("https://sewausa.org")
    ));
    t.add(const SizedBox(height: 16));
    t.add(Center(child:_buildCards(context, Constants.apps[0])));
    t.add(const SizedBox(height: 32));
    t.add(
    const SizedBox(
      width: 500,
      child: Text(
      'We all know the importance of health through the saying “Health is Wealth”. '
          'As per Shri Suktam, '
          'wealth is the digestive fire, it is the regulated breadth, '
          'it is good eyesight, it is the calmness, it is the strength '
          'in our sense organs, it is the mind and intellect and '
          'it is this wealth that brings lasting peace and happiness to us.',
      ),
    ));
    t.add(const SizedBox(height: 16));
    t.add(const Text("धनमग्निर्धनं वायुर्धनं सूर्यो धनं वसुः ।"));
    t.add(const Text("धनमिन्द्रो बृहस्पतिर्वरुणं धनमश्नुते ॥२०॥"));
    t.add(const SizedBox(height: 16));
    // t.add(DataTable(
    //   headingRowHeight: 0,
    //   columns: const [
    //     DataColumn(label: Text("")),
    //     DataColumn(label: Text(""))
    //   ],
    //   rows: initialized ?
    //   statsData.entries.map(
    //         (entry) => DataRow(
    //       cells: [
    //         DataCell(Text("${entry.key}")),
    //         DataCell(Text("${entry.value}")),
    //       ],
    //     ),
    //   ).toList(): [],
    // ));
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: isSignedIn? Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Sewa Health Portal', style: TextStyle(color: Colors.white),),
            ),
            ListTile(
              title: const Text('Volunteer Hours'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Admin'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminWidget()));
              },
            ),
          ],
        ),
      ) : const SizedBox.shrink(),
      appBar: AppBar(
        leading: isSignedIn? null: const Icon(Icons.spa),
        title: Text(widget.title),
        actions: [
          isSignedIn ? TextButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
             _logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ):
          TextButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pushNamed(context, '/privacy');
            },
            child: const Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/about');
              },
              child: const Text(
                'About Us',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _getAppsWidgets(),
          ),
        ),
      ),
    );
  }
}
