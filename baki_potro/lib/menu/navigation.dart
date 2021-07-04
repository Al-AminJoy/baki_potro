import 'package:baki_potro/screen/add_sell.dart';
import 'package:baki_potro/screen/home_screen.dart';
import 'package:baki_potro/screen/profile.dart';
import 'package:baki_potro/utils/common.dart';
import 'package:baki_potro/utils/shared_preference.dart';
import 'package:baki_potro/utils/theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'drawer_navigation.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}
/// Screen State for phone verification

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class _NavigationState extends State<Navigation> {
  ///Set initially current state as enter number screen
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String phone = '';
///initialize firebase auth
  //FirebaseAuth _auth = FirebaseAuth.instance;
///initialized verificationId for store verification code
  String verificationId;
///declared for handle state of progress
  bool showLoading = false;
///this method called after auto code verification and after manually code inserted
 /* void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });
    ///changing screen from sign_up to home
      if (authCredential?.user != null) {
        setState(() {
          num = phone;
          SharedPref.saveToPreferences(SharedPref.NUMBER_KEY, phone);
        });
        // Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      _showSnackBar(Text('ভুল পিন'));
    }
  }
///Phone Number insertion screen UI design
  getMobileFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        new Text('নিবন্ধন করুন',
            style: new TextStyle(
                fontSize: 18.0,
                color: Colors.blue,
                fontWeight: FontWeight.bold)),
        new Container(
          padding: EdgeInsets.all(20.0),
          child: new TextField(
            controller: phoneController,
            decoration: new InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Colors.yellow, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              hintText: 'নম্বর (০১৭১xxxxxxx)',
              prefixIcon: Icon(Icons.call),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                showLoading = true;
              });
              phone = '+88' + phoneController.text.trim();
              /// Sending Verification code and auto verification
              if (phone.length == 14) {
                await _auth.verifyPhoneNumber(
                  phoneNumber: phone,
                  verificationCompleted: (phoneAuthCredential) async {
                    setState(() {
                      showLoading = false;
                    });
                    //signInWithPhoneAuthCredential(phoneAuthCredential);
                  },
                  verificationFailed: (verificationFailed) async {
                    setState(() {
                      showLoading = false;
                    });
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text(verificationFailed.message)));
                  },
                  codeSent: (verificationId, resendingToken) async {
                    setState(() {
                      showLoading = false;
                      currentState =
                          MobileVerificationState.SHOW_OTP_FORM_STATE;
                      this.verificationId = verificationId;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationId) async {},
                );
              } else {
                _showSnackBar(new Text('ভুল নম্বর'));
                setState(() {
                  showLoading = false;
                });
              }
            },
            child: Text(
              'জমা দিন',
              style: new TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
          ),
        ),
        Spacer(),
      ],
    );
  }
  ///Verification Code insertion screen UI design
  getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        new Container(
          padding: EdgeInsets.all(20.0),
          child: new TextField(
            controller: otpController,
            decoration: new InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Colors.yellow, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              hintText: 'OTP',
              prefixIcon: Icon(Icons.dialpad),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: ElevatedButton(
            ///Verifying code
            onPressed: () async {
              PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otpController.text);

              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            child: Text('যাচাই করুন'),
            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
          ),
        ),
        Spacer(),
      ],
    );
  }*/
  String num;
  int counter;
  Future<SharedPref> prefs;
  int _cIndex = 0;
  String _toolbar_name = 'হোম';
  ///Declare for handle switch state
  bool isSwitch = false;
  ///Declare for handle shared preferences data loaded or not
  bool loaded = false;
  ///Declare for handle switch data loaded or not
  bool isLoadedSwitch = false;
  ///Declare for handle theme
  bool isDark = false;
  ///Declare and Initialized ThemeData from ThemesData Class
  ThemeData dark =ThemesData.dark;
  ThemeData light = ThemesData.light;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ///Bottom Navigation Items
  List<Widget> navItems = [
    HomeScreen(),
    Profile(),
  ];

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
      if (_cIndex == 0) {
        _toolbar_name = 'হোম';
      } else {
        _toolbar_name = 'প্রোফাইল';
      }
    });
  }
///Handle Switch Toogle for Theme
  void toogleSwitch(bool value) {
    if (isSwitch == false) {
      setState(() {
        isSwitch = true;
        SharedPref.saveToPreferences(SharedPref.THEME_KEY, 'DARK');
        print('Saved Dark');
      });
    } else {
      setState(() {
        isSwitch = false;
        SharedPref.saveToPreferences(SharedPref.THEME_KEY, 'LIGHT');
        print('Saved Light');
      });
    }
  }

  ///loading theme information from shared preferences
  _loadSharedPreferences() {
    SharedPref.getFromPreferences(SharedPref.THEME_KEY).then((theme) {
      if (theme == null) {
        print('Null Theme');
        isLoadedSwitch = true;
        return;
      } else {
        setState(() {
          theme == "LIGHT" ? isSwitch = false : isSwitch = true;
          isLoadedSwitch = true;
          print(theme);
        });
      }
    });
    SharedPref.getFromPreferences(SharedPref.NUMBER_KEY).then((number) {
      setState(() {
        num = number;
        loaded = true;
      });
    });
  }

  @override
  void initState() {
  //  navigationPage();
    prefs = _loadSharedPreferences();
    super.initState();
  }


  void navigationPage() {
    SharedPref.getFromPreferences(SharedPref.NUMBER_KEY).then((number) {
      setState(() {
        num = number;
        loaded = true;
      });
    });
  }

  //final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
///SnackBar Method
  _showSnackBar(message) {
    var snackBar = new SnackBar(content: message);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
///Handle BackPressed Operations
  Future<bool> _onBackPressed() async {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      _scaffoldKey.currentState.openEndDrawer();
      return false;
    }
    if (_cIndex == 0) {
      SystemNavigator.pop();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      /// Replace the 3 second delay with your initialization code:
      /// future: Future.delayed(Duration(seconds: 3)),
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        /// Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting &&
            Common.isFirst == true) {
          // isFirst=false;
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              ///Checks Theme
              theme: isSwitch == true ? dark : light,
              ///SplashScreen
              home: Scaffold(
                backgroundColor: Colors.lightGreen,
                body: Center(
                    child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Image.asset(
                      'images/logo.png',
                      height: 150,
                      width: 150,
                    ),
                  ],
                )),
              ));
        } else {
          Common.isFirst = false;
          if (isLoadedSwitch == true) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                ///Checks Theme
                theme: isSwitch == true ? dark : light,
                ///Checks Data Loaded or not then Shows Navigation Screen
                home: loaded == true
                    ? /*num != null
                        ? */Builder(
                            builder: (context) {
                              return WillPopScope(
                                child: Scaffold(
                                  key: _scaffoldKey,
                                  appBar: new AppBar(
                                    title: new Text(_toolbar_name),
                                    // backgroundColor: Theme.of(context).primaryColor,
                                    backwardsCompatibility: false,
                                    // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Common.baseColor),
                                    actions: [
                                      Switch(
                                        onChanged: toogleSwitch,
                                        value: isSwitch,
                                        // activeColor: Colors.blue,
                                        activeThumbImage: AssetImage(
                                          'images/dark.png',
                                        ),

                                        activeTrackColor: Colors.white,
                                        // inactiveThumbColor: Colors.redAccent,
                                        inactiveThumbImage: AssetImage(
                                          'images/light.png',
                                        ),
                                        inactiveTrackColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                  drawer: DrawerNavigation(),
                                  //backgroundColor:Theme.of(context).backgroundColor,
                                  floatingActionButtonLocation:
                                      FloatingActionButtonLocation.centerDocked,
                                  floatingActionButton: FloatingActionButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  new AddSell()))
                                          .whenComplete(() => initState());
                                    },
                                    child: Icon(Icons.add),
                                    elevation: 2.0,
                                  ),

                                  bottomNavigationBar: BottomAppBar(
                                      shape: CircularNotchedRectangle(),
                                      notchMargin: 5,
                                      clipBehavior: Clip.antiAlias,
                                      child: BottomNavigationBar(
                                        currentIndex: _cIndex,
                                        type: BottomNavigationBarType.fixed,
                                        items: [
                                          BottomNavigationBarItem(
                                            icon: Icon(Icons.home,
                                                color: Common.blackColor),
                                            activeIcon: Icon(Icons.person,
                                                color: Colors.white),
                                            label: 'হোম',
                                          ),
                                          BottomNavigationBarItem(
                                            icon: Icon(Icons.person,
                                                color: Common.blackColor),
                                            activeIcon: Icon(Icons.person,
                                                color: Colors.white),
                                            label: 'প্রোফাইল',
                                          )
                                        ],
                                        onTap: (index) {
                                          _incrementTab(index);
                                        },
                                      )),
                                  body: navItems[_cIndex],
                                ),
                                onWillPop: _onBackPressed,
                              );
                            },
                          )
                /*      : new Scaffold(
                  ///SignUp Screen
                            key: _scaffoldKey,
                            body: new Container(
                              child: showLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : currentState ==
                                          MobileVerificationState
                                              .SHOW_MOBILE_FORM_STATE
                                      ? getMobileFormWidget(context)
                                      : getOtpFormWidget(context),
                              padding: const EdgeInsets.all(16),
                            ))*/
                    : Container(
                        color: Colors.yellow,
                        child: Text('Loading'),
                      ));
          } else {
            return MaterialApp(
                home: Scaffold(
              body: Container(
                color: Colors.white,
                child: Center(child: Text('Something Went Wrong')),
              ),
            ));
          }
        }
      },
    );
  }
}
