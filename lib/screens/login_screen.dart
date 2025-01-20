import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';

// Tela de login no GitHub Explorer.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(); // Controlador do campo de usuário.
  final _tokenController = TextEditingController(); // Controlador do campo de token.
  final _storage = const FlutterSecureStorage(); // Armazena credenciais de forma segura.
  bool _isLoading = false; // Indica se o login está em andamento.

  // Valida as credenciais fornecidas através da API do GitHub.
  Future<bool> _validateGitHubCredentials(String username, String token) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/user'),
      headers: {
        'Authorization': 'token $token',
        'Accept': 'application/vnd.github.v3+json',
      },
    );
    return response.statusCode == 200; // Retorna true apenas para resposta bem-sucedida.
  }

  // Executa o processo de login e redirecionamento.
  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _tokenController.text.isEmpty) {
      _showError('Preencha todos os campos'); // Notifica o usuário sobre campos vazios.
      return;
    }

    setState(() => _isLoading = true);

    try {
      final isValid = await _validateGitHubCredentials(
        _usernameController.text,
        _tokenController.text,
      );

      if (!isValid) {
        _showError('Credenciais inválidas'); // Erro caso as credenciais sejam incorretas.
        return;
      }

      // Salva o nome do usuário e o token localmente e de forma segura.
      await _storage.write(key: 'github_username', value: _usernameController.text);
      await _storage.write(key: 'github_token', value: _tokenController.text);

      // Redireciona o usuário à próxima tela.
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      _showError('Erro ao fazer login: Verifique sua conexão'); // Erro genérico para problemas de conexão.
    } finally {
      setState(() => _isLoading = false); // Garante que o carregamento será desativado ao final.
    }
  }

  // Exibe um SnackBar para mensagens de erro.
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Monta a interface visual da tela.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // Fundo escuro.
      appBar: AppBar(
        title: const Text('Login GitHub Explorer'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Ícone central.
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                FontAwesomeIcons.github,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'GitHub Explorer', // Título principal.
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            // Campo de nome de usuário.
            TextField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nome de usuário',
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
                prefixIcon: const Icon(Icons.person, color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF161B22),
              ),
            ),
            const SizedBox(height: 20),
            // Campo de token.
            TextField(
              controller: _tokenController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Token do GitHub',
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
                prefixIcon: const Icon(Icons.key, color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF161B22),
              ),
              obscureText: true, // Oculta o texto digitado.
            ),
            const SizedBox(height: 30),
            // Botão de login.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login, // Desabilitado enquanto estiver carregando.
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xFF238636), // Cor do botão.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white) // Indicador de carregamento.
                    : const Text(
                        'Entrar',
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
