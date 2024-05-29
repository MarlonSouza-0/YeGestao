import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:gestao/models/IMC.dart';

class ListaPesoAltura extends StatefulWidget {
  final String idUsuario;
  const ListaPesoAltura({super.key, required this.idUsuario});

  @override
  State<ListaPesoAltura> createState() => _ListaPesoAlturaState();
}

class _ListaPesoAlturaState extends State<ListaPesoAltura> {
  List<IMC> IMCAferido = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    refresh(); // Carregar os dados ao inicializar a página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context); // Navega para a tela anterior
          },
        ),
        title: const Text(
          "Medidas",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(71, 146, 121, 0.612),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formularioIMC();
        },
        backgroundColor: const Color.fromRGBO(71, 146, 121, 0.612),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: (IMCAferido.isEmpty)
    ? const Center(
        child: Text("Nenhuma medida aferida encontrada"),
      )
    : RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(100.0),
              1: FixedColumnWidth(160.0), // Reduzindo a largura da coluna Altura
              2: FlexColumnWidth(), // A coluna Status agora terá mais espaço
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(color: Color(0xFF7b8d93)),
                children: [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Data',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Peso',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Altura',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              for (var imc in IMCAferido)
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        color:const Color(0xFFbec5c7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            imc.data,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: const Color(0xFF7b8d93),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            imc.peso,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: const Color(0xFFbec5c7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            imc.altura,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
     }


  void formularioIMC() {
  String labelTitle = "Adicionar IMC";
  String labelConfirmationButton = "Salvar";
  String labelSkipButton = "Cancelar";

  TextEditingController dataController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  final formKey = GlobalKey<FormState>(); // Chave global para o formulário

  showModalBottomSheet(
    context: context,
    isScrollControlled:
        true, // Permite que o conteúdo role quando o teclado aparece
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // Ajusta o padding com base no teclado
        ),
        child: Container(
          height: MediaQuery.of(context).size.height *
              0.6, // Reduz a altura do container
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(labelTitle,
                      style: Theme.of(context).textTheme.headlineSmall),
                  TextFormField(
                    controller: dataController,
                    decoration: const InputDecoration(
                      labelText: "Data",
                      labelStyle: TextStyle(
                          color: Colors
                              .black), // Cor do label quando não está focado
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(71, 146, 121, 0.612)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .grey), // Cor da linha quando não está focado
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .red), // Cor da linha em caso de erro e focado
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.red), // Cor da linha em caso de erro
                      ),
                    ),
                    cursorColor:
                        const Color.fromRGBO(71, 146, 121, 0.612), // Cor do cursor
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a data.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: pesoController,
                    decoration: const InputDecoration(
                      labelText: "Peso (kg)",
                      labelStyle: TextStyle(
                          color: Colors
                              .black), // Cor do label quando não está focado
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(71, 146, 121, 0.612)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .grey), // Cor da linha quando não está focado
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .red), // Cor da linha em caso de erro e focado
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.red), // Cor da linha em caso de erro
                      ),
                    ),
                    cursorColor:
                        const Color.fromRGBO(71, 146, 121, 0.612), // Cor do cursor
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o peso.';
                      }
                      final num? peso = num.tryParse(value);
                      if (peso == null || peso <= 0) {
                        return 'Insira um peso válido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: alturaController,
                    decoration: const InputDecoration(
                      labelText: "Altura (cm)",
                      labelStyle: TextStyle(
                          color: Colors
                              .black), // Cor do label quando não está focado
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(71, 146, 121, 0.612)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .grey), // Cor da linha quando não está focado
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .red), // Cor da linha em caso de erro e focado
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.red), // Cor da linha em caso de erro
                      ),
                    ),
                    cursorColor:
                        const Color.fromRGBO(71, 146, 121, 0.612), // Cor do cursor
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                                              if (value == null || value.isEmpty) {
                        return 'Por favor, insira a altura.';
                      }
                      final num? altura = num.tryParse(value);
                      if (altura == null || altura <= 0) {
                        return 'Insira uma altura válida.';
                      }
                      return null;
                     }
                      return null;},
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(labelSkipButton,
                            style: const TextStyle(
                                color:
                                    Color.fromRGBO(71, 146, 121, 0.819))),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            // Se o formulário for válido, continue com a lógica
                            String data = dataController.text;
                            String peso = pesoController.text;
                            String altura = alturaController.text;

                            // Convertendo altura para metros
                            double alturaMetros = double.parse(altura) / 100;

                            IMC imc = IMC(
                              id: const Uuid().v1(),
                              data: data,
                              peso: peso,
                              altura: alturaMetros.toString(),
                              status: _determineIMCStatus(peso, alturaMetros.toString())
                            );

                            await firestore
                                .collection('Usuários')
                                .doc(widget.idUsuario)
                                .collection('IMC')
                                .add(imc.toMap());

                            setState(() {
                              IMCAferido.insert(
                                  0, imc); // Adicione ao início da lista
                            });

                            Navigator.pop(context);
                          }
                        },
                        child: Text(labelConfirmationButton,
                            style: const TextStyle(
                                color:
                                    Color.fromRGBO(71, 146, 121, 0.819))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

                        
                       


  Future<void> refresh() async {
    print('Iniciando refresh...'); // Debug log
    List<IMC> temp = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection("Usuários")
          .doc(widget.idUsuario)
          .collection('IMC')
          .orderBy('data',
              descending: true) // Ordene por data, mais recente primeiro
          .get();

      for (var doc in snapshot.docs) {
        print('Documento encontrado: ${doc.data()}'); // Debug log
        temp.add(IMC.fromMap(doc.data()));
      }

      setState(() {
        IMCAferido = temp;
      });
    } catch (e) {
      print('Erro ao recuperar dados: $e'); // Debug log
    }
  }

  String _determineIMCStatus(String peso, String altura) {
    double pesoValue = double.tryParse(peso) ?? 0;
    double alturaValue = double.tryParse(altura) ?? 0;

    if (alturaValue <= 0 || pesoValue <= 0) {
      return "Desconhecido";
    }

    double imc = pesoValue / (alturaValue * alturaValue);

    if (imc < 18.5) {
      return "Magro ou baixo peso";
    } else if (imc < 24.9) {
      return "Normal";
    } else if (imc < 29.9) {
      return "Sobrepeso";
    } else if (imc < 34.9) {
      return "Obesidade 1";
    } else if (imc < 39.9) {
      return "Obesidade 2";
    } else {
      return "Obesidade grave";
    }
  }

  // String _getIMCStatus(String peso, String altura) {
  //   return _determineIMCStatus(peso, altura);
  // }
}