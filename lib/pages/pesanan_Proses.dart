import 'package:flutter/material.dart';
import 'package:tubes_resto/pages/page_status.dart';
import 'package:tubes_resto/widget/list_riwayat.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tubes_resto/models/Pesanan.dart';

class pesananPage extends StatefulWidget {
  //style variabel
  static const TextStyle judulStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold,);
  static const TextStyle namaRestoStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold,);
  static const TextStyle baseStyle =
      TextStyle(fontSize: 12, color: Colors.black,);
  static const TextStyle button =
      TextStyle(fontSize: 18, color: Colors.white,); 

  @override
  State<pesananPage> createState() => _pesananPageState();
}

class getProses {
  final url = 'http://127.0.0.1:8000/api/transaksi_berlangsung';

  Future<List<Pesanan>> getPesanan() async{
    try{
      final response = await http.get(Uri.parse(url));
    
      if(response.statusCode==200){
        Iterable it = jsonDecode(response.body);
        List<Pesanan> pesanan = it.map((e) => Pesanan.fromJson(e)).toList();
        return pesanan;
      }else{
        throw 'Failed to load data';
      }
    }catch(e){
      throw(e.toString());
    }
  }
}

class _pesananPageState extends State<pesananPage> {
  final green = Color.fromRGBO(64, 111, 60, 1);

  List<Pesanan> listPesanan = [];

  getProses data = getProses();

  getData() async{
    listPesanan = await data.getPesanan();
  }
  
  void initState(){
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Pesanan', 
            style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          bottom: TabBar(
            unselectedLabelColor: green,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: green
            ),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: green,width: 1,)
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Proses', style: pesananPage.judulStyle,),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: green,width: 1,)
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Riwayat', style: pesananPage.judulStyle,),
                  ),
                ),
              ),
            ]),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: data.getPesanan(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Container(
                  margin: EdgeInsets.all(10),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        child: InkWell(
                          onTap: () { 
                           Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => status(p: listPesanan[index]))
                            );
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      height: 72,
                                      width: 72, 
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        shape: BoxShape.rectangle,
                                        image: const DecorationImage(
                                          image: AssetImage('assets/images/logo2.png'),
                                          fit: BoxFit.cover,
                                        )
                                      ), 
                                    ),
                                    Container(
                                      width: 227,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        textDirection: TextDirection.ltr,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        Text(listPesanan[index].resto_id.toString(), style: pesananPage.namaRestoStyle,),
                                        //Text(listPesanan[index].date_reservasi, style: pesananPage.baseStyle,)
                                        Text(listPesanan[index].date_reservasi+" pukul "+listPesanan[index].time_reservasi, style: pesananPage.baseStyle,)
                                        ] 
                                      ),
                                    ),
                                  ]
                                ),
                              ),
                              Container(
                                child: IconButton(onPressed: (){}, icon: Icon(Icons.phone)),
                              )
                            ],
                          ),
                        ),
                      );
                    }, 
                    separatorBuilder: (context, index){
                      return Divider();
                    },
                    itemCount: listPesanan.length,
                    )
                  );
                }else{
                  return Center(child: Text('Kosong', style: pesananPage.baseStyle,));
                }
              },   
            ), //hal. tab 1
            listRiwayat()//hal. tab 2
            ]
        ),
      ),
    );
  }
}
//Sumber: 
//https://medium.com/codechai/flutter-boring-tab-to-cool-tab-bfcb1a93f8d0
//https://skillplus.web.id/menggunakan-listtile/
//https://www.kindacode.com/snippet/flutter-listtile-with-multiple-trailing-icon-buttons/
//https://www.youtube.com/watch?v=FWk-rDw-6f8&t=516s
//https://www.youtube.com/watch?v=rWIq0tbQbd0&t=264s