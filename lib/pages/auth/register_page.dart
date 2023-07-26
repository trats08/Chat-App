import 'package:chattie/helper/helper_funcion.dart';
import 'package:chattie/pages/auth/login_page.dart';
import 'package:chattie/pages/home_page.dart';
import 'package:chattie/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String fullName = "";
  String email = "";
  String password = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: _isLoading? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),) : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:20,vertical: 80),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Chattie",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40
                    ),),
                  SizedBox(height: 10),
                  Text("Create an account now to chat and explore",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400
                    ),),
                  Image.asset("assets/register.png"),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "UserName",
                        prefixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,)
                    ),

                    // EMAIL VALIDATOR

                    validator: (val){
                      if(val!.isNotEmpty){
                        return null;
                      }
                      else{
                        return "Name cannot be empty";
                      }
                    },

                    onChanged: (val){
                      setState(() {
                        fullName = val;
                      });
                    },

                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,)
                    ),

                    // EMAIL VALIDATOR

                    validator: (val){
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!)
                          ? null
                          : "Please enter a valid email";
                    },

                    onChanged: (val){
                      setState(() {
                        email = val;
                        print(email);
                      });
                    },

                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,)
                    ),
                    validator: (val){
                      if(val!.length < 6){
                        return "Password must be atleast 6 characters";
                      }
                      else {
                        return null;
                      }
                    },
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                          )),
                      child: const Text("Register",
                        style: TextStyle(color: Colors.white,fontSize: 16),
                      ),
                      onPressed: () {register();},
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text.rich(
                      TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(color: Colors.black,fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Login now",
                                style: TextStyle(
                                    color: Colors.black,fontSize: 14,
                                  decoration: TextDecoration.underline
                                ),
                                recognizer: TapGestureRecognizer()..onTap=(){
                                  nextScreen(context, const LoginPage());
                                }
                            ),
                          ]
                      )
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
  register() async{
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async{
        if(value == true){
          //saving the shared pereference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          nextScreen(context, const HomePage());
        }
        else{
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading=false;
          });
        }
      });
    }
  }
}
