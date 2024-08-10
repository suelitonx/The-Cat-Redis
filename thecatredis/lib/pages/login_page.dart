import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thecatredis/services/auth_service.dart';

import '../services/theme/theme_model.dart';

class LoginPage extends StatefulWidget {
  final AuthService authService;

  const LoginPage({super.key, required this.authService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool carregando = false;

  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  final themeService = ThemeModel.instance;

  @override
  void initState() {
    carregarPreferencias();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Bounce(
                duration: const Duration(seconds: 3),
                //infinite: true,
                child: InkWell(
                  radius: 20,
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    themeService.toggleTheme();
                  },
                  child: Image.asset('assets/logo.png', height: 40),
                ),
              ),
              const SizedBox(width: 10),
              FadeInDown(child: Text('The Cat Redis', style: GoogleFonts.workSans(fontSize: 30))),
            ],
          ),
          const Spacer(),
          FadeInRight(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width < 400 ? MediaQuery.of(context).size.width * 0.8 : 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Campo de texto para inserir o e-mail
                    Text("E-mail", style: GoogleFonts.workSans(fontSize: 16)),
                    const SizedBox(height: 3),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.pink[themeService.isDarkMode ? 300 : 200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: emailController,
                        style: GoogleFonts.workSans(fontSize: 16),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Senha", style: GoogleFonts.workSans(fontSize: 16)),
                    const SizedBox(height: 3),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.pink[themeService.isDarkMode ? 300 : 200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: senhaController,
                        style: GoogleFonts.workSans(fontSize: 16),
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          //labelText: 'E-mail',
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        obscureText: true,
                      ),
                    ),

                    buildButtonLogin("Entrar", () => fazerLogin(), pTop: 10),
                    buildRegisterButton("Registrar", () => fazerLogin(cadastro: true), pTop: 10),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Center(child: FadeInUp(child: Image.asset('assets/gato3.png'))),
        ],
      ),
    );
  }

  Widget buildButtonLogin(String texto, Function()? funcao, {double pTop = 10, bool isLoading = false}) {
    return Padding(
      padding: EdgeInsets.only(top: pTop),
      child: ElevatedButton(
        onPressed: isLoading == true ? () {} : funcao,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          elevation: 2,
          shadowColor: Colors.black,
          minimumSize: const Size.fromHeight(60),
          backgroundColor: Colors.pink,
        ),
        child: isLoading ? const CircularProgressIndicator(color: Colors.black) : Text(texto, style: GoogleFonts.workSans(fontSize: 17, color: Colors.white)),
      ),
    );
  }

  Widget buildRegisterButton(String texto, Function()? funcao, {double pTop = 0, bool isLoading = false}) {
    return Padding(
      padding: EdgeInsets.only(top: pTop),
      child: OutlinedButton(
        onPressed: isLoading ? () {} : funcao,
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(color: Colors.pink, width: 1), // define a cor e a largura da borda
          minimumSize: const Size.fromHeight(60),
        ),
        child: Text(
          texto,
          style: GoogleFonts.workSans(fontSize: 15),
        ),
      ),
    );
  }

  Future<void> fazerLogin({bool cadastro = false}) async {
    setState(() {
      carregando = true;
    });

    final resultado = cadastro ? await widget.authService.register(emailController.text, senhaController.text) : await widget.authService.login(emailController.text, senhaController.text);

    if (mounted) {
      setState(() {
        carregando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultado.$2)));
    }
  }

  Future<void> carregarPreferencias() async {
    final (e, s) = await widget.authService.getEmailSenha();

    emailController.text = e;
    senhaController.text = s;

    setState(() {});
  }
}
