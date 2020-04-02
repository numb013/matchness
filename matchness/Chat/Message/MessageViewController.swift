//
//  MessageViewController.swift
//  matchness
//
//  Created by user on 2019/07/04.
//  Copyright © 2019 a2c. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import FirebaseDatabase
import FirebaseStorage
import SDWebImage
import Alamofire
import SwiftyJSON

class MessageViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // データベースへの参照を定義
    var ref: DatabaseReference!
    var message_users = [String:String]()
    var roomId = String()
    var point = Int()
    var last_message = String()
    var my_image = String()
    var target_imag = String()
    let image_url: String = ApiConfig.REQUEST_URL_IMEGE;

    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    let userDefaults = UserDefaults.standard
    var messages = [JSQMessage]()
}

extension MessageViewController {
    //送信ボタンが押された時の挙動
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {

        
//        let alertController:UIAlertController =
//            UIAlertController(title:"メッセージを送る",message: "メッセージ送信には100pt必要です",preferredStyle: .alert)
//        // Default のaction
//        let defaultAction:UIAlertAction =
//            UIAlertAction(title: "送信",style: .destructive,handler:{
//            (action:UIAlertAction!) -> Void in
//            // 処理
                print("送信する")
                self.point = self.userDefaults.object(forKey: "point") as! Int

print(self.point)

                if self.point < 50 {

                    let alertController:UIAlertController =
                        UIAlertController(title:"メッセージを送信",message: "メッセージを送信には50pt必要です",preferredStyle: .alert)
                    // Default のaction
                    let defaultAction:UIAlertAction =
                        UIAlertAction(title: "ポイント変換ページへ",style: .destructive,handler:{
                            (action:UIAlertAction!) -> Void in
                            // 処理
                            print("ポイント変換ページへ")
                            self.tabBarController?.tabBar.isHidden = false
                            let storyboard: UIStoryboard = self.storyboard!
                            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                            let multiple = storyboard.instantiateViewController(withIdentifier: "pointChange")
                            multiple.modalPresentationStyle = .fullScreen
                            //ここが実際に移動するコードとなります
                            self.dismiss(animated: true, completion: nil)
                            self.present(multiple, animated: false, completion: nil)
                        })
                    
                    // Cancel のaction
                    let cancelAction:UIAlertAction =
                        UIAlertAction(title: "キャンセル",style: .cancel,handler:{
                            (action:UIAlertAction!) -> Void in
                            // 処理
                            print("キャンセル")
                        })
                    // actionを追加
                    alertController.addAction(cancelAction)
                    alertController.addAction(defaultAction)
                    // UIAlertControllerの起動
                    self.present(alertController, animated: true, completion: nil)

                } else {
                    print("1111111111111111")
                    self.point = self.point - 50
                    self.userDefaults.set(Int(self.point), forKey: "point")
                    
                    let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
                    //メッセージの送信処理を完了する(画面上にメッセージが表示される)
                    self.finishReceivingMessage(animated: true)
                    self.last_message = text
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd H:m:s"
                    let now = Date()

                    self.addMessage()
                    
                    //firebaseにデータを送信、保存する
                    let post1 = [
                        "from": senderId,
                        "name": senderDisplayName,
                        "media_type": "text",
                        "text":text,
                        "image_url": nil,
                        "create_at": f.string(from: now),
                        "update_at": f.string(from: now),
                        ] as [String : Any]
                    let post1Ref = self.ref.child("messages").child(self.roomId).childByAutoId()
                    post1Ref.setValue(post1)
                    self.finishSendingMessage(animated: true)
                }
//                //キーボードを閉じる
//                self.view.endEditing(true)
//            })
//
//        // Cancel のaction
//        let cancelAction:UIAlertAction =
//            UIAlertAction(title: "キャンセル",style: .cancel,handler:{
//            (action:UIAlertAction!) -> Void in
//            // 処理
//                print("キャンセル")
//            })
//
//        // actionを追加
//        alertController.addAction(cancelAction)
//        alertController.addAction(defaultAction)
//
//        // UIAlertControllerの起動
//        present(alertController, animated: true, completion: nil)
    }

    
    func addMessage() {
        /****************
         APIへリクエスト（ユーザー取得）
         *****************/
        //ロジック生成
        let requestMessageModel = MessageModel();
        //requestMessageModel.delegate = self as! MessageModelDelegate;
        //リクエスト先
        let requestUrl: String = ApiConfig.REQUEST_URL_API_SEND_MESSAGE;
        //パラメーター
        var query: Dictionary<String,String> = Dictionary<String,String>();
        
        query["point"] = "50"
        query["last_message"] = self.last_message
        query["room_code"] = self.roomId
        //リクエスト実行
        if( !requestMessageModel.requestApi(url: requestUrl, addQuery: query) ){
            
        }
    }
    
    
    
    
    
    //添付ファイルボタンが押された時の挙動
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("カメラ")
        selectImage()
    }

    private func selectImage() {
        let alertController: UIAlertController = UIAlertController(title: "アラート表示", message: "保存してもいいですか？", preferredStyle:  UIAlertController.Style.alert)
        //        let alertController = UIAlertController(title: "画像を選択", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラを起動", style: .default) { (UIAlertAction) -> Void in
            self.selectFromCamera()
        }
        let libraryAction = UIAlertAction(title: "カメラロールから選択", style: .default) { (UIAlertAction) -> Void in
            self.selectFromLibrary()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func selectFromCamera() {
        print("カメラ許可")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラ許可をしていない時の処理")
        }
    }
    
    private func selectFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let resizedImage = self.resizeImage(image: info[UIImagePickerController.InfoKey.editedImage] as! UIImage, ratio: 0.5) // 50% に縮小
        
        let imageData = NSData(data: (resizedImage).pngData()!) as NSData
        let storageRef = Storage.storage().reference()
        let f = DateFormatter()
        f.dateFormat = "yyyyMMddHms"
        let now = Date()
        
        var image_url : String? = ""
        let referenceRef = storageRef.child("images/" + f.string(from: now) + ".jpg")
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        referenceRef.putData(imageData as Data, metadata: meta, completion: { metaData, error in
            if (error != nil) {
                print("Uh-oh, an error occurred!")
            } else {
                print(metaData)
                image_url = metaData?.name
                let post1 = [
                    "from": self.senderId,
                    "name": self.senderDisplayName,
                    "media_type": "image",
                    "text": nil,
                    "image_url": image_url,
                    "create_at": f.string(from: now),
                    "update_at": f.string(from: now),
                    ] as [String : Any]
                let post1Ref = self.ref.child("messages").child(self.roomId).childByAutoId()
                post1Ref.setValue(post1)
                self.finishSendingMessage(animated: true)
            }
        })
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 画像を指定された比率に縮小
    func resizeImage(image: UIImage, ratio: CGFloat) -> UIImage {
        let size = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x:0, y:0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }

    //各メッセージの高さ
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    //各送信者の表示に画像を使うか
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return self.outgoingAvatar
        } else {
            return self.incomingAvatar
        }
    }
    
    //各メッセージの背景を設定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.row]
        if self.senderId == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor(red: 112/255, green: 192/255, blue:  75/255, alpha: 1))
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1))
        }
    }
        
    // cell for item
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        if messages[indexPath.row].senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.darkGray
        }
        return cell
    }
    
    //   メッセージの総数を取得
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    //   メッセージの内容参照場所の設定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }

     //時刻表示のための高さ調整
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        if indexPath.item == 0 {
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            if message.date.timeIntervalSince(previousMessage.date) / 60 > 1 {
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
            }
        }
        return nil
    }

     // 送信時刻を出すために高さを調整する
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            let message = messages[indexPath.item]
            if message.date .timeIntervalSince(previousMessage.date) / 60 > 1 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0.0
    }

}


extension MessageViewController {
    // 画面を開いた直後の挙動。ここで使用者側の設定を行ない、過去のメッセージを取得している
    override func viewDidLoad() {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                //                instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
        super.viewDidLoad()


print("メッセージメッセージメッセージメッセージメッセージメッセージ")
print(self.message_users)


        self.roomId = self.message_users["room_code"]!
        self.senderId = self.message_users["user_id"]
        self.senderDisplayName = self.message_users["user_name"]

        self.my_image = self.message_users["my_image"]!
        self.target_imag = self.message_users["target_imag"]!

        self.userDefaults.set(Int(self.message_users["point"]!), forKey: "point")
        print("送信する")
        self.point = self.userDefaults.object(forKey: "point") as! Int

        //タブバー非表示
        tabBarController?.tabBar.isHidden = true
        // アバターの設定
        //相手
        let profileImageURL = image_url + self.target_imag
        let url = NSURL(string: profileImageURL);
        let imageData = NSData(contentsOf: url! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(data:imageData! as Data)!, diameter: 64)

        //自分
        let profileImageURL_1 = image_url + self.my_image
        let url_1 = NSURL(string: profileImageURL_1);
        let imageData_1 = NSData(contentsOf: url_1! as URL) //もし、画像が存在しない可能性がある場合は、ifで存在チェック
        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(data:imageData_1! as Data)!, diameter: 64)
        // メッセージ取得の関数（真下）呼び出し
        self.messages = getMessages()
    }

    override func viewDidAppear(_ animated: Bool) {
        print("メッセージ3")
        super.viewDidAppear(animated)
        //タブバー非表示
        tabBarController?.tabBar.isHidden = true
    }


}

extension MessageViewController {
    //   テストメッセージ作成、呼び出し関数作成
    func getMessages() -> [JSQMessage] {
        var messages = [JSQMessage]()
        // DatabaseReferenceのインスタンス化
        ref = Database.database().reference()
        // 最新25件のデータをデータベースから取得する
        // 最新のデータが追加されるたびに最新データを取得する
        ref.child("messages").child(self.roomId).queryLimited(toLast: 25).observe(DataEventType.childAdded, with: { (snapshot)  -> Void in
            let snapshotValue = snapshot.value as! NSDictionary
            let mediaType = snapshotValue["media_type"] as! String
            let sender = snapshotValue["from"] as! String
            let name = snapshotValue["name"] as! String
            let storage = Storage.storage()
            let host = "gs://popo-katsu-266622.appspot.com"
            switch mediaType {
            case "image":
                var photoItem = JSQPhotoMediaItem(image: nil)
                photoItem!.appliesMediaViewMaskAsOutgoing = (sender == self.senderId) ? true : false
                self.messages.append(JSQMessage(senderId: sender, displayName: name, media: photoItem))
                let image_url = snapshotValue["image_url"] as! String
                storage.reference(forURL: host).child("images/").child(image_url)
                    .getData(maxSize: 10 * 1024 * 1024, completion: { data, error in
                        let imageData = data
                        let image = UIImage(data: imageData!)
                        DispatchQueue.main.async(execute: {
                            photoItem?.image = image
                            self.finishReceivingMessage(animated: true)
                        })
                    })
            case "text":
                let text = snapshotValue["text"] as! String
                self.messages.append(JSQMessage(senderId: sender, displayName: name, text: text))
            default:
                print("アウト")
            }
            self.finishReceivingMessage(animated: true)
            //            self.collectionView.reloadData()
        })
        return messages
    }
}
