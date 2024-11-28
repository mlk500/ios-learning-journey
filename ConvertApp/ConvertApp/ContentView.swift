//
//  ContentView.swift
//  ConvertApp
//
//  Created by Malak Yehia on 16/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var input = 0.0
    var output = 0.0
    let units = ["Meters", "Kilometers", "Feet", "Yards", "Miles"]
    @State var unitFrom = "Meters"
    @State var unitTo = "Kilometers"
    @FocusState var inputFocused: Bool
    
    var result: Double {
        let meterValues = [1.0, 1000.0, 0.3048, 0.9144, 1609.34]
        if let fromIndex = units.firstIndex(of: unitFrom), let toIndex = units.firstIndex(of: unitTo){
            let inputInMeters = input * meterValues[fromIndex]
            let output = inputInMeters / meterValues[toIndex]
            return output
        }
        return 0.0
    }
    
    var body: some View {
        NavigationStack {
            Form{
                Section("Enter Value to Convert") {
                    TextField("Enter a value", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputFocused)
                }
                Section ("Choose Unit to convert From") {
                    Picker("Unit from", selection: $unitFrom){
                        ForEach(units, id: \.self){
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                }
                Section ("Choose Unit to convert To") {
                    Picker("Unit from", selection: $unitTo){
                        ForEach(units, id: \.self){
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                }
                
                Section ("Conversion Result") {
                    //                    Text(result, format: .number) + Text(" \(unitFrom)")
                    Text(result, format: .number.precision(.fractionLength(2))) + Text(" \(unitTo)")
                }
            }
            .navigationTitle("Length Converion")
            .toolbar {
                if inputFocused {
                    Button("Done") {
                        inputFocused = false
                    }
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
