import 'package:flutter/material.dart';
import 'package:l4_seance_2/auth_provider.dart';
import 'package:l4_seance_2/controller/login_controller.dart';
import 'package:l4_seance_2/view/home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // final _controller = LoginController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios_sharp),
          backgroundColor: Color.fromRGBO(38, 195, 24, 1),
          title: Text(
            'Connexion',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            // spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EMAIL',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.email),
                    labelText: 'label email',
                    hintText: 'joseph@gmail.com',
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 30),
              Text('PASSWORD',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    suffix: GestureDetector(
                        onTap: () {}, child: Icon(Icons.remove_red_eye)),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 30),
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  if (auth.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(auth.errorMessage!,
                          style: TextStyle(color: Colors.red)),
                    );

                  return auth.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            _onLoginPressed(context);
                          },
                          child: Text("SE CONNECTER"),
                        );
                },
              ),
            ],
          ),
        ));
  }

  void _onLoginPressed(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    bool success = await context.read<AuthProvider>().login(email, password);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }
}
