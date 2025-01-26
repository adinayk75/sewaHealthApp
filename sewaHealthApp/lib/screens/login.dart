import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  bool rememberMe = false;
  String? email;
  late ConfirmationResult confirmationResult;
  final _formKey = GlobalKey<FormState>();

  bool useSMSAuth = true;

  //https://firebase.flutter.dev/docs/auth/phone/
  Future<void> _submitPhoneNumber() async {
    String _phoneNumber = _emailController.text;
    debugPrint('LoginPage._submitPhoneNumber: $_phoneNumber');
    final _auth = FirebaseAuth.instance;
    _auth.setPersistence(Persistence.LOCAL);
    RecaptchaVerifier recaptchaVerifier = RecaptchaVerifier(
      onSuccess: () {
        debugPrint("reCAPTCHA success");
      },
      onError: (FirebaseAuthException error) =>
          debugPrint("RecaptchaVerifier onError called: $error"),
      onExpired: () => debugPrint('reCAPTCHA Expired!'),
    );
    debugPrint('LoginPage._submitPhoneNumber - created RecaptchaVerifier');
    try {
      confirmationResult =
          await _auth.signInWithPhoneNumber(_phoneNumber, recaptchaVerifier);
      debugPrint("got back from signInWithPhoneNumber:");
      smsCodeDialog(context, _phoneNumber, confirmationResult);
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((_) => _afterLayout(context));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // create a login screen with email as input
    return Scaffold(
      body: Center(
        child: Container(
          height: 300.0,
          width: 425.0,
          padding: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white70.withOpacity(0.8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.5),
                  blurRadius: 1.5,
                ),
              ]),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    textAlign: TextAlign.left,
                    onFieldSubmitted: (value) {
                      debugPrint("onSubmitted: $value");
                      _submitPhoneNumber();
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "Enter PhoneNumber in International Format",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //         value: rememberMe,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             rememberMe = value!;
                  //           });
                  //         }),
                  //     const Text('Remember me')
                  //   ],
                  // ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    child: const Text("Login"),
                    onPressed: _submitPhoneNumber
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> smsCodeDialog(BuildContext context, String phoneNumber,
      ConfirmationResult confirmationResult) {
    TextEditingController codeController = TextEditingController();

    _onSubmitOTP(String verificationCode) {
      confirmationResult.confirm(verificationCode).whenComplete(() {
        debugPrint("Sign-in completed");
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/');
      });
    }

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter Code"),
            content: SizedBox(
              height: 100,
              width: 300,
              child: Column(
                children: [
                  Text(
                      'OTP sent to XXX-XXX-${phoneNumber.substring(phoneNumber.length - 4)}'),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    controller: codeController,
                    onSubmitted: (value) {
                      _onSubmitOTP(value);
                    },
                  ),
                ],
              ),
            ),
            contentPadding: const EdgeInsets.all(16.0),
            actions: <Widget>[
              ElevatedButton(
                  child: const Text("Verify"),
                  onPressed: () {
                    String verificationCode = codeController.value.text;
                    _onSubmitOTP(verificationCode);
                    // TODO .onError((error, stackTrace) => null);
                  })
            ],
          );
        });
  }

}
