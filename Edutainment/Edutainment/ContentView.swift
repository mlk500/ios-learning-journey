import SwiftUI

struct ContentView: View {
    @State private var table = 2
    @State private var selectedNumber = 5
    @State private var questions: [Question] = []
    @State private var userAnswers: [UserAnswer] = []
    @State private var numOfCorrectAnswers: Int = 0
    @State private var isGameActive = false
    @State private var showResults = false
    
    let numOfQuestions = [5, 10, 20]
    
    struct Question {
        var text: String
        var answer: Int
    }
    
    struct UserAnswer {
        var answer: String
        var isCorrect: Bool?
        var intAnswer: Int? {
            Int(answer)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.red.opacity(0.6), Color.blue.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            //            VStack{
            //                settingsView
            //                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            //                gameView
            //                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            //            }
            
            if !isGameActive {
                settingsView
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            } else {
                gameView
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            }
        }
        .animation(.spring(), value: isGameActive)
        
    }
    
    var settingsView: some View {
        VStack (spacing: 20){
            Text("Multiplication Master")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            VStack(alignment: .leading, spacing: 10) {
                Text("Choose multiplication table")
                    .font(.headline)
                    .foregroundStyle(.black)
                Stepper(value: $table, in: 2...12,
                        label: {
                    Text("Table of \(table)")
                        .foregroundColor(.black)
                })
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.2))
                )
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Number of Questions")
                    .font(.headline)
                    .foregroundStyle(.black)
                Picker("Number of Questions", selection: $selectedNumber) {
                    ForEach(numOfQuestions, id: \.self) {number in
                        Text("\(number)")
                            .tag(number)
                    }
                }
                .pickerStyle(.segmented)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.2))
                )
                .padding(.horizontal)
            }
            Button(action: startGame) {
                Text("Start Game")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.green)
                    )
                    .shadow(radius: 10)
            }
            .padding()
        }
        .padding()
        
    }
    
    var gameView: some View {
        VStack {
            if !showResults {
                VStack (spacing: 20){
                    Text("Table of \(table)")
                        .font(.title)
                        .fontWeight(.bold)
                    List {
                        ForEach(questions.indices, id: \.self) { index in
                            let question = questions[index]
                            HStack {
                                Text(question.text)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                                TextField("?", text: $userAnswers[index].answer)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 60)
                                    .multilineTextAlignment(.center)
                                if let isCorrect = userAnswers[index].isCorrect {
                                    Image(systemName: isCorrect ? "checkmark.circle" : "xmark.circle")
                                        .foregroundColor(isCorrect ? .green : .red)
                                        .transition(.scale)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(.plain)
                    Button("Check Answers") {
                        checkAnswers()
                        showResults = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            else {
                ResultView(
                    correctAnswers: numOfCorrectAnswers,
                    totalQuestions: selectedNumber,
                    onPlayAgain: resetGame
                )
            }
        }
    }
    struct ResultView: View {
        let correctAnswers: Int
        let totalQuestions: Int
        let onPlayAgain: () -> Void
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Game Over!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("You got \(correctAnswers) out of \(totalQuestions) correct!")
                    .font(.title2)
                
                HStack(spacing: 15) {
                    Text(resultEmoji)
                        .font(.system(size: 60))
                    
                    VStack(alignment: .leading) {
                        Text(resultMessage)
                            .font(.headline)
                        
                        Text(resultEncouragement)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Button("Play Again") {
                    onPlayAgain()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.9))
                    .shadow(radius: 10)
            )
            .transition(.scale)
        }
        var resultEmoji: String {
            switch Double(correctAnswers) / Double(totalQuestions) {
            case 0.9...1.0: return "🏆"
            case 0.7..<0.9: return "🌟"
            case 0.5..<0.7: return "👍"
            default: return "💪"
            }
        }
        var resultMessage: String {
            switch Double(correctAnswers) / Double(totalQuestions) {
            case 0.9...1.0: return "Excellent!"
            case 0.7..<0.9: return "Great Job!"
            case 0.5..<0.7: return "Good Effort!"
            default: return "Keep Practicing!"
            }
        }
        var resultEncouragement: String {
            switch Double(correctAnswers) / Double(totalQuestions) {
            case 0.9...1.0: return "You're a multiplication master!"
            case 0.7..<0.9: return "You're getting really good!"
            case 0.5..<0.7: return "You're improving!"
            default: return "Practice makes perfect!"
            }
        }
    }
    
    struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.green)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .shadow(radius: 10)
        }
    }
    
    func startGame() {
        generateQuestions()
        isGameActive = true
        showResults = false
        numOfCorrectAnswers = 0
    }
    
    func generateQuestions() {
        questions = []
        userAnswers = []
        for _ in  (0..<selectedNumber) {
            let num1 = Int.random(in: 1...table)
            let answer = num1 * table
            let text = "\(table) x \(num1) = "
            questions.append(Question(text: text, answer: answer))
            userAnswers.append(UserAnswer(answer: ""))
        }
    }
    func checkAnswers() {
        for (index, question) in questions.enumerated() {
            if let userAnswer = userAnswers[index].intAnswer, userAnswer == question.answer {
                numOfCorrectAnswers+=1
                userAnswers[index].isCorrect = true
            }
            else {
                userAnswers[index].isCorrect = false
            }
        }
    }
    func resetGame() {
        isGameActive = false
        showResults = false
        numOfCorrectAnswers = 0
        questions = []
        userAnswers = []
    }
}

#Preview {
    ContentView()
}

