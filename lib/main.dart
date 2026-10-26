// BYBER PRO - PREMIUM SELLABLE APP - BYBER EDITION
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
void main() => runApp(ByberProApp());
class ByberProApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark(), home: LoginScreen());
  }
}
class LoginScreen extends StatefulWidget { @override _LoginScreenState createState() => _LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  TextEditingController licenseController = TextEditingController();
  final String firebaseUrl = "https://YOUR_PROJECT.firebaseio.com"; // CHANGE THIS
  void checkLicense() async {
    String key = licenseController.text.trim();
    if(key.startsWith("BYBER-")){
       var res = await http.get(Uri.parse('$firebaseUrl/licenses/$key.json'));
       if(res.body != "null" || key == "BYBER-DEMO-1234"){
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PremiumDashboard(firebaseUrl: firebaseUrl, licenseKey: key)));
       } else {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid License. Buy at wa.me/YOURNUMBER")));
       }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F0F0F), Color(0xFF1A1A2E)])),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.auto_graph, size: 80, color: Color(0xFFD4AF37)),
              Text("BYBER PRO", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 3)),
              Text("PREMIUM EA CONTROL", style: TextStyle(color: Color(0xFFD4AF37), letterSpacing: 4)),
              SizedBox(height: 40),
              TextField(controller: licenseController, decoration: InputDecoration(hintText: "BYBER-2026-XXXX", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), prefixIcon: Icon(Icons.vpn_key, color: Color(0xFFD4AF37)))),
              SizedBox(height: 20),
              SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD4AF37), foregroundColor: Colors.black, padding: EdgeInsets.all(18)), onPressed: checkLicense, child: Text("UNLOCK BYBER PRO"))),
            ]),
          ),
        ),
      ),
    );
  }
}
class PremiumDashboard extends StatefulWidget {
  final String firebaseUrl; final String licenseKey;
  PremiumDashboard({required this.firebaseUrl, required this.licenseKey});
  @override _PremiumDashboardState createState() => _PremiumDashboardState();
}
class _PremiumDashboardState extends State<PremiumDashboard> {
  String status = "Loading..."; double lot = 0.10; double profit = 0.0;
  Future<void> send(String k, String v) async { await http.put(Uri.parse('${widget.firebaseUrl}/users/${widget.licenseKey}/$k.json'), body: '"$v"'); }
  Future<void> refresh() async { var s = await http.get(Uri.parse('${widget.firebaseUrl}/users/${widget.licenseKey}/STATUS.json')); var p = await http.get(Uri.parse('${widget.firebaseUrl}/users/${widget.licenseKey}/PROFIT.json')); setState(() { status = s.body.replaceAll('"', ''); try{ profit = double.parse(p.body.replaceAll('"', '')); }catch(e){} }); }
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("BYBER PRO"), backgroundColor: Colors.black), body: Padding(padding: EdgeInsets.all(20), child: Column(children: [Card(child: ListTile(title: Text(status), subtitle: Text("\$${profit.toStringAsFixed(2)}"))), Slider(min: 0.01, max: 2.0, value: lot, onChanged: (v)=>setState(()=>lot=v), onChangeEnd: (v)=>send("BOT_LOT", v.toStringAsFixed(2))), Row(children: [Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: ()=>send("BOT_ENABLED", "1"), child: Text("START"))), SizedBox(width: 10), Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: ()=>send("BOT_ENABLED", "0"), child: Text("STOP")))]), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), onPressed: ()=>send("COMMAND", "CLOSE_ALL"), child: Text("CLOSE ALL"))])));
  }
}
