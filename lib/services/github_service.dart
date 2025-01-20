import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/repository.dart';

class GitHubService {
  // A URL base da API do GitHub, usada em todas as requisições
  final String _baseUrl = 'https://api.github.com';

  // Método para obter os repositórios do usuário autenticado
  Future<List<Repository>> getRepositories(String token) async {
    // Enviando a requisição GET para buscar todos os repositórios
    final response = await http.get(
      Uri.parse('$_baseUrl/user/repos?visibility=all'),
      headers: {
        // Enviando o token no cabeçalho para autenticação
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github+json',
      },
    );

    // Checando se o código da resposta é 200 (OK)
    if (response.statusCode == 200) {
      // Decodificando a resposta JSON e mapeando para uma lista de objetos Repository
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Repository.fromJson(json)).toList();
    } else {
      // Caso o status não seja 200, lança uma exceção
      throw Exception('Failed to load repositories');
    }
  }

  // Método para obter os repositórios de um usuário específico, a partir do nome de usuário
  Future<List<Repository>> getUserRepositories(String username) async {
    // Realizando uma requisição GET para o endpoint de repositórios do usuário
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$username/repos?visibility=all'),
      headers: {
        'Accept': 'application/vnd.github+json', // Indicando a aceitação do formato JSON
      },
    );
    
    // Checando se a resposta foi bem-sucedida (código 200)
    if (response.statusCode == 200) {
      // Decodificando a resposta e retornando os repositórios do usuário como objetos Repository
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Repository.fromJson(json)).toList();
    } else {
      // Caso o usuário não seja encontrado ou aconteça outro erro, lança uma exceção
      throw Exception('Usuário não encontrado');
    }
  }

  // Método para criar um novo repositório para o usuário autenticado
  Future<Repository> createRepository({
    required String name,          // Nome do repositório
    String? description,           // Descrição do repositório (opcional)
    bool isPrivate = false,        // Definir se o repositório será privado (opcional, padrão false)
  }) async {
    // Lendo o token de autenticação do armazenamento seguro
    final token = await const FlutterSecureStorage().read(key: 'github_token');
    
    // Enviando uma requisição POST para criar o repositório no GitHub
    final response = await http.post(
      Uri.parse('$_baseUrl/user/repos'),
      headers: {
        'Accept': 'application/vnd.github+json',  // Especificando o formato de resposta
        'Authorization': 'Bearer $token',  // Passando o token de autenticação
        'Content-Type': 'application/json',  // Definindo o tipo de conteúdo como JSON
      },
      body: json.encode({
        'name': name,                    // Passando o nome do repositório
        'description': description,       // Passando a descrição do repositório
        'private': isPrivate,             // Passando o status de privacidade do repositório
      }),
    );

    // Checando se a requisição foi bem-sucedida (status 201 Created)
    if (response.statusCode != 201) {
      // Caso não tenha sido bem-sucedido, lança uma exceção com o erro retornado pela API
      throw Exception('Falha ao criar repositório: ${response.body}');
    }

    // Se foi bem-sucedido, cria um objeto Repository a partir da resposta JSON
    return Repository.fromJson(json.decode(response.body));
  }

  // Método para obter as informações do usuário autenticado, usando o token
  Future<Map<String, dynamic>> getUserInfo(String token) async {
    // Realizando uma requisição GET para obter os dados do usuário
    final response = await http.get(
      Uri.parse('$_baseUrl/user'),
      headers: {
        'Authorization': 'Bearer $token',  // Passando o token de autenticação
        'Accept': 'application/vnd.github+json',  // Especificando o formato JSON na resposta
      },
    );

    // Verificando o status da resposta
    if (response.statusCode == 200) {
      // Se a requisição for bem-sucedida, retorna os dados do usuário em formato JSON
      return json.decode(response.body);
    } else {
      // Caso ocorra um erro, lança uma exceção informando que falhou ao carregar as informações do usuário
      throw Exception('Failed to load user info');
    }
  }
}
