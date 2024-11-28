//
//  ContentView.swift
//  WeSplit
//
//  Created by Malak Yehia on 15/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State var checkAmount = 0.0
    @State var numberOfPeople = 1
    @State var tipPercentage = 20
    @State var someString: String = "Hello"
    let tipPercentages = [10, 15, 20, 25, 0]
    @FocusState var amountIsFocused: Bool
    var totalAmount: Double {
         Double(checkAmount) * (100.0 + Double(tipPercentage)) / 100.0
    }
    var totalPerPerson: Double {
        totalAmount / Double(numberOfPeople + 1)
    }
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    TextField("Amount ", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople){
                        ForEach(1..<100){
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    
                }
                Section("How much do you want to tip?") {
//                    Picker("Tip", selection: $tipPercentage){
//                        ForEach(tipPercentages, id: \.self){
//                            Text($0, format: .percent)
//                        }
//                    }
//                    .pickerStyle(.segmented)
                    Picker("Tip", selection: $tipPercentage) {
                        ForEach(0..<101, id: \.self){
                            Text("\($0)%")
                                .foregroundStyle(tipPercentage == 0 ? .red : .primary)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                }
                Section("Total amount") {
                    Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                Section("Amount per person") {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar{
                if amountIsFocused {
                    Button("Done"){
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

