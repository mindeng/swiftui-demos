//
//  ContentView.swift
//  WordScramble
//
//  Created by Min Deng on 2023/10/9.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("根据单词中的字母拼出一个新单词", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.alphabet)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
                
                Section("得分") {
                    Text("\(score)")
                        .font(.largeTitle)
                }
            }
            .navigationTitle(rootWord)
            .toolbar {
                Button("重新开始", action: startGame)
            }
            .onSubmit(addNewWord)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear(perform: startGame)
        }
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
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
    
    func isLongEnough(word: String) -> Bool {
        word.count >= 3
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        if answer == rootWord {
            wordError(title: "你在抄袭", message: "请保持原创")
            return
        }
        
        guard isLongEnough(word: answer) else {
            wordError(title: "单词长度小于3", message: "有种你拼个长一点的！")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "这个词已经用过", message: "请再接再厉")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "单词不符合游戏规则", message: "必须使用 '\(rootWord)' 中的字母拼出一个新单词，且每个字母只能使用一次！")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "单词拼写错误", message: "你在瞎编乱造，你知道的！")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
            score += answer.count
        }
        
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                
                // clear states
                usedWords.removeAll()
                newWord = ""
                score = 0
                
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
}

#Preview {
    ContentView()
}
