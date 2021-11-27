import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json-cors&key=4c1a8bee";

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        hintStyle: TextStyle(color: Colors.amber),
      )),
  ));
}

//- acessando API -//
Future<Map> getData() async{
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}
//-! acessando API -//

//--                STFUL                   --//

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

//--                                       --//

class _HomeState extends State<Home> {

  double? dolar;
  double? euro;


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        title: const Text("Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),

      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context,snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                  child: Text("Carregando dados...",
                  style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 25.0),
                  textAlign: TextAlign.center,)
              );

            default:
              if(snapshot.hasError){
                return const Center(
                    child: Text("Erro ao Carregar :(",
                      style: TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,)
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const <Widget>[
                      Icon(Icons.monetization_on, size: 160.0,color: Colors.amber),
                      //--fim icon--//

                      TextField(
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "R\$",
                        ),
                        style: TextStyle(
                          color: Colors.amber, fontSize: 25.0,
                        ),
                      ),

                      Divider(),

                      TextField(
                        decoration: InputDecoration(
                          labelText: "Dolares",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "US\$",
                        ),
                        style: TextStyle(
                          color: Colors.amber, fontSize: 25.0,
                        ),
                      ),

                      Divider(),
                      
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Euros",
                          labelStyle: TextStyle(color: Colors.amber),
                          border: OutlineInputBorder(),
                          prefixText: "€",
                        ),
                        style: TextStyle(
                          color: Colors.amber, fontSize: 25.0,
                        ),
                      ),

                    ],
                  ),
                );

              }
          }
        }
      )
    );
  }
}
