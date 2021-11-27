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
      hintColor: Colors.white,
      primaryColor: Colors.amber,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
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

  //-- Controladores --//

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  //-! Controladores --//

  double? dolar;
  double? euro;

  //-- Funções de Conversões --//

  void _realChanged(String text){
    if (text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar!).toStringAsFixed(2);
    euroController.text = (real/euro!).toStringAsFixed(2);
  }

  //---------------------------------------------------------------//

  void _dolarChanged(String text){
    if (text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar!).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar! / euro!).toStringAsFixed(2);
  }

  //---------------------------------------------------------------//

  void _euroChanged(String text){
    if (text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro!).toStringAsFixed(2);
    dolarController.text = (euro * this.euro! / dolar!).toStringAsFixed(2);
  }
  //-! Funções de Conversões --//

  //-- Função CLEAR --//

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  //-! Função CLEAR --//


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
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 160.0,color: Colors.amber),
                      //--fim icon--//

                      buildTextField("Reais", "R\$", realController, _realChanged),

                      const Divider(),

                      buildTextField("Dolares", "US\$", dolarController, _dolarChanged),

                      const Divider(),

                      buildTextField("Euro","€", euroController, _euroChanged),

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

Widget buildTextField(String label, prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix
    ),
    style: TextStyle(
      color: Colors.amber, fontSize: 25.0
    ),
    onChanged: f as void Function(String)?,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}