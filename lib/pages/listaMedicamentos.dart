import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao/pages/medicamentos.dart'; // Importando a classe de Medicamentos

class ListaMedicamentos extends StatefulWidget {
  final String idUsuario;
  const ListaMedicamentos({super.key, required this.idUsuario});

  @override
  State<ListaMedicamentos> createState() => _ListaMedicamentosState();
}

class _ListaMedicamentosState extends State<ListaMedicamentos> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> refresh() async {
    setState(() {});
  }

  void formularioMedicamento() {
    final formKey = GlobalKey<FormState>();
    TextEditingController nomeRemedioController = TextEditingController();
    TextEditingController horarioController = TextEditingController();
    TextEditingController periodoController = TextEditingController();
    TextEditingController dataController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Adicionar Medicamento",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextFormField(
                      controller: nomeRemedioController,
                      decoration: const InputDecoration(
                        labelText: "Nome do Remédio",
                        // Adicione os outros campos de entrada de texto aqui
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: horarioController,
                      decoration: const InputDecoration(
                        labelText: "Horário",
                        // Adicione os outros campos de entrada de texto aqui
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: periodoController,
                      decoration: const InputDecoration(
                        labelText: "Período",
                        // Adicione os outros campos de entrada de texto aqui
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: dataController,
                      decoration: const InputDecoration(
                        labelText: "Data",
                        // Adicione os outros campos de entrada de texto aqui
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(
                              color: Color.fromRGBO(71, 146, 121, 0.819),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await firestore
                                  .collection("Usuários")
                                  .doc(widget.idUsuario)
                                  .collection('Medicamentos')
                                  .add({
                                "nomeRemedio": nomeRemedioController.text,
                                "horario": horarioController.text,
                                "periodo": periodoController.text,
                                "data": dataController.text,
                              });

                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            "Salvar",
                            style: TextStyle(
                              color: Color.fromRGBO(71, 146, 121, 0.819),
                            ),
                          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Medicamentos",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(71, 146, 121, 0.612),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore
            .collection("Usuários")
            .doc(widget.idUsuario)
            .collection('Medicamentos')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar os dados"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Sem medicamentos cadastrados"));
          }

          Map<String, List<Medicamentos>> medicamentosPorEspecialidade = {};
          for (var doc in snapshot.data!.docs) {
            var data = doc.data();
            Medicamentos medicamento = Medicamentos.fromMap(data);
            if (!medicamentosPorEspecialidade
                .containsKey(medicamento.nomeRemedio)) {
              medicamentosPorEspecialidade[medicamento.nomeRemedio] = [];
            }
            medicamentosPorEspecialidade[medicamento.nomeRemedio]!
                .add(medicamento);
          }

          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              children: medicamentosPorEspecialidade.entries.map((entry) {
                return ExpansionTile(
                  title: ListTile(
                    title: Text(entry.key),
                  ),
                  children: entry.value.map((medicamento) {
                    return ListTile(
                      title: Text("Data: ${medicamento.data}"),
                      subtitle: Text(
                          "Horário: ${medicamento.horario}\nPeríodo: ${medicamento.periodo}"),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: formularioMedicamento,
        backgroundColor: const Color.fromRGBO(71, 146, 121, 0.612),
        child: const Icon(Icons.add),
      ),
    );
  }
}
