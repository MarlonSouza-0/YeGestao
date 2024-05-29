import 'package:flutter/material.dart';

class TelaIMC extends StatelessWidget {
  const TelaIMC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações do Usuário'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserInfoItem(
              title: 'Peso',
              date: '01/01/2024',
              value: '70 kg',
              backgroundColor: Color(0xff07a676),
            ),
            SizedBox(height: 20),
            UserInfoItem(
              title: 'Altura',
              date: '01/01/2024',
              value: '1.70 m',
              backgroundColor: Color(0xff07a676),
            ),
            SizedBox(height: 20),
            UserInfoItem(
              title: 'IMC',
              date: '01/01/2024',
              value: '24.2',
              backgroundColor: Color(0xff07a676),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final String title;
  final String date;
  final String value;
  final Color backgroundColor;

  const UserInfoItem({
    super.key,
    required this.title,
    required this.date,
    required this.value,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              const Expanded(
                flex: 1,
                child: Text(
                  'Data:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  '$title:',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}