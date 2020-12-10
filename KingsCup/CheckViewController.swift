//
//  CheckViewController.swift
//  KingsCup
//
//  Created by 中村拓馬 on 2020/08/26.
//  Copyright © 2020 Nakamuratakuma. All rights reserved.
//

import UIKit
import NCMB
import KRProgressHUD

class CheckViewController: UIViewController ,UITableViewDelegate{
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 13
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.accessoryType =
//    }
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
                
                
            }
        })
    }


}
