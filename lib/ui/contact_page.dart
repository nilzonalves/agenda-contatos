import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  //ÉSTÁ ENTRE CHAVES, POIS É UM PARÂMETRO OPCIONAL.
  ContactPage({this.contact}); // Este CONSTRUTOR, serve para, caso na tela anterior, clique no contato, e editar, as info do contato, vem pra essa tela.

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Contact _editedContact;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if(widget.contact == null){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text  = _editedContact.phone;
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
        onPressed: (){
          if(_editedContact.name != null && _editedContact.name.isNotEmpty){
            Navigator.pop(context, _editedContact); // o POP remove a tela, e volta para a anterior.
          }else{
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null ?
                        FileImage(File(_editedContact.img)) :
                        AssetImage("images/person.png")
                    )
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(labelText: "Nome: "),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedContact.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "E-mail: "),
              onChanged: (text){
                _userEdited = true;
                _editedContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Telefone: "),
              onChanged: (text){
                _userEdited = true;
                  _editedContact.phone = text;
              },
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      )
    );
  }

}
