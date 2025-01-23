//
//  ContentView.swift
//  iExpense
//
//  Created by Malak Yehia on 15/12/2024.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body : some View {
        NavigationStack {
            List {
                   Section(header: Text("Personal Expenses")) {
                       ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
                           HStack {
                               Text(item.name)
                               Spacer()
                               amountStyle(for: item.amount)
                           }
                       }
                       .onDelete(perform: removePersonalItems)
                   }
                   
                   Section(header: Text("Business Expenses")) {
                       ForEach(expenses.items.filter { $0.type == "Business" }) { item in
                           HStack {
                               Text(item.name)
                               Spacer()
                               amountStyle(for: item.amount)
                           }
                       }
                       .onDelete(perform: removeBusinessItems)
                   }
               }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    

    func removePersonalItems(at offsets: IndexSet) {
        let personalItems = expenses.items.filter { $0.type == "Personal" }
        for offset in offsets {
            if let index = expenses.items.firstIndex(of: personalItems[offset]) {
                expenses.items.remove(at: index)
            }
        }
    }

    func removeBusinessItems(at offsets: IndexSet) {
        let businessItems = expenses.items.filter { $0.type == "Business" }
        for offset in offsets {
            if let index = expenses.items.firstIndex(of: businessItems[offset]) {
                expenses.items.remove(at: index)
            }
        }
    }
    
    func amountStyle(for amount: Double) -> some View {
        if amount < 10 {
            return Text(amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD").presentation(.narrow)).foregroundStyle(.green)
       }
        else if amount < 100 {
            return Text(amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD").presentation(.narrow)).foregroundStyle(.orange).fontWeight(.medium)
        }
        else {
            return Text(amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD").presentation(.narrow)).foregroundStyle(.red).fontWeight(.medium)
        }
    }
}

#Preview {
    ContentView()
}
