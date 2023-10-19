//
//  ContentView.swift
//  iExpense
//
//  Created by Min Deng on 2023/10/13.
//

import SwiftUI

struct ContentView: View {
    // 只有创建实例时使用 @StateObject, 其他地方都使用 @ObservedObject
    @StateObject var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading, content: {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        })
                        
                        Spacer()
                        Text(
                            item.amount,
                            format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                        )
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
