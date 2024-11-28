//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Malak Yehia on 24/11/2024.
//

import SwiftUI

struct ContentView: View {
    var moves = ["Rock", "Paper", "Scissors"]
    @State var currMove = Int.random(in: 0..<3)
    @State var winLose = Bool.random()
    @State var score: Int = 0
    @State var playerMove: String = ""
    @State var rounds = 0
    @State private var showRestart = false
    let maxRounds = 10
    func checkMoves(_ playerChoice: String){
        let computerMove = moves[currMove]
        if computerMove == playerChoice{
            resetRound()
            return
        }
        switch winLose {
            case true:
            if shouldWin(playerMove: playerChoice, computerMove: computerMove){
                score += 1
            }
        case false:
            if !shouldWin(playerMove: playerChoice, computerMove: computerMove){
                score += 1
            }
        }
        resetRound()
        
    }
    
    func shouldWin(playerMove: String, computerMove: String) -> Bool{
        switch (playerMove, computerMove){
        case ("Rock", "Scissors"), ("Paper", "Rock"), ("Scissors", "Paper"):
            print("returning true for \(playerMove) and \(computerMove)")
            return true
        default:
            print("returning false for \(playerMove) and \(computerMove)")
            return false
    }
    }
    func resetRound(){
        winLose = Bool.random()
        currMove = Int.random(in: 0..<3)
        rounds += 1
        if rounds == maxRounds {
            showRestart.toggle()
        }
    }
    func resetGame(){
        score = 0
        rounds = 0
        winLose = Bool.random()
        currMove = Int.random(in: 0..<3)
    }
    var body: some View {
        VStack {
            ProgressView(value: Double(rounds), total: Double(maxRounds))
                .padding(.horizontal)
            Text("\(rounds)/\(maxRounds) Rounds")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Score: \(score)" )
                .font(.title)
                .padding()
            Text("Current Move: \(moves[currMove])")
                .font(.title)
                .foregroundStyle(.blue)
                .padding()
            Text("You need to \(winLose ? "Win" : "Lose")")
                .foregroundStyle(winLose ? .green : .red)
                .font(.title)
                .padding()
            HStack {
                ForEach(moves, id:\.self){
                    move in Button(action: {
                        checkMoves(move)
                    }){
                        Text(emojoMove(move))
                            .font(.system(size: 50))
                            .background(Color.blue.opacity(0.15))
                            .cornerRadius(10)
                            .padding(.horizontal, 5)
                    }
                    
                }
            }
            .alert("You Scored \(score) out of \(maxRounds)", isPresented: $showRestart){
                Button("Restart", action: resetGame)
            }
                
        }
        .padding()
    }
    
    func emojoMove(_ move: String) -> String{
        switch move {
        case "Rock":
            return "🪨"
        case "Paper":
            return "📄"
        case "Scissors":
            return "✂️"
        default:
            return ""
        }
    }
}

#Preview {
    ContentView()
}
