import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _recuperarBancoDados() async {
    final caminhoBandoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBandoDados, "banco.db");

    var bd = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sql =
          "create table usuarios (id integer PRIMARY KEY AUTOINCREMENT, nome varchar, idade integer)";
      db.execute(sql);
    });

    return bd;
    // print("aberto " + retorno.isOpen.toString());
  }

  _salvar() async {
    print("salvar");
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome": "Tobias",
      "idade": 1,
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("id >> " + id.toString());
  }

  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();
    String sql = "select nome from usuarios";
    List usuarios = await bd.rawQuery(sql);
    print(usuarios);
  }

  _excluirUsuario(int id) async {
    Database bd = await _recuperarBancoDados();
    bd.delete(
      "usuarios",
      where: "id = ?",
      whereArgs: [id]
    );
  }

  _atualizarUsuario(int id) async {
    Map<String, dynamic> dadosUsuario = {
      "nome": "Cachorro Tobias",
      "idade": 1,
    };

    Database bd = await _recuperarBancoDados();
    bd.update(
      "usuarios",
      dadosUsuario
    );
  }

  @override
  Widget build(BuildContext context) {
    _listarUsuarios();
    return Container();
  }
}
