import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/model/myuser.dart';
import 'package:todo/database/mydatabase.dart';
import 'package:todo/provider/auth_provider.dart';
import 'package:todo/ui/component/custom_form_field.dart';
import 'package:todo/ui/component/dialog_utils.dart';
import 'package:todo/ui/component/validations_regex.dart';
import 'package:todo/ui/home_screen/home_screen.dart';
import 'package:todo/ui/register_screen/registerscreen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'loginscreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration:  BoxDecoration(
          color: Theme.of(context).hintColor,
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background.png',
            ),
            fit: BoxFit.fill,
          )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.3,
                ),
                CustomFormField(
                    label: 'Email Adrress',
                    controller: emailController,
                    validator: (value){
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your Email';
                      }
                      if (!ValidationRegex.emailRegex(value)) {
                        return 'Please enter Valid Email';
                      }
                      return null;
                    }),
                CustomFormField(
                  label: 'password',
                  controller: passwordController,
                  validator: (value){
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your Password';
                    }
                    if (!ValidationRegex.passwordRegex(value)){
                      return 'Please enter valid Password';
                    }
                    return null;
                  },
                  isPassword: hidePassword,
                  suffix:IconButton(
                    onPressed: (){
                      if(hidePassword == false){
                        hidePassword = true;
                      }
                      else {
                        hidePassword = false;
                      }
                      setState(() {

                      });
                    },
                    icon: hidePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                    onPressed: (){
                      login();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Icon(Icons.arrow_forward)
                      ],
                    )
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () {
                      signInWithGoogle();
                    },
                    child:const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Register By Google',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward)
                      ],
                    )),
                TextButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                    },
                    child: Text(
                      "Don't Have Account?",
                      style: Theme.of(context).textTheme.labelSmall,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
  FirebaseAuth authServices = FirebaseAuth.instance;
  login() async{
    if(!formKey.currentState!.validate()){
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Loading...');
    String errorMessage;
    try {
      var result = await authServices.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      var myUser = await MyDataBase.readUser(result.user?.uid);
      DialogUtils.hideDialog(context);
      if(myUser==null){
        // user is authenticated but not exists in the database
        DialogUtils.showMessage(context, "error. can't find user in db",
            postActionName: 'ok');
        return;
      }
      var provider = Provider.of<AuthProvider>(context,listen: false);
      provider.updateUser(myUser);
      DialogUtils.showMessage(context, 'user logged in successfully',
          postActionName: 'ok',
          posAction: (){
            Navigator.pushReplacementNamed(context,HomeScreen.routeName);
          },dismissible: false
      );
    }on FirebaseAuthException {
      DialogUtils.hideDialog(context);
      errorMessage = 'wrong email or password';
      DialogUtils.showMessage(context, errorMessage,
          postActionName: 'ok');

    } catch (e){
      DialogUtils.hideDialog(context);
      errorMessage = 'Something went wrong';
      DialogUtils.showMessage(context, errorMessage,
          postActionName: 'cancel',
          negActionName: 'Try Again',
          negAction: (){
            login();
          }
      );

    }
  }
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<void> signInWithGoogle() async {
    var provider = Provider.of<AuthProvider>(context,listen: false);
    print('1050505050');
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    print('2050505050');
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;
    print('3050505050');
    AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    print('5050505050');
    UserCredential authResult = await authServices.signInWithCredential(authCredential);
    User user = await authServices.currentUser!;
    if(await MyDataBase.readUser(user.uid) == null){
      MyUser myUser = MyUser(
        email: user.email,
        id: user.uid,
      );
      await MyDataBase.addUser(myUser);
      provider.updateUser(myUser);
      Navigator.pushReplacementNamed(context,HomeScreen.routeName);
    }
    else {
      var myUser = await MyDataBase.readUser(user.uid);
      provider.updateUser(myUser!);
      Navigator.pushReplacementNamed(context,HomeScreen.routeName);
    }
  }
}