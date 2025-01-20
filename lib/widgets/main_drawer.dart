import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/github_service.dart';
import '../screens/home_screen.dart';
import '../screens/user_search_screen.dart';
import '../screens/create_repo_screen.dart';
import '../screens/login_screen.dart';

// Menu lateral que exibe as opções de navegação para o usuário.
class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final GitHubService _gitHubService = GitHubService(); // Serviço de comunicação com a API do GitHub.
  String? _avatarUrl; // URL do avatar do usuário.
  String? _username;  // Nome do usuário no GitHub.

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Carrega as informações do usuário ao inicializar.
  }

  // Obtém informações do usuário (avatar e nome de login) através do token armazenado.
  Future<void> _loadUserInfo() async {
    try {
      final storage = const FlutterSecureStorage(); // Armazena o token de forma segura.
      final token = await storage.read(key: 'github_token'); // Recupera o token salvo.
      final userInfo = await _gitHubService.getUserInfo(token!); // Chama a API para buscar os dados do usuário.

      setState(() {
        _avatarUrl = userInfo['avatar_url']; // Armazena o URL do avatar.
        _username = userInfo['login']; // Armazena o nome do usuário.
      });
    } catch (e) {
      // Trata erros de forma silenciosa para evitar que a interface seja impactada.
    }
  }

  // Constrói o layout do menu lateral.
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.background, // Cor de fundo baseada no tema.
        child: ListView(
          padding: EdgeInsets.zero, // Remove os paddings padrão.
          children: [
            // Cabeçalho do menu, exibindo o avatar e nome do usuário.
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // Fundo do cabeçalho com a cor primária do tema.
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: _avatarUrl != null 
                      ? NetworkImage(_avatarUrl!) // Mostra a imagem do avatar se disponível.
                      : null,
                    child: _avatarUrl == null 
                      ? const Icon(Icons.person, size: 35) // Mostra um ícone padrão se não houver avatar.
                      : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _username ?? 'GitHub Explorer', // Exibe o nome do usuário ou uma mensagem padrão.
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            // Opção para navegar até a tela "Meus Repositórios".
            ListTile(
              leading: const Icon(Icons.folder), // Ícone da opção.
              title: const Text('Meus Repositórios'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu lateral.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()), // Navega para a HomeScreen.
                );
              },
            ),
            // Opção para navegar até a tela de busca de usuários.
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Buscar Usuários'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu lateral.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserSearchScreen()), // Navega para a UserSearchScreen.
                );
              },
            ),
            // Opção para navegar até a tela de criação de repositório.
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Criar Repositório'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu lateral.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateRepoScreen()), // Navega para a CreateRepoScreen.
                );
              },
            ),
            const Divider(), // Linha divisória para separar as opções.
            // Opção para sair da conta e voltar à tela de login.
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                final storage = FlutterSecureStorage();
                await storage.deleteAll(); // Limpa todos os dados armazenados, incluindo o token.
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()), // Navega para a tela de login.
                    (route) => false, // Remove todas as telas anteriores.
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
