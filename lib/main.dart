import 'package:flutter/material.dart';
import 'services/linha_service.dart';
import 'services/percurso_service.dart';
import 'models/percurso_model.dart';
import 'models/linha_info_model.dart'; // Importe o modelo LinhaOnibus

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DFTrans',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LinhaService _linhaService = LinhaService();
  final PercursoService _percursoService = PercursoService();
  final TextEditingController _controller = TextEditingController();

  List<LinhaOnibus> linhas = [];
  int currentIndex = 0;
  Percurso? percurso;
  String? errorMessage;
  bool isCircular = false;

  void _searchLinha() async {
    String numero = _controller.text;
    if (numero.isEmpty) {
      setState(() {
        errorMessage = 'Por favor, insira um número de linha.';
      });
      return;
    }

    try {
      setState(() {
        errorMessage = null;
        linhas.clear();
        percurso = null;
        isCircular = false;
      });

      linhas = await _linhaService.procurarLinhaPorNumero(numero);

      if (linhas.isNotEmpty) {
        // Checar se é "CIRCULAR"
        if (linhas.length == 1 && linhas.first.sentido == 'CIRCULAR') {
          isCircular = true;
          _fetchPercurso(linhas.first.sequencial);
        } else {
          _fetchPercurso(linhas[currentIndex].sequencial);
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro: $e';
      });
    }
  }

  Future<void> _fetchPercurso(int sequencial) async {
    try {
      Percurso result = await _percursoService.buscarPercurso(sequencial.toString());
      setState(() {
        percurso = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao buscar percurso: $e';
      });
    }
  }

  void _trocarSentido() {
    if (linhas.length > 1) {
      setState(() {
        currentIndex = (currentIndex + 1) % linhas.length;
        _fetchPercurso(linhas[currentIndex].sequencial);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DFTrans'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Número da Linha',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchLinha,
              child: const Text('Pesquisar'),
            ),
            const SizedBox(height: 20),
            errorMessage != null
                ? Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
            )
                : Container(),
            Expanded(
              child: percurso == null
                  ? const Center(child: Text('Insira um número de linha para pesquisar'))
                  : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Percurso:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: percurso!.coordinates.length,
                        itemBuilder: (context, index) {
                          return Text(
                            'Coordenada ${index + 1}: ${percurso!.coordinates[index]}',
                            style: const TextStyle(fontSize: 16),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      !isCircular && linhas.length > 1
                          ? ElevatedButton(
                        onPressed: _trocarSentido,
                        child: const Text('Trocar Sentido'),
                      )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
