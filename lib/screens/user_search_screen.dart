import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/repository.dart';

// Tela de busca de repositórios de usuários do GitHub.
class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({Key? key}) : super(key: key);

  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

// Estado associado à tela UserSearchScreen.
class _UserSearchScreenState extends State<UserSearchScreen> {
  final _searchController = TextEditingController(); // Controla o campo de texto da busca.
  final GitHubService _gitHubService = GitHubService(); // Serviço para interagir com a API do GitHub.
  List<Repository> _repositories = []; // Lista de repositórios obtidos da pesquisa.
  bool _isLoading = false; // Indica se a requisição está em andamento.
  String? _error; // Armazena a mensagem de erro (se houver).

  // Método que executa a pesquisa de usuários.
  Future<void> _searchUser() async {
    if (_searchController.text.isEmpty) return; // Retorna caso o campo esteja vazio.

    setState(() {
      _isLoading = true; // Ativa o estado de carregamento.
      _error = null; // Reseta qualquer erro anterior.
    });

    try {
      // Obtém os repositórios usando o GitHubService.
      _repositories = await _gitHubService.getUserRepositories(_searchController.text);
      setState(() {
        _isLoading = false; // Desativa o carregamento.
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Desativa o carregamento.
        _error = e.toString(); // Define a mensagem de erro.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // Define a cor de fundo da tela.
      appBar: AppBar(
        title: const Text('Buscar Usuários'), // Título da AppBar.
        backgroundColor: Colors.transparent, // Torna a AppBar transparente.
        elevation: 0, // Remove a sombra da AppBar.
      ),
      body: Column(
        children: [
          // Campo de busca e botão.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController, // Controla o texto inserido.
                    style: const TextStyle(color: Colors.white), // Texto em branco.
                    decoration: InputDecoration(
                      hintText: 'Nome do usuário', // Placeholder no campo.
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: const Color(0xFF161B22),
                    ),
                    onSubmitted: (_) => _searchUser(), // Dispara a busca ao pressionar Enter.
                  ),
                ),
                const SizedBox(width: 16), // Espaçamento entre os campos.
                // Botão de busca.
                ElevatedButton(
                  onPressed: _isLoading ? null : _searchUser, // Desativa se já estiver carregando.
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    backgroundColor: const Color(0xFF238636), // Cor do botão.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ) // Mostra um indicador se carregando.
                      : const Text(
                          'Buscar', // Texto padrão do botão.
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ],
            ),
          ),

          // Exibe um dos seguintes estados: carregando, erro ou resultados.
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(
              child: Text(
                _error!, // Exibe a mensagem de erro.
                style: const TextStyle(color: Colors.red),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _repositories.length, // Número de repositórios.
                itemBuilder: (context, index) {
                  final repo = _repositories[index]; // Repositório atual.
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: const Color(0xFF161B22),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(repo.ownerAvatarUrl), // Avatar do proprietário.
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              repo.name, // Nome do repositório.
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Indica se o repositório é público ou privado.
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
                      subtitle: Text(
                        repo.description ?? '', // Descrição do repositório (ou vazio).
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.yellow, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${repo.stargazersCount}', // Número de estrelas.
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
