import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Task ABG Egypt",style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Login",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),),
              const SizedBox(height: 32,),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "User Name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter user name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16,),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16,),
              MaterialButton(
                color: Colors.deepPurple,
                minWidth: double.infinity,
                height: 50,
                onPressed: (){
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text("LOGIN",style: TextStyle(
                  color: Colors.white,
                ),),
              ),
              const SizedBox(height: 16,),
              MaterialButton(
                color: Colors.purple,
                minWidth: double.infinity,
                height: 50,
                onPressed: (){},
                child: const Text("ANONYMOUS",style: TextStyle(
                  color: Colors.white,
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
