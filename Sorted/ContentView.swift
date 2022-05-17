//
//  ContentView.swift
//  Sorted
//
//  Created by 薗部拓人 on 2022/05/17.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.order, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.name!)")
                    } label: {
                        Text("order -> \(item.order)").bold()
                    }
                    
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: moveItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }
    // 以下の関数を.onMoveの引数に指定することで、CoreDataのオブジェクトを、任意の順番で自由に操作することができる
    private func moveItems(from source: IndexSet, to destination: Int) {
        // itemsを昇順時、list.toMoveでitemを上から下(orderを増加)させた時の処理
        // Source.first!=移動前のindex,  destination=移動後の"index + 1" -> index+1なので注意
        if source.first! < destination {
            // objectsShouldChange = 変更すべきitemを示すindex
            let objectsShouldChange:[Int] = Array(source.first! + 1...destination - 1)
            for i in objectsShouldChange{
                items[i].order = Int64(i - 1)
            }
            // ユーザが操作したitemのorderを更新,
            items[source.first!].order = Int64(destination - 1)
        }
        
        // itemsを昇順時、list.toMoveでitemを下から上(orderを減少)させた時の処理
        // Source.first!=移動前のindex,  destination=移動後の"index" -> index+0なので注意
        else if source.first! > destination {
            let objectsShouldChange:[Int] = Array(destination..<source.first!)
            for i in objectsShouldChange{
                items[i].order = Int64(i + 1)
            }
            items[source.first!].order = Int64(destination)
        }
        try? self.viewContext.save()
    }
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.name = "Person X"
            newItem.id = UUID()
            newItem.order = Int64(items.count)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            // Entitiyのorderの値を連続にする
            for (index, item) in items.enumerated() {
                if item.order != index{
                    item.order = Int64(index)
                }
            }
            
            do {
                try viewContext.save()
                print("\(items.count)")
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
