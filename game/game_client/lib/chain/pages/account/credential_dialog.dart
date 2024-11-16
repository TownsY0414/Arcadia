import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webauthn/webauthn.dart';

class CredentialDialog extends StatelessWidget {

  final List<Credential> credentials;

  const CredentialDialog({super.key, required this.credentials});

  @override
  Widget build(BuildContext context) {
     final divider = Container(height: .5, color: Colors.white.withOpacity(.05));
     return Material(type: MaterialType.transparency, child: Center(child: Container(
         margin: EdgeInsets.symmetric(horizontal: 24),
         constraints: BoxConstraints(maxHeight: context.height * .6),
         decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xFF292929)),
         child: Wrap(children: [
           Column(children: [
             SizedBox(height: 50, child: Center(child: Text("Choose an account to log in", style: TextStyle(color: Colors.white)))),
             ListView.separated(physics: NeverScrollableScrollPhysics(), shrinkWrap: true, separatorBuilder: (_, __) => divider,
                 itemCount: credentials.length, itemBuilder: (_, index) {
                   final credential = credentials[index];
                   return Container(color: Color(0xFF232323), child: ListTile(onTap: () {
                     Get.back<Credential>(result: credentials[index]);
                   },title: Text("${credential.username}", style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(.8)))));
                 }),
             divider,
             InkWell(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                 child: SizedBox(height: 50, child: Center(child: Text("Cancel", style: TextStyle(color: Colors.white)).marginOnly(left: 12))), onTap: () {
                Get.back();
             })
           ])
         ]))));
  }

}