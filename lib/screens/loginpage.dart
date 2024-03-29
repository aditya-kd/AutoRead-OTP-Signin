import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj1/services/authservice.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo = '', verificationId = '', smsCode = '';

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: 'Enter phone number'),
                    onChanged: (val) {
                      setState(() {
                        this.phoneNo = val;
                      });
                    },
                  )),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: Container(
                  alignment: Alignment.center,
                  child: PinFieldAutoFill(
                    codeLength: 6,
                    onCodeChanged: (val) {
                      print('AutoFillField: ' + val!);
                    },
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: ElevatedButton(
                      child: Center(
                          child: codeSent ? Text('Login') : Text('Verify')),
                      onPressed: () async {
                        final signCode = SmsAutoFill().getAppSignature;
                        print(signCode);
                        codeSent
                            ? AuthService()
                                .signInWithOTP(smsCode, verificationId)
                            : verifyPhone(phoneNo);
                      }))
            ],
          )),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int? forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}