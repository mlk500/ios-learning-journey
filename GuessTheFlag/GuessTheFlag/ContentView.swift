//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Malak Yehia on 16/10/2024.
//

import SwiftUI

struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.largeTitle.weight(.bold))
    }
}

extension View {
    public func prominentTitle() -> some View {
        modifier(ProminentTitle())
    }
}
struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle: String = ""
    @State private var score: Int = 0
    @State private var totalQuestions = 0
    @State private var showRestart = false
    
    @State private var tappedFlag: Int? = nil
    @State private var flagRotation = [0.0, 0.0, 0.0]
    let numberOfQuestions: Int = 10
    @ViewBuilder func FlagImage(_ countryName: String) -> some View {
        Image(countryName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
                
            ], center: .top, startRadius: 200, endRadius: 700)
            //            LinearGradient(colors: [.black .opacity(0.7), .blue.opacity(0.6)], startPoint: .bottom, endPoint: .top)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .prominentTitle()
//                    .foregroundStyle(.white)
//                    .font(.largeTitle.weight(.bold))
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of ")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.heavy))
                    }
                    ForEach(0..<3) {
                        number in
                        Button {
                            flagTapped(number)
                        } label: {FlagImage(countries[number])}
                            .opacity(tappedFlag == nil || tappedFlag == number ? 1 : 0.25)
                            .scaleEffect(tappedFlag == nil || tappedFlag == number ? 1.0 : 0.75)
                            .rotation3DEffect(.degrees(flagRotation[number]), axis: (x: 0, y: 1, z: 0))
                            .animation(.easeInOut, value: tappedFlag)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        }
        message: {
            Text("Your score is \(score)")
        }
        .alert(scoreTitle, isPresented: $showRestart){
            Button("Restart", action: resetGame)
        }
        message: {
            Text("Your score is \(score)/\(numberOfQuestions). \nPress restart to play again.")
        }
        
        
        
    }
    func flagTapped(_ number: Int){
        tappedFlag = number
        withAnimation(.linear(duration: 1)) {
               flagRotation[number] += 360
           }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // value matches duration above
                if number == correctAnswer {
                    scoreTitle = "Correct!"
                    score += 1
                } else {
                    scoreTitle = "Wrong!\n That's the flag of \(countries[number])."
                }
                
                totalQuestions += 1
                if totalQuestions == numberOfQuestions {
                    scoreTitle = "Game Over"
                    showRestart = true
                } else {
                    showingScore = true
                }
                tappedFlag = nil
            }
    }
    
    func askQuestion(){
        correctAnswer = Int.random(in: 0...2)
        countries = countries.shuffled()
    }
    func resetGame(){
        score = 0
        totalQuestions = 0
        askQuestion()
    }
    
}

#Preview {
    ContentView()
}
