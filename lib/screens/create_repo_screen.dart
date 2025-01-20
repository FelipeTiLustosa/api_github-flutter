import 'package:flutter/material.dart';
import '../services/github_service.dart';

// Tela para criação de repositórios no GitHub.
class CreateRepoScreen extends StatefulWidget {
  final Function? onRepositoryCreated; // Adicione este callback
  
  const CreateRepoScreen({
    Key? key, 
    this.onRepositoryCreated
  }) : super(key: key);

  @override
  _CreateRepoScreenState createState() => _CreateRepoScreenState();
}

class _CreateRepoScreenState extends State<CreateRepoScreen> {
  final GitHubService _gitHubService = GitHubService(); // Serviço para comunicação com a API.
  final _formKey = GlobalKey<FormState>(); // Chave para gerenciar o estado do formulário.
  final _nameController = TextEditingController(); // Controlador do campo "Nome".
  final _descriptionController = TextEditingController(); // Controlador do campo "Descrição".
  bool _isPrivate = false; // Estado do switch "Repositório Privado".
  bool _isLoading = false; // Indicador de carregamento.

  // Método para criar um novo repositório.
  Future<void> _createRepository() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    await _gitHubService.createRepository(
      name: _nameController.text,
      description: _descriptionController.text,
      isPrivate: _isPrivate,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Repositório criado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Chama o callback se existir
      widget.onRepositoryCreated?.call();
      
      Navigator.pop(context);
    }
  } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar repositório: $e'),
            backgroundColor: Colors.red, // Exibe mensagem de erro.
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false); // Finaliza o estado de carregamento.
    }
  }

  // Monta a interface da tela de criação.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // Cor de fundo escura (tema GitHub).
      appBar: AppBar(
        title: const Text('Criar Repositório'),
        backgroundColor: Colors.transparent, // Torna o fundo do AppBar transparente.
        elevation: 0,
      ),
      body: Form(
        key: _formKey, // Vincula o formulário à chave.
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Campo para o nome do repositório.
            TextFormField(
              controller: _nameController, // Controlador associado.
              style: const TextStyle(color: Colors.white), // Estilo do texto.
              decoration: InputDecoration(
                labelText: 'Nome do Repositório',
                labelStyle: const TextStyle(color: Colors.white70),
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
                prefixIcon: const Icon(Icons.folder, color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF161B22), // Cor do fundo do campo.
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um nome'; // Valida que o campo não esteja vazio.
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Campo para a descrição do repositório.
            TextFormField(
              controller: _descriptionController, // Controlador associado.
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Descrição',
                labelStyle: const TextStyle(color: Colors.white70),
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
                prefixIcon: const Icon(Icons.description, color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF161B22),
              ),
              maxLines: 3, // Permite até 3 linhas para a descrição.
            ),
            const SizedBox(height: 16),
            // Switch para selecionar se o repositório será privado ou público.
            SwitchListTile(
              title: const Text(
                'Repositório Privado',
                style: TextStyle(color: Colors.white),
              ),
              value: _isPrivate, // Estado do switch.
              onChanged: (value) => setState(() => _isPrivate = value),
            ),
            const SizedBox(height: 24),
            // Botão para criar o repositório.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createRepository, // Bloqueia se estiver carregando.
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xFF238636), // Cor do botão (verde GitHub).
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white) // Indicador de carregamento.
                    : const Text(
                        'Criar Repositório',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
