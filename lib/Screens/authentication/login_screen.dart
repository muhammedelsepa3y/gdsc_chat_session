import 'package:flutter/material.dart';
import 'package:gdsc_chat_session/Components/input_component.dart';
import 'package:gdsc_chat_session/Components/login_button.dart';
import 'package:gdsc_chat_session/Screens/authentication/signup_screen.dart';
import 'package:provider/provider.dart';

import '../../Services/user_provider.dart';
import '../../Util/size_config.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var userProvider=Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight * 0.2,
                ),
                const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                InputComponent(
                  con: userProvider.emailController,
                  enter: TextInputType.emailAddress,
                  lab: "Email",
                  pre: const Icon(Icons.email),
                  validate: (p0) {
                    if (p0 == "") {
                      return "Email is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                InputComponent(
                  con:userProvider.passwordController,
                  lab: "Password",
                  pre: const Icon(Icons.lock),
                  validate: (p0) {
                    if (p0 == "") {
                      return "Password is required";
                    }
                    return null;
                  },
                  isObsecure: Provider.of<UserProvider>(context, listen: true).secure,
                  suf: Provider.of<UserProvider>(context, listen: true).secure ? Icons.visibility : Icons.visibility_off,
                  suffunf: () {
                      userProvider.setSecure();
                  },
                ),

                const SizedBox(
                  height: 20,
                ),
                LoginButtonComponent(
                  function: ()   {
                    if (_formKey.currentState!.validate()) {
                      userProvider.login();
                    }

                  },
                ),
                 Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Don't have an account?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),),

                      GestureDetector(
                        onTap: (){
                          userProvider.disposeAlldata();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (BuildContext context) =>  SignUpScreen()));
                        },
                        child: Text("Sign Up Now",style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
