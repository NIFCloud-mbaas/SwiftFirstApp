//
//  GameViewController.swift
//  SwiftFirstApp
//
//  Created by Natsumo Ikeda on 2016/06/22.
//  Copyright 2017 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

import UIKit
import NCMB

class GameViewController: UIViewController{
    // タップ回数
    var count = 0
    // 「tapFlag」的のタップ可否設定
    var tapFlag = false
    // タイマー（秒）
    var countTimer = 0
    // 「label」ラベル
    @IBOutlet weak var label: UILabel!
    // 「counter」テキストフィールド
    @IBOutlet weak var counter: UITextField!
    // 「Start」ボタン
    @IBOutlet weak var start: UIButton!
    // 「ランキングを見る」ボタン
    @IBOutlet weak var checkRanking: UIBarButtonItem!
    
    // 画面表示時に取得されるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        // 文字サイズ自動調整
        self.label.adjustsFontSizeToFitWidth = true
        // ラベルの初期値設定
        self.label.text = "↓Startボタンを押してゲームスタート↓"
        // テキストフィールド編集不可
        self.counter.isEnabled = false
        // 的のタップを不可に設定
        tapFlag = false
    }
    
    // 「Start」ボタン押下時の処理
    @IBAction func startGame(_ sender: UIButton) {
        // 実行中ボタンの無効化
        sender.isEnabled = false
        checkRanking.isEnabled = false
        // カウンターを0にする
        count = 0
        // タイマーを13秒にする
        countTimer = 13
        // タイマーを起動
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // 【mBaaS】データの保存
    func saveScore (name: String, score: Int) {
        // **********【問題１】名前とスコアを保存しよう！**********
        // 保存先クラスを作成
        let obj = NCMBObject(className: "GameScore")
        // 値を設定
        obj["name"] = name
        obj["score"] = score
        // 保存を実施
        obj.saveInBackground(callback: { result in
            switch result {
                case .success:
                    // 保存に成功した場合の処理
                    print("保存に成功しました。objectId:\(String(describing: obj.objectId))")
                case let .failure(error):
                    // 保存に失敗した場合の処理
                    print("保存に失敗しました。エラーコード:\(error)")
            }
        })
        // **************************************************
    }
        
    // タイマーの処理
    @objc func timerAction(_ sender:Timer){
        if countTimer >= 11 {
            self.label.text = String(countTimer - 10)
        } else {
            tapFlag = true
            if countTimer == 10{
                self.label.text = "スタート！"
            } else if countTimer <= 9 && countTimer >= 1 {
                self.label.text = String(countTimer)
            } else {
                tapFlag = false
                self.label.text = "タイムアップ！"
                // タイマーストップ
                sender.invalidate()
                // 名前入力アラートの表示
                inputName(sender: self.count)
            }
        }
        countTimer -= 1
    }
    
    // 名前入力アラートの表示
    func inputName (sender: Int) {
        // 名前を入力するアラートを表示
        let alert = UIAlertController(title: "スコア登録", message: "名前を入力してください", preferredStyle: .alert)
        // UIAlertControllerにtextFieldを追加
        alert.addTextField { (textField: UITextField!) -> Void in
        }
        // アラートの「OK」ボタン押下時の処理
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) -> Void in
            // 名前とスコアを保存
            self.saveScore(name: alert.textFields![0].text!, score: sender)
            // 名前とスコアの表示
            self.label.text = "\(alert.textFields![0].text!)さんのスコアは\(sender)連打でした"
            // 実行後ボタンの有効化
            self.start.isEnabled = true
            self.checkRanking.isEnabled = true
            })
        present(alert, animated: true, completion: nil)
    }
    // viewシングルタップ時の処理
    @IBAction func tapView(_ sender: Any) {
        if tapFlag {
            self.count += 1
            self.counter.text = "\(count)"
        }
    }
}
