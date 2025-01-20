import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'onboarding_screen.dart';

/// `SplashScreen` é um StatefulWidget que exibe uma animação com Lottie.
/// Após a animação ser concluída, o usuário é redirecionado para a próxima tela.
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// O estado associado à `SplashScreen`.
/// Implementa a lógica para exibir a animação e redirecionar o usuário.
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controla a reprodução da animação.

  /// Método chamado ao inicializar o estado.
  /// Configura o [AnimationController] para reproduzir a animação e ouvir seu status.
  @override
  void initState() {
    super.initState();

    // Inicializa o controlador de animação com a duração de 7 segundos.
    _controller = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this, // Necessário para sincronia com a renderização da tela.
    );

    // Ouve o status da animação para agir ao final da reprodução.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Redireciona o usuário para a tela de onboarding.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  /// Método chamado ao descartar o estado.
  /// Garante que o [AnimationController] seja limpo para evitar vazamento de memória.
  @override
  void dispose() {
    _controller.dispose(); // Descarta o controlador de animação.
    super.dispose();
  }

  /// Constrói a interface da tela de splash.
  /// Exibe uma animação e um texto centralizados.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background, // Usa a cor de fundo definida no tema.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza os widgets verticalmente.
          children: [
            // Exibe uma animação usando Lottie.
            Lottie.network(
              'https://assets2.lottiefiles.com/packages/lf20_cwqf5i6h.json', // URL da animação.
              controller: _controller, // Controla a reprodução da animação.
              onLoaded: (composition) {
                // Define a duração da animação e a inicia.
                _controller
                  ..duration = composition.duration
                  ..forward(); // Inicia a animação.
              },
            ),
            const SizedBox(height: 20), // Espaço entre a animação e o texto.

            // Exibe o título "GitHub Explorer".
            Text(
              'GitHub Explorer',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white, // Cor branca para o texto.
                    fontWeight: FontWeight.bold, // Texto em negrito.
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
