SwiftUIでCoreDataからFetchしてきたデータを、ListViewのonMoveを使って任意の順番に入れ替えることができるようにしたもの。

1. Xcodeでプロジェクトを作成 xcode -> Version 13.3.1
2. SwiftUI, CoreDataを使用　にチェック
3. xcdatamodeldのEntityはItem, attributeはid:UUID, name:String, order:Int64に変更
4. Content.viewのとおり、Listに`onMove`と`onDelete`を追加し、それぞれの引数に指定する[関数](https://github.com/tsonobe1/SortableCoredata/blob/80e9779ae3a4410c642f13db2ca80d6d7c95597d/Sorted/ContentView.swift#L46)を定義
