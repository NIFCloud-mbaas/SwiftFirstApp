//
//  RankingViewController.swift
//  SwiftFirstApp
//
//  Created by Natsumo Ikeda on 2016/06/23.
//  Copyright 2017 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

import UIKit
import NCMB

class RankingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // 「rankingTableView」ランキングを表示するテーブル
    @IBOutlet weak var rankingTableView: UITableView!
    // ランキング取得数
    let rankingNumber = 5
    // 取得したデータを格納する配列
    var rankingArray: Array<NCMBObject> = []
    
    // 画面表示時に実行されるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        // 保存したデータの検索と取得
        checkRanking()
    }
    
    // 【mBaaS】保存したデータの検索と取得
    func checkRanking() {
        // **********【問題２】ランキングを表示しよう！**********
        // GameScoreクラスを検索するクエリを作成
        let query = NCMBQuery(className: "GameScore")
        // scoreの降順でデータを取得するように設定する
        query!.addDescendingOrder("score")
        // 検索件数を設定
        query!.limit = Int32(rankingNumber)
        // データストアを検索
        query!.findObjectsInBackground({ (objects: [Any]!, error: Error!) in
            if error != nil {
                // 検索に失敗した場合の処理
                print("検索に失敗しました。エラーコード：\((error! as NSError).code)")
            } else {
                // 検索に成功した場合の処理
                print("検索に成功しました。")
                // 取得したデータを格納
                self.rankingArray = objects as! Array
                // テーブルビューをリロード
                self.rankingTableView.reloadData()
            }
        })
        // **************************************************
    }
    
    // rankingTableViewのセルの数を指定
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankingNumber
    }
    
    // rankingTableViewのセルの内容を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // キーを「cell」としてcellデータを取得
        let cell = rankingTableView.dequeueReusableCell(withIdentifier: "rankingTableCell", for: indexPath)
        var object: NCMBObject?
        // 「表示件数」＜「取得件数」の場合のobjectを作成
        if indexPath.row < rankingArray.count {
            object = self.rankingArray[indexPath.row]
        }
        
        // 順位の表示
        let ranking = cell.viewWithTag(1) as! UILabel
        ranking.text = "\(indexPath.row+1)位"
        
        if let unwrapObject = object {
            // 名前の表示
            let name = cell.viewWithTag(2) as! UILabel
            name.text = "\(unwrapObject.object(forKey:"name") ?? "")さん"
            // スコアの表示
            let score = cell.viewWithTag(3) as! UILabel
            score.text = "\(unwrapObject.object(forKey:"score") ?? "")連打"
        }
        
        return cell
    }
}