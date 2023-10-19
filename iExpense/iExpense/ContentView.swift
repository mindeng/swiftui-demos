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
    
    var personalExpenses: [ExpenseItem] {
        expenses.items.filter {
            $0.type == "Personal"
        }
    }
    
    var businessExpenses: [ExpenseItem] {
        expenses.items.filter {
            $0.type == "Business"
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("Personal") {
                    ForEach(personalExpenses) { item in
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
                    .onDelete(perform: {
                        removeItems(isPersonal: true, at: $0)
                    })
                }
                
                Section("Business") {
                    ForEach(businessExpenses) { item in
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
                    .onDelete(perform: {
                        removeItems(isPersonal: false, at: $0)
                    })
                }
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
    
    func removeItems(isPersonal: Bool, at offsets: IndexSet) {
//        expenses.items.remove(atOffsets: offsets)
        let items = isPersonal ? personalExpenses : businessExpenses
        offsets.forEach { idx in
            expenses.items.removeAll { item in
                item.id == items[idx].id
            }
        }
    }
}

#Preview {
    ContentView()
}
