## 【問題１】答え合わせ

### ニフティクラウドmobile backend上での確認
![mBaaS](/readme-img/mBaaS.png)

* 保存されたデータを確認しましょう
 * 「データストア」をクリックすると、「`GameScore`」クラスにデータが登録されていることが確認できます。

![ans1-1](/readme-img/ans1-1.png)

* 上図はスコアが35連打で名前を「あいうえお」とした場合の例です。

### コードの答え合わせ

![Xcode](/readme-img/Xcode.png)

* 模範解答は以下です

```swift
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
```
