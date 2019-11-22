## 【問題２】答え合わせ

### ランキング画面の確認

* ランキング画面を確認しましょう
 * アプリで「ランキングを見る」をタップすると以下のようにランキングが表示されます

![ans2-1](/readme-img/ans2-1.png)

* 上図は３回遊んだ場合の例です。複数回遊んで、ランキングが表示されることを確認しましょう！

### コードの答え合わせ

![Xcode](/readme-img/Xcode.png)

* 模範解答は以下です

```swift
// **********【問題２】ランキングを表示しよう！**********
// GameScoreクラスを検索するクエリを作成
var query : NCMBQuery<NCMBObject> = NCMBQuery.getQuery(className: "GameScore")
// scoreの降順でデータを取得するように設定する
query.order = ["-score"]
// 検索件数を設定
query.limit = rankingNumber
// データストアを検索
query.findInBackground(callback: { result in
    switch result {
        case let .success(array):
            // 検索に成功した場合の処理
            print("検索に成功しました。")
            // 取得したデータを格納
            self.rankingArray = array
            // テーブルビューをリロード
            self.rankingTableView.reloadData()
        case let .failure(error):
            // 検索に失敗した場合の処理
            print("検索に失敗しました。エラーコード：\(error)")
    }
})
// **************************************************
```
