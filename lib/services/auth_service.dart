import 'package:chattie/helper/helper_funcion.dart';
import 'package:chattie/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //LOGIN

  Future loginWithUserNameandPassword(String email, String password) async{
    try{
      User user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .user!;

      if(user != null){

        //call our database service to update the user data.
        return true;
      }
    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }

  //REGISTER

  Future registerUserWithEmailandPassword(String fullName, String email, String password) async{
    try{
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password))
          .user!;

      if(user != null){

        //call our database service to update the user data.
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }


  //SIGNOUT

  Future signOut() async{
    try{
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserEmailSF("");
      await firebaseAuth.signOut();

    } catch(e){
      return null;
    }
  }
}