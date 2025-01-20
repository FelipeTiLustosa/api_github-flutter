import 'package:flutter/material.dart';
import 'login_screen.dart';

// Representa as informações de cada página no onboarding.
class OnboardingPage {
  final String title; // Título da página.
  final String description; // Descrição da funcionalidade apresentada.
  final IconData icon; // Ícone representativo da funcionalidade.
  final Color iconColor; // Cor do ícone.

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controlador do PageView para gerenciar navegação entre as páginas.
  final PageController _pageController = PageController();

  // Mantém o índice da página atual.
  int _currentPage = 0;

  // Lista de páginas exibidas no onboarding.
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Bem-vindo ao GitHub Explorer',
      description: 'Gerencie seus repositórios de forma fácil e intuitiva',
      icon: Icons.code, // Ícone de código.
      iconColor: Colors.blue, // Cor do ícone.
    ),
    OnboardingPage(
      title: 'Explore Repositórios',
      description: 'Veja detalhes, estatísticas e mais sobre seus projetos',
      icon: Icons.search, // Ícone de pesquisa.
      iconColor: Colors.green,
    ),
    OnboardingPage(
      title: 'Comece Agora',
      description: 'Faça login com seu token do GitHub para começar',
      icon: Icons.rocket_launch, // Ícone de foguete.
      iconColor: Colors.orange,
    ),
  ];

  // Avança para a próxima página no PageView.
  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300), // Animação da transição.
        curve: Curves.easeIn, // Curva de animação.
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            // PageView para navegar entre as páginas do onboarding.
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page; // Atualiza a página atual.
                });
              },
              itemBuilder: (context, index) {
                final page = _pages[index]; // Página atual.
                return SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 100,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          page.icon, // Exibe o ícone da página.
                          size: 120, // Tamanho do ícone.
                          color: page.iconColor, // Cor do ícone.
                        ),
                        const SizedBox(height: 40), // Espaçamento.
                        Text(
                          page.title, // Título da página.
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20), // Espaçamento.
                        Text(
                          page.description, // Descrição da página.
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[300],
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Indicadores e botões de navegação.
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Indicadores visuais de progresso nas páginas.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botão "Pular", navega diretamente para a tela de login.
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Pular',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                        // Botão "Próximo" ou "Começar", navega para próxima página ou login.
                        ElevatedButton(
                          onPressed: _currentPage == _pages.length - 1
                              ? () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                }
                              : _nextPage,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _currentPage == _pages.length - 1 ? 'Começar' : 'Próximo',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Gera os indicadores para cada página.
  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pages.length; i++) {
      indicators.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Tempo da animação.
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == _currentPage ? 24 : 8, // Tamanho ativo/inativo.
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: i == _currentPage
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
        ),
      );
    }
    return indicators;
  }
}
