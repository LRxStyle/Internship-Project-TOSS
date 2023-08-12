import 'package:demo_input_toss/InputTossData.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();

  final FocusNode _userIDFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = {
        'userID': _userIDController.text,
        'password': _passwordController.text,
      };
      print(user.toString());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration sent')));
      //_formKey.currentState.save();
      //_formKey.currentState.reset();
      //_nextFocus(_nameFocusNode);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InputTossData()));

    }
  }

  String? _validateInput(String? value) {
    if(value!.trim().isEmpty) {
      return 'Field required';
    }
    return null;
  }

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child:Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    focusNode: _userIDFocusNode,
                    controller: _userIDController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: _validateInput,
                    onFieldSubmitted: (String value) {
                      _nextFocus(_passwordFocusNode);
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your ID',
                      labelText: 'User ID',
                    ),
                  ),
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    obscuringCharacter: "*",
                    validator: _validateInput,
                    onFieldSubmitted: (String value) {
                      _submitForm();
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter your password',
                        labelText: 'Password',
                        suffixIcon: Icon(Icons.visibility_off_outlined)),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 16,
                          ),
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Login'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}