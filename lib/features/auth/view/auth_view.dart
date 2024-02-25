import '../../../utils/validator.dart';
import '/core.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.person,
                size: 100,
              ),
              const SizedBox(height: 50),
              const Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: AppColor.darkGrey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              AppTextField(
                controller: authViewModel.emailController,
                hintText: 'Email',
                obscureText: false,
                textInputType: TextInputType.emailAddress,
                validator: (email) => Validator.validateEmail(email),
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: authViewModel.passwordController,
                hintText: 'Password',
                obscureText: true,
                showSuffixIcon: true,
                validator: (pass) => Validator.validatePasswords(pass),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AppButton(
                text: authViewModel.isSignIn ? "Sign In" : "Sign Up",
                isLoading: authViewModel.loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    if(authViewModel.isSignIn){
                      authViewModel.signInWithEmailPassword(
                        email: authViewModel.emailController.text.toString(),
                        password: authViewModel.passwordController.text.toString(),
                      );
                    }else{
                      authViewModel.signUpWithEmailPassword(
                        email: authViewModel.emailController.text.toString(),
                        password: authViewModel.passwordController.text.toString(),
                      );
                    }
                  }
                }
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      authViewModel.toggleSignIn();
                    },
                    child: Text(
                      "Sign Up Now",
                      style: TextStyle(
                        color: AppColor.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
