import 'dart:io';
import 'package:gestao/models/Exame.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class FormularioExame extends StatefulWidget {
  final String idUsuario;
  const FormularioExame({super.key, required this.idUsuario});
  @override
  State<StatefulWidget> createState() {
    return FormularioExameState();
  }
}

class FormularioExameState extends State<FormularioExame> {
  // File? _fotoSelecionada;
  var _arquivo;
  var _arquivoNome;
  var caminho;
  bool tipoFile = false;

  Future _fotoCamera() async {
    final foto = await ImagePicker().pickImage(source: ImageSource.camera);
    if (foto == null) return;
    setState(() {
      _arquivo = File(foto.path);
      _arquivoNome = foto.name;
      tipoFile = true;
    });
  }

//sem permissão para pegar arquivos por enquanto, não funciona
  void selecionarArquivos() async {
    const permissao = Permission.storage;
    if (permissao != PermissionStatus.granted) {
      await permissao.request();
    } else {
      FilePickerResult? arquivoFinal = await FilePicker.platform.pickFiles();
      if (arquivoFinal != null) {
         if (await permissao.isGranted) {
          PlatformFile file = arquivoFinal.files.first;
          print(file.name);
          print(file.bytes);
          print(file.extension);
          print(file.path);
          caminho = file.path;
          _arquivo = File(caminho);
          _arquivoNome = file.name;
        }
      } else {
        print('erro');
      }
    }
  }

  final TextEditingController _controladorNomeExame = TextEditingController();
  final TextEditingController _controladorDataExame = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Adicionar Exame',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(71, 146, 121, 0.612),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controladorNomeExame,
                decoration: const InputDecoration(
                    labelText: 'Nome Exame', hintText: 'Ex: Exame de Sangue'),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _controladorDataExame,
                decoration: const InputDecoration(
                    labelText: "Data do Exame",
                    hintText: "Ex: 24/04/2024",
                    icon: Icon(Icons.calendar_today)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    selecionarArquivos();
                    // File? foto = _fotoSelecionada;
                  },
                  icon: const Icon(Icons.attach_file),
                  tooltip: 'Selecionar Arquivo',
                ),
                IconButton(
                  onPressed: () {
                    _fotoCamera();
                  },
                  icon: const Icon(Icons.camera_alt),
                  tooltip: 'Abrir Câmera',
                ),
              ],
            ),
            const SizedBox(
              height: 340,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8),
              child: ElevatedButton(
                onPressed: () async {
                  final String nome = _controladorNomeExame.text;
                  final String dia = _controladorDataExame.text;
                  final arquivoAtual = _arquivoNome;
                  final arquivo = _arquivo;
                  final path = firestore
                      .collection('usuários')
                      .where('id', isEqualTo: widget.idUsuario)
                      .get();
                  print(path);
                  print(arquivoAtual);
                  print(nome);
                  print(dia);
                  if (arquivoAtual != null) {
                    final formularioCriado = Exame(
                      data: dia,
                      nomeExame: nome,
                      arquivo: arquivoAtual,
                      imagem: tipoFile,
                    );
                    firestore
                        .collection('Usuários')
                        .doc(widget.idUsuario)
                        .collection('Exames')
                        .add(formularioCriado.toMap());
                    debugPrint('Histórico Exame');
                    debugPrint('$formularioCriado');
                    final arquivoEnviado = storage.ref('Exames/$arquivoAtual');
                    await arquivoEnviado.putFile(arquivo);
                    Navigator.pop(context, formularioCriado);
                  } else {
                    print('erro');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(71, 146, 121, 0.612),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 140.0, vertical: 10.0),
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}