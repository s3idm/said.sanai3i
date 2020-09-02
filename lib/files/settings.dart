import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanai3i/appLocales.dart';
import 'package:sanai3i/files/reusable.dart';
import 'package:url_launcher/url_launcher.dart';



 String lang  ( BuildContext context , String key  ) {
  return AppLocale.of(context).getTranslation(key);
}


termsOfUseDialog(BuildContext context){
  showModal(
    configuration: FadeScaleTransitionConfiguration(),
    context: context,builder:(context)=>
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(lang(context, 'termsOfUse'), style:  TextStyle(fontWeight: FontWeight.bold , fontSize:  18),),
          Text(lang(context, 'termsDis'), style:  TextStyle(fontSize:  14,color: Colors.grey[700]),textAlign: TextAlign.center),
        ],
      ),
      actions: <Widget>[
        RawMaterialButton(
          onPressed:()=> Navigator.pop(context),
          child: Text(lang(context, 'cancel') ,style: TextStyle(color: Colors.white),),
          fillColor: kActiveBtnColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ],
    ),
  );
}

policyDialog(BuildContext context){
  showModal(
    configuration: FadeScaleTransitionConfiguration(),
    context: context,builder:(context)=>
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(lang(context, 'policy'), style:  TextStyle(fontWeight: FontWeight.bold , fontSize:  18),),
            Text(lang(context, 'policyDis'), style:  TextStyle(fontSize:  14,color: Colors.grey[700]),textAlign: TextAlign.center,),
          ],
        ),
        actions: <Widget>[
          RawMaterialButton(
            onPressed:()=> Navigator.pop(context),
            child: Text(lang(context, 'cancel') ,style: TextStyle(color: Colors.white),),
            fillColor: kActiveBtnColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ],
      ),
  );
}


contactDialog(BuildContext context){
  showModal(
    configuration: FadeScaleTransitionConfiguration(),
    context: context,builder:(context)=>
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(lang(context, 'contact'), style:  TextStyle(fontWeight: FontWeight.bold , fontSize:  18),),
            GestureDetector(
              onTap: (){
                launch('tel:+966559397661');
              },
              child: Container(
                decoration: containerDecoration(Colors.white),
                height: 35,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 38,
                      child: IconButton(
                        icon: Image.asset('images/wa.png',),
                        onPressed: (){
                          launch('https://api.whatsapp.com/send?phone=+966559397661');
                        },
                      ),
                    ),
                    Text('+966 55 939 7661'),
                    Icon(Icons.phone,size: 20,),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          RawMaterialButton(
            onPressed:()=> Navigator.pop(context),
            child: Text(lang(context, 'cancel') ,style: TextStyle(color: Colors.white),),
            fillColor: kActiveBtnColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ],
      ),
  );
}
aboutDialog(BuildContext context){
  showModal(
  configuration: FadeScaleTransitionConfiguration(),
  context: context,builder:(context)=>
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(lang(context, 'about'), style:  TextStyle(fontWeight: FontWeight.bold , fontSize:  18),),
          Text(lang(context, "aboutDis"), style:  TextStyle(fontSize:  14,color: Colors.grey[700]),textAlign: TextAlign.center),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 10.0),
            child: Text(lang(context, 'rights'), style:  TextStyle(fontWeight: FontWeight.bold , fontSize:  12),textAlign: TextAlign.center,),
          ),
          Text('MasriTech', style:  TextStyle(fontWeight: FontWeight.bold , fontSize:  14),textAlign: TextAlign.right,),
        ],
      ),
      actions: <Widget>[
        RawMaterialButton(
          onPressed:()=> Navigator.pop(context),
          child: Text(lang(context, 'cancel') ,style: TextStyle(color: Colors.white),),
          fillColor: kActiveBtnColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ],
    ),
  );
}
