import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shamo/models/message_model.dart';
import 'package:shamo/models/product_model.dart';
import 'package:shamo/models/user_model.dart';

class MessageService {
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessageByUserId({int userId}) {
    try {
      return firebase
          .collection('messages')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
        var result = list.docs.map<MessageModel>((DocumentSnapshot message) {
          print(message.data());
          return MessageModel.fromJson(message.data());
        }).toList();

        result.sort((MessageModel a, MessageModel b) =>
            a.createAt.compareTo(b.createAt));

        return result;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addMessage({
    UserModel user,
    bool isFromUser,
    String message,
    ProductModel product,
  }) async {
    try {
      firebase.collection('messages').add({
        'userId': user.id,
        'userName': user.name,
        'userImage': user.profilePhotoUrl,
        'isFromUser': isFromUser,
        'message': message,
        'product': product is UninitializedProductModel ? {} : product.toJson(),
        'createAt': DateTime.now().toString(),
        'updateAt': DateTime.now().toString(),
      }).then(
        (value) => print("Pesan Berhasil Dikirim!"),
      );
    } catch (e) {
      throw Exception("Pesan Gagal Dikirim!");
    }
  }
}
