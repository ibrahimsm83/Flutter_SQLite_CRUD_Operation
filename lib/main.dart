import 'package:crudoperation/models/contact.dart';
import 'package:crudoperation/utils/database_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite CRUD',
      theme: ThemeData(
       
        primarySwatch: Colors.grey,
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SQLite CRUD BY IBRAHIM'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;
  Contact _contact = Contact();//call constractor
  List<Contact> _contacts=[];
  DatabaseHelper _dbHelper;


final _formKey=GlobalKey<FormState>();//working as primary key or unique
final _ctrlName=TextEditingController();
final _ctrlMobile=TextEditingController();
  
  

  @override
  //on submit call setstate and call insert fun
  void initState(){
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instanace;
    });
    _refreshContactList();
  }
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.white,
        title: Center(child: Text(widget.title,
        style: TextStyle(),
        
        )),
      ),
      body: Center(
        
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
           _form(),_list()
          ],
        ),
      ),
    
    );
  }
     
      //_form()
     _form()=>Container(
         color: Colors.white,
         padding: EdgeInsets.symmetric(vertical:15,horizontal:30),
         child: Form(
           key: _formKey,
           child: Column(
                children: [
                  TextFormField(
                    //add controller in textinput field
                    controller: _ctrlName,
                    //for placeholder usedecoration
                    decoration: InputDecoration(labelText: 'Full Name'),
                    onSaved: (val)=>setState(()=>_contact.name=val),
                    //validation 
                    validator: (val)=>(val.length==0?'This field is required':null),
                  ),
                  TextFormField(
                    controller: _ctrlMobile,
                   decoration: InputDecoration(labelText: 'Mobile'),
                   onSaved: (val)=>setState(()=>_contact.mobile=val),
                   //validation 
                    validator: (val)=>(val.length<10?'Atleast 10 character required':null),

                  ),
                  Container(
                        margin: EdgeInsets.all(10.0),
                        child: RaisedButton(
                          onPressed: ()=> _onSubmit(),
                          child: Text("Submit"),
                          textColor: Colors.white,
                          color: Colors.blueGrey,
                          ),
                  ),
                ],
           ),
         ),);

        //FetchContacts call in main.dart
        _refreshContactList()async{
         
         List<Contact> x=await _dbHelper.fetchContacts();
          setState(() {
            _contacts=x;
          });
        }

   _onSubmit()async{
          var form =_formKey.currentState;
          if(form.validate()) {
          form.save();//callback fun inside text form field
           //if condit use for update                               //insert directly in  DB
          if(_contact.id==null)
            await _dbHelper.insertContact(_contact);//this line save formfield values in dbtable here
          else
          await _dbHelper.updateContact(_contact);
          _refreshContactList();//view
          /*
          //Remove this fun and directely insert in DB
          setState(() {
           // _contacts.add(_contact);
            _contacts.add(Contact(id: null,name: _contact.name,mobile: _contact.mobile));
          });*/
         // form.reset();
         _resetForm();
            //print(_contact.name);
             
          }
   }

   _resetForm(){
     setState(() {
       _formKey.currentState.reset();
       _ctrlName.clear();
       _ctrlMobile.clear();
       _contact.id=null;
     });
   }
/*
abc(){
  return 5,
}
*/ 
   //_listView()


_list() => Expanded(
  child: Card(
    margin:EdgeInsets.fromLTRB(20, 30, 20, 0),
    child: ListView.builder(
      padding: EdgeInsets.all(8),
      itemBuilder:(context,index){
              return Column(
                 children: [
                   ListTile(
                     leading: Icon(Icons.account_circle,color:Colors.blueGrey,size: 40.0,),
                     title: Text(_contacts[index].name.toUpperCase(),
                     
                     style: TextStyle(color:Colors.blue,fontWeight: FontWeight.bold),),
                     subtitle: Text(_contacts[index].mobile,
                     style: TextStyle(color:Colors.grey,),),
                     //delete icons
                     trailing: IconButton(
                       icon: Icon(Icons.delete_sweep,color: Colors.grey,),
                        onPressed: ()async{
         await _dbHelper.deleteContact(_contacts[index].id);
         _resetForm();
         _refreshContactList();
                        }),
                     //update values
                     onTap: (){
                       setState(() {
                         _contact=_contacts[index];//pass item builder index here
                         _ctrlName.text=_contacts[index].name;//update name
                         _ctrlMobile.text=_contacts[index].mobile;//update name
                       });
                     },
                   ),
                   Divider(
                     height:5.0,
                   )
                 ],
              );
      },
      itemCount: _contacts.length,
      ),
  ),
);

}


//make a list to save input values in a contact list