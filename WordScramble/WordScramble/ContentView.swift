//
//  ContentView.swift
//  WordScramble
//
//  Created by Malak Yehia on 26/11/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var newWord: String = ""
    @State private var rootWord: String = ""
    @State private var score: Int = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack{
            List {
                Section {
                    TextField("Enter Your Word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .focused($isFocused)
                }
                Section {
                    ForEach (usedWords, id: \.self) { word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                HStack {
                    Text("Score: \(score)")
                        .font(.headline)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError){}
        message: {
            Text("\(errorMessage)")
            }
        .toolbar {
            Button("Reset Word", action: startGame)
        }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isShorter(word: answer) else {
            wordError(title: "Word too short", message: "Add words longer than 2 letters")
            return
        }
        
        guard notRootWord(word: answer) else {
            wordError(title: "Same word as root", message: "No Cheating!")
            return
        }
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        score += answer.count
        newWord = ""
        isFocused = true
    }
    
    func startGame(){
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL, encoding: .utf8) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords = [String]()
                newWord = ""
                score = 0
                return
            }
        }
        fatalError("Couldn't load start.txt from Bundle.")

    }
    
    func isShorter(word: String) -> Bool {
        return word.count >= 3
    }
    
    func notRootWord(word: String) -> Bool {
        return word.lowercased() != rootWord.lowercased()
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word.lowercased())
    }
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let index = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: index)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
