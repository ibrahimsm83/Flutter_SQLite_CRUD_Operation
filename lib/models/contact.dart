class Contact{
 
  static const tblContact='contacts';
  static const colid='id';
  static const colName='name';
  static const  colMobile='mobile';


 //use {} because Constractor have opitional peramerter
   Contact({this.id,this.name,this.mobile});
   int id;
    String name;
    String mobile;
 
    //for map we use named constractor 
    Contact.fromMap(Map<String,dynamic> map){
     id=map[colid];
     name=map[colName];
     mobile=map[colMobile];

    }


    

    Map<String,dynamic> toMap(){
        //var map=<String,dynamic>{'name':name,'mobile':mobile};//Remove hardcode key name 
       var map=<String,dynamic>{colName:name,colMobile:mobile};

       if(id !=null) 
       {
       map[colid]=id;
       }
       return map;
       
    } 

}
//use sqlite map by using map(is a collection of key)
//Constract ki value convert into map taky use in sqlitedb
//var x=Contact(id: 0,name: 'xyz');