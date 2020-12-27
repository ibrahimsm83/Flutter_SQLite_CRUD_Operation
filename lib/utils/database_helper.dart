

import 'dart:io';

//import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crudoperation/models/contact.dart';

class DatabaseHelper{

  static const _databaseName='ContactData.db';
  static const _databaseVersion= 1;

//private constractor of DBH class
      //DataBaseHelper._PrivateConstractor();
      // or write another way
  DatabaseHelper._();//singleton class matlb jis class ka ak object ho 
  static final DatabaseHelper instanace=DatabaseHelper._();

  Database _database;
  //Future retun type 
  Future<Database> get database async{
    if(_database != null) return _database;
        
        _database= await _initDatabase();
        return _database;
  }
  //access the app directory of app using this code
  //getApp fun return Future datatype
      _initDatabase() async{
        Directory dataDirectory = await getApplicationDocumentsDirectory();
        String dbPath= join(dataDirectory.path,_databaseName);//path.dart pkg import 
        print(dbPath);
        return await openDatabase(dbPath,
        version:_databaseVersion,onCreate: _onCreateDB );//null =_onCreate
      }
       //create new database table ,
       //this fun is initial schema of our DB
       //INTEGER PRIMARY KEY AUTOINCREMENT,
      Future _onCreateDB(Database db,int version)async{
          await db.execute(
            '''
          
          CREATE TABLE ${Contact.tblContact}(
              ${Contact.colid} INTEGER PRIMARY KEY,
              ${Contact.colName} TEXT NOT NULL,
              ${Contact.colMobile} TEXT NOT NULL

          )
          '''
          );

       }

       //CRUD operation 

 //1 insert opeeration
       Future<int> insertContact(Contact contact)async{
         Database db=await database;
         return await db.insert(Contact.tblContact, contact.toMap());
       }
       //Now call above fun in main.dart files

 //contact - update
Future<int> updateContact(Contact contact) async {
  Database db = await database;
  return await db.update(Contact.tblContact, contact.toMap(),
      where: '${Contact.colid}=?', whereArgs: [contact.id]);
}

//contact - delete
//delete record with respect crossponding id
Future<int> deleteContact(int id) async {
  Database db = await database;
  return await db.delete(Contact.tblContact,
      where: '${Contact.colid}=?', whereArgs: [id]);
}

//FetchContacts values 
Future<List<Contact>>fetchContacts()async{
   Database db=await database;
   List<Map>contacts =await db.query(Contact.tblContact);
   return contacts.length==0
    ? []
   :contacts.map((e) => Contact.fromMap(e)).toList();//callback map function
}

}
