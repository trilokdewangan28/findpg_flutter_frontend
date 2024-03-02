
import 'package:findpg/config/ApiLinks.dart';
import 'package:findpg/config/StaticMethod.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../provider/MyProvider.dart';
class FullImageView extends StatelessWidget {
   FullImageView({Key? key, required this.imageUrl, required this.asFinder}) : super(key: key);

  final imageUrl;
  bool asFinder;


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context, listen: false);
    print(imageUrl);
    return WillPopScope(
        onWillPop: ()async{
          Navigator.pop(context);
          return false;
        },
        child: SafeArea(child:
        Scaffold(
          appBar: AppBar(
            title: const Text('Full Image View'),
            actions: [
              asFinder==false ? TextButton(
                  onPressed: ()async{
                    var data= {
                      'email':appState.userDetail['result']['email'],
                      'ownerHostlePic':imageUrl
                    };
                    var url=Uri.parse(ApiLinks.deleteOwnerHostlePicApi);
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogContext) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                   final res= await  StaticMethod.removeUploadedImage(data, url);
                   Navigator.pop(context);
                   if(res.isNotEmpty){
                     StaticMethod.showDialogMessage(context, res, appState, 'Deletion Response');
                     print('hostle pic deleted successfully');
                   }
                  },
                  child: const Text('delete', style: TextStyle(color: Colors.white),)
              ) : Container()
            ],
          ),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage('${ApiLinks.accessHostleImages}/${imageUrl}?timestamp=${DateTime.now().millisecondsSinceEpoch}'),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2.0,
        ),
      ),
    )));
  }
}
