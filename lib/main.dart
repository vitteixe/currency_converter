import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json-cors&key=4c1a8bee";

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home()
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
                return Container(color: Colors.green,);
              }
          }
        }
      )
    );
  }
}
