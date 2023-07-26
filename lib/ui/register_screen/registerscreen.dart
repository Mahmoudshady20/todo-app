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
import 'package:todo/ui/login_screen/loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'registerscreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
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
          title: const Text('Register'),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                CustomFormField(
                  label: 'Full Name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your Name';
                    }
                    return null;
                  },
                ),
                CustomFormField(
                    label: 'Email Adrress',
                    controller: emailController,
                    validator: (value) {
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your Password';
                    }
                    if (!ValidationRegex.passwordRegex(value)){
                      return 'Please enter valid Password';
                    }
                    return null;
                  },
                  isPassword: hidePassword,
                  suffix: IconButton(
                    onPressed: () {
                      if (hidePassword == false) {
                        hidePassword = true;
                      } else {
                        hidePassword = false;
                      }
                      setState(() {});
                    },
                    icon: hidePassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ),
                CustomFormField(
                  label: 'confirm password',
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'please enter password-confirmation';
                    }
                    if (passwordController.text != value) {
                      return "password doesn't match";
                    }
                    return null;
                  },
                  isPassword: hideConfirmPassword,
                  suffix: IconButton(
                    onPressed: () {
                      if (hideConfirmPassword == false) {
                        hideConfirmPassword = true;
                      } else {
                        hideConfirmPassword = false;
                      }
                      setState(() {});
                    },
                    icon: hideConfirmPassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                    onPressed: () {
                      register();
                    },
                    child:const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward)
                      ],
                    )),
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
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    },
                    child:  Text(
                      'Already Have Account?',
                      style:Theme.of(context).textTheme.labelSmall,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
FirebaseAuth authServices = FirebaseAuth.instance;
  void register() async{
    if (!formKey.currentState!.validate()) {
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Loading...');
    try {
      var result = await authServices.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      MyUser myUser = MyUser(
        id: result.user?.uid,
        email: emailController.text,
        name: nameController.text
      );
      await MyDataBase.addUser(myUser);
      var provider = Provider.of<AuthProvider>(context,listen: false);
      provider.updateUser(myUser);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, 'user registered successfully',
          postActionName: 'ok',
          posAction: (){
            Navigator.pushReplacementNamed(context,LoginScreen.routeName);
          },dismissible: false
      );
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideDialog(context);
      String errorMessage = 'Something went wrong';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      DialogUtils.showMessage(context, errorMessage,
          postActionName: 'ok');

    } catch (e) {
      DialogUtils.hideDialog(context);
      String errorMessage = 'Something went wrong';
      DialogUtils.showMessage(context, errorMessage,
          postActionName: 'cancel',
          negActionName: 'Try Again',
          negAction: (){
            register();
          }
      );
    }
  }
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<void> signInWithGoogle() async {
    print('1050505050');
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    print('2050505050');
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;
    print('3050505050');
    AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    UserCredential authResult = await authServices.signInWithCredential(authCredential);
    User user = await authServices.currentUser!;
    MyUser myUser = MyUser(
      email: user.email,
      id: user.uid,
    );
    await MyDataBase.addUser(myUser);
    print('user email = ${myUser.email}');
    var provider = Provider.of<AuthProvider>(context,listen: false);
    provider.updateUser(myUser);
    Navigator.pushReplacementNamed(context,HomeScreen.routeName);
  }
}
