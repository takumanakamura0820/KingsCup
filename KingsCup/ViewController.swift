//
//  ViewController.swift
//  KingsCup
//
//  Created by 中村拓馬 on 2020/07/29.
//  Copyright © 2020 Nakamuratakuma. All rights reserved.
//

import UIKit
import NCMB
import KRProgressHUD


class ViewController: UIViewController {
    var numberArray = [String]()
    var gameArray = [String]()
    var detailArray = [String]()
    var doneArray = [String]()
    let ud = UserDefaults.standard
    var markCount : Int!
    var cardCount = 52
    var trueArray = [Bool]()
    
    @IBOutlet var numberLabel : UILabel!
    @IBOutlet var cardCountLabel : UILabel!
    @IBOutlet var gameLabel : UILabel!
    @IBOutlet var detailLabel : UILabel!
    @IBOutlet var mekuruButton:UIButton!
    @IBOutlet var cardCheckButton : UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ステータスバーのスタイル変更を促す
        self.setNeedsStatusBarAppearanceUpdate();
        mekuruButton.layer.borderWidth = 1.0
        mekuruButton.layer.borderColor = UIColor.black.cgColor
        mekuruButton.layer.cornerRadius = 8.0
        mekuruButton.titleLabel?.font = UIFont(name: "GillSans-BoldItalic", size: 34)
        //        cardCheckButton.titleLabel?.font = UIFont(name: "GillSans-BoldItalic", size: 23)
        
        
        var flag = false
        
        for i in stride(from: 0, to: 13, by: 1){
            let eachNumCount = ud.integer(forKey: String(i))
            cardCount -= eachNumCount
        }
        cardCountLabel.text = String(cardCount)
        
        trueArray = [Bool]()
        if  ud.array(forKey: "trueArray") == nil {
            for i in stride(from: 0, to: 13, by: 1){
                trueArray.append(false)
                ud.set(trueArray, forKey: "trueArray")
            }
        }else{
            trueArray = ud.array(forKey: "trueArray") as! [Bool]
        }
        loadData()
    }
    
    
   
    
    
    @IBAction func next(){
        
        let randomInt = Int.random(in: 0..<13)
        print("乱数の数",randomInt)
        
        //ダブり防止機能
        if ud.integer(forKey:  String(randomInt)) == nil{
            //        初めてやる時
            ud.set(0, forKey: String(randomInt))
        }else{
            //            ２回目以降
            if ud.integer(forKey:  String(randomInt)) == 4{
                //                もし4回出てたらカードを出ないようにする(ハート・スペード・クローバー・ダイヤ)
                //                まだ全部足されていないようだったら、
                print(trueArray)
                if trueArray.contains(false) == true{
                    next()
                }else{
                    //                    true countが13になったら
                    let alert = UIAlertController(title: "全てのカードが出ました", message: "リセットします", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                        self.refresh()
                    }
                    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                    })
                    alert.addAction(cancelAction)
                    alert.addAction(action)
                    present(alert,animated: true)
                }
            }else{
                if markCount == nil{
                    markCount = 0
                }
                markCount = ud.integer(forKey:  String(randomInt))
                markCount += 1
                //                4になったらtrueを入れる
                if markCount == 4 {
                    trueArray = ud.array(forKey: "trueArray") as! [Bool]
                    if trueArray.count == 0 {
                        for i in stride(from: 0, to: 13, by: 1){
                            trueArray.append(false)
                        }
                        ud.set(trueArray, forKey: "trueArray")
                    }
                    trueArray[randomInt] = true
                    print("trueArray = ",trueArray)
                    ud.set(trueArray, forKey: "trueArray")
                }
                ud.set(markCount, forKey: String(randomInt))
                self.numberLabel.alpha = 0
                numberLabel.text = String(numberArray[randomInt])
                UIView.animate(withDuration: 5){
                    self.numberLabel.alpha = 1
                }
                cardCount = 52
                for i in stride(from: 0, to: 52, by: 1){
                    let eachNumCount = ud.integer(forKey: String(i))
                    cardCount -= eachNumCount
                }
                cardCountLabel.text = String(cardCount)
                //                printCheck()
                
                if randomInt == 12{
                    let kingsCount = ud.integer(forKey: String(randomInt))
                    var message :String!
                    if kingsCount == 4{
                        let alertController = UIAlertController(title: "Kingが4枚出ました！", message: "終了です！注がれたキングスカップを飲みましょう！！", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                            self.refresh()
                        }
                        alertController.addAction(action)
                        present(alertController,animated: true)
                    }else{
                        message = "\(kingsCount)回目です！"
                    }
                    gameLabel.text = gameArray[randomInt]
                    
                }else{
                    
                    gameLabel.text = gameArray[randomInt]
                    gameLabel.lineBreakMode = .byWordWrapping
                    detailLabel.text = detailArray[randomInt]
                    detailLabel.lineBreakMode = .byWordWrapping
                }
            }
        }
    }
    
    
    @IBAction func check(){
        for i in numberArray{
            if ud.string(forKey: String(i)) != nil{
                print(i as! String + "のカウントは：" + ud.string(forKey: String(i))!)
            }
        }
    }
    
    func refresh(){
        //                リセット
        for i in stride(from: 0, to: 13, by: 1){
            ud.set(0, forKey: String(i))
        }
        ud.set([], forKey: "trueArray")
        cardCount = 52
        for i in stride(from: 0, to: 13, by: 1){
            let eachNumCount = ud.integer(forKey: String(i))
            cardCount -= eachNumCount
            cardCountLabel.text = String(cardCount)
        }
        numberLabel.text = "Start!"
        gameLabel.text = ""
        detailLabel.text = ""
        loadData()
    }
    @IBAction func reload(){
        let alertController = UIAlertController(title: "リセットしますか？", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            self.refresh()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) in
            alertController.dismiss(animated: true) {
                
            }
        }
        
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        present(alertController,animated: true)
    }
    
    
    func printCheck(){
        let tempTrueArray = ud.array(forKey: "trueArray")as! [Bool]
        print("trueArray",tempTrueArray)
        var trueCount = 0
        for i in tempTrueArray{
            if i == true{
                trueCount += 1
            }
        }
        print("現在のtrueArryay内のtrueの数",trueCount)
        for i in stride(from: 0, to: 13, by: 1){
            let count = self.ud.integer(forKey: String(i))
            print("\(i)の出た回数:",count)
            
        }
    }
    
    func loadData(){
        let query = NCMBQuery(className: "Card")
        query?.addDescendingOrder("createDate")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                KRProgressHUD.showError(withMessage: error.debugDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    KRProgressHUD.dismiss()
                }
            }else{
                self.numberArray = [String]()
                self.gameArray = [String]()
                print(result)
                for object in result as! [NCMBObject]{
                    self.numberArray.append(object.object(forKey: "number")as! String)
                    self.gameArray.append(object.object(forKey: "game")as! String)
                    self.detailArray.append(object.object(forKey: "detail")as! String)
                }
            }
            self.printCheck()
        })
    }
}
