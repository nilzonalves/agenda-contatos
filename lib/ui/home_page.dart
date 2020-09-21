import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper =  new ContactHelper(); // nessa hora, será possível instanciar apenas 1 objeto, devido a classe ContactHelper ser singleton
  List<Contact> contacts = new List();


  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index){
            return _contactCard(context, index);
          }
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        color: Colors.white70,
        child: Padding( // um filho dentro do outro, pois se nao, nao seria possível adicionar o padding.
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null ?
                        FileImage(File(contacts[index].img)) :
                        AssetImage("images/person.png")
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contacts[index].name ?? "",
                    style: TextStyle(fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                    ),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18.0)
                    ),
                    Text(contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 22.0)
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showContactPage(contact: contacts[index]);
      },
    );
  }

  void _showContactPage({Contact contact}) async {//passando um contato OU NÃO para a função.
    //fazendo dessa forma na linha abaixo, mostra que está recebendo um retorno, dos dados, da tela CONTACT PAGE.
    final recContact = await Navigator.push(context,
      MaterialPageRoute(builder: (context)=>ContactPage(contact: contact,))
    );
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      }else{
        await helper.saveContacts(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){ //função para carregar todos os contatos.
    helper.getAllContacts().then((list){ //carrega a lista de contatos do banco, e adiciona na lista "contacts" criada no inicio.
      setState(() {
        contacts = list;
      });
    });
  }

}
