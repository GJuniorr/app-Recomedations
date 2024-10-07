// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  final String jsonUrl = 'https://firebasestorage.googleapis.com/v0/b/watch-76784.appspot.com/o/atl.json?alt=media&token=38fc38b4-a97b-407f-9d19-de6e0de987c3';

  Future<void> checkForUpdates(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(jsonUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final String latestVersion = jsonData['version'];
        final String apkUrl = jsonData['url'];

        // Compare com a versão atual do aplicativo
        String currentVersion = '1.0.2'; // Coloque aqui a versão atual do seu aplicativo

        if (latestVersion != currentVersion) {
          // Notifique o usuário sobre a nova versão
          _showUpdateDialog(context, apkUrl);
        }
      } else {
        print('Erro ao obter atualizações: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao verificar atualizações: $e');
    }
  }

  void _showUpdateDialog(BuildContext context, String apkUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atualização disponível'),
          content: const Text('Uma nova versão do aplicativo está disponível. Deseja atualizar?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Atualizar'),
              onPressed: () async {
                // Converta a string apkUrl para Uri
                final Uri uri = Uri.parse(apkUrl);
                try {
                  // Tenta abrir o link diretamente
                  await launchUrl(uri);
                  print('Funcionou?');
                } catch (e) {
                  // Captura qualquer erro ao tentar abrir o link
                  print('Erro ao tentar abrir o link: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Não foi possível abrir o link.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
