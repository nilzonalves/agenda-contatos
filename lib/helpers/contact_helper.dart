import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {
  // essa classe terá apenas 1 objeto. Não terá várias intancias. Isso é um padrão chamado Singleton.
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  //declaração do Banco de Dados
  Database _db;
  //inicializando o banco de dados
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath(); //pegou o caminho do banco
    final path = join(databasePath,
        "contactsnew.db"); //pegar o arquivo que vai estar armazenando o bd. Precisa de Bib.

    //abrindo o banco de dados
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(//código responsável por criar a tabela.
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT,"
          "$phoneColumn TEXT, $imgColumn TEXT)");
    });
  }

  Future<Contact> saveContacts(
      Contact contact) async /*FUTURE porque é função asyncrona*/ {
    // essa função vai receber o contato que vai ser salvo.
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    //obter os dados de um contato
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    //deletar contato
    Database dbContact = await db;
    await await dbContact.delete(contactTable,
        where: "$idColumn = ?",
        whereArgs: [id]); //deleta o contato, onde idColum == id
  }

  Future<int> updateContact(Contact contact) async {
    //atualizar contato
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(),
        where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async{
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    //pra cada MAPA na lista de mapa, ´pega o MAPA e adiciona lista de contados.
    List<Contact> listContact = List();
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async{ //retorando a quantidade de contatos na tabela.
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  //fechar banco de dados.
  Future close() async{
    Database dbContact = await db;
    dbContact.close();
  }
}

class Contact {
  // essa classe vai definir tudo que o contato vai armazenar
  int id;
  String name;
  String email;
  String phone;
  String img; // nao tem como armazenar imagem no BD, então, armazena no celular, e salva o caminho.

  Contact();

  Contact.fromMap(Map map) {
    // pegou as informações do mapa, e passou para o contato
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    // Aqui pega os dados, e tranforma em um mapa.
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
    };
    if (id != null) {
      // o banco vai dar o ID, se não, cai neste if.
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact (id: $id, name: $name, email: $email, phone: $phone, img: $img";
  }
}
