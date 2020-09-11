import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  //ÉSTÁ ENTRE CHAVES, POIS É UM PARÂMETRO OPCIONAL.
  ContactPage({this.contact}); // serve para, caso na tela anterior, clique no contato, e editar, as info do contato, vem pra essa tela.

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Contact _editedContact;

  @override
  void initState() {
    super.initState();
    if(widget.contact == null){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.save),
      ),
    );
  }

}
