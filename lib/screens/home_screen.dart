import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import '../services/github_service.dart';
import '../models/repository.dart';
import '../widgets/main_drawer.dart';

// Tela principal que exibe os repositórios do usuário.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GitHubService _gitHubService = GitHubService(); // Serviço para buscar os repositórios.
  final _storage = const FlutterSecureStorage(); // Armazena e recupera dados do token.
  List<Repository> _repositories = []; // Lista dos repositórios do usuário.
  bool _isLoading = true; // Indicador de carregamento.

  @override
  void initState() {
    super.initState();
    _loadRepositories(); // Carrega os repositórios ao iniciar a tela.
  }

  // Gera a interface de carregamento com shimmer.
  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[700]!,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(16),
            ),
          ),
        );
      },
    );
  }

  // Carrega a lista de repositórios do GitHub.
  Future<void> _loadRepositories() async {
    try {
      final token = await _storage.read(key: 'github_token');
      if (token != null) {
        final repos = await _gitHubService.getRepositories(token);
        if (mounted) {
          setState(() {
            _repositories = repos;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar repositórios: $e')),
        );
      }
    }
  }

  // Abre o navegador para acessar o URL do repositório.
  void _launchRepositoryUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o repositório')), // Erro ao abrir URL.
        );
      }
    }
  }

  // Monta a interface da tela principal.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(), // Menu lateral.
      backgroundColor: Theme.of(context).colorScheme.background, // Fundo dinâmico baseado no tema.
      appBar: AppBar(
        title: const Text('Meus Repositórios'),
      ),
      body: _isLoading // Exibe shimmer durante o carregamento.
          ? _buildLoadingShimmer()
          : RefreshIndicator(
              onRefresh: _loadRepositories, // Permite atualizar a lista deslizando para baixo.
              child: ListView.builder(
                itemCount: _repositories.length,
                itemBuilder: (context, index) {
                  final repo = _repositories[index]; // Repositório atual.
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: InkWell(
                      onTap: () => _launchRepositoryUrl(repo.htmlUrl), // Abre o link no navegador ao tocar.
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Linha superior com avatar e nome do repositório.
                            Row(
                              children: [
                                Hero(
                                  tag: 'repo_${repo.id}', // Animação de transição do avatar.
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(repo.ownerAvatarUrl),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        repo.name, // Nome do repositório.
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Indicador de repositório público ou privado.
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: repo.isPrivate
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.green.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          repo.isPrivate ? 'Privado' : 'Público',
                                          style: TextStyle(
                                            color: repo.isPrivate ? Colors.red : Colors.green,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Descrição do repositório (se disponível).
                            if (repo.description != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                repo.description!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                maxLines: 2, // Limita a descrição a 2 linhas.
                                overflow: TextOverflow.ellipsis, // Adiciona "..." caso o texto exceda.
                              ),
                            ],
                            const SizedBox(height: 12),
                            // Indicadores de stars e forks.
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${repo.stargazersCount}', // Número de estrelas.
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.fork_right,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${repo.forksCount}', // Número de forks.
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
