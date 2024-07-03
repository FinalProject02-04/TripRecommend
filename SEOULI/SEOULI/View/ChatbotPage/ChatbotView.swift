//
//  ChatbotView.swift
//  SEOULI
//
//  Created by 김소리 on 6/25/24.
//

/*
 Author : 김수민
 
 Date : 2024.06.28 Friday
 Description : 1차 UI 작업, R&D 시작
 
 Date : 2024.07.01 Monday
 Description : 2차 UI 및 R&D 작업
 
 Date : 2024.07.02 Tuesady
 Description : R&D 작업
 
 Date : 2024.07.03 Wednesday
 Description : 모델사용해서 추천해주기(영어 가능)
 
*/

import SwiftUI

// MESSAGE MODEL
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromCurrentUser: Bool
}

struct ChatbotView: View {
    @State private var isAnimating = false
    @State private var isSheetPresented = false
    @State private var isLoading = false
    @State private var message = ""
    @State private var messages: [ChatMessage] = []
    @StateObject private var networkManager = NetworkManager()
    @FocusState private var isInputActive: Bool
    @State private var isFirstTimePresented = true

    var body: some View {
        ZStack {
            // HWIBOT Floating Button
            Button(action: {
                withAnimation(.spring()) {
                    isSheetPresented.toggle()
                }
            }) {
                Image("bot")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 40)
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .offset(x: 0, y: isAnimating ? -20 : 0)
            .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 60)
            .onAppear {
                startAnimation()
            }
            .onChange(of: isSheetPresented) {
                if !isSheetPresented {
                    startAnimation()
                }
            }
            
            // Chat Screen
            if isSheetPresented {
                ChatBubble(
                    isPresented: $isSheetPresented,
                    isLoading: $isLoading,
                    message: $message,
                    messages: $messages,
                    networkManager: networkManager
//                    isInputActive: $isInputActive
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
                .onAppear {
                    if isFirstTimePresented {
                        sendInitialMessage()
                        isFirstTimePresented = false
                    }
                }
            }
        }
    }
    private func sendInitialMessage() {
           let initialMessage = "추천받고 싶은 장소에 대한 키워드를 입력해주세요!😊"
           let botMessage = ChatMessage(text: initialMessage, isFromCurrentUser: false)
           messages.append(botMessage)
       }
   
    
    // ANIMATION FOR HWIBOT BUTTON
    private func startAnimation() {
        isAnimating = true
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            isAnimating.toggle()
        }
    }
}

// CHAT BUBBLE VIEW
struct ChatBubble: View {
    @Binding var isPresented: Bool
    @Binding var isLoading: Bool
    @Binding var message: String
    @Binding var messages: [ChatMessage]
    @ObservedObject var networkManager: NetworkManager
    @FocusState private var isInputActive: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        isPresented = false
                    }
                    isInputActive = false // Hide keyboard
                }) {
                    Image(systemName: "xmark")
                        .padding()
                        .clipShape(Circle())
                }
                .padding()
            }
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(messages, id: \.id) { msg in
                        if msg.isFromCurrentUser {
                            ChatBubbleRow(text: msg.text, isFromCurrentUser: true)
                        } else {
                            ChatBubbleRow(text: msg.text, isFromCurrentUser: false)
                        }
                    }
                    if isLoading {
                        LoadingBubbleView()
                    }
                }
                .padding(.vertical)
            }
            
            HStack {
                TextField("키워드를 입력하세요!", text: $message)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(36)
                    .overlay(RoundedRectangle(cornerRadius: 36).stroke(Color.gray.opacity(0.6), lineWidth: 1))
                    .frame(height: 50)
                    .focused($isInputActive)
                
                Button(action: {
                    if !message.isEmpty {
                        sendMessage()
                        message = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                        .padding(6)
                }
            }
            .padding(.bottom, 15)
            .padding()
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal)
        .frame(maxHeight: 500)
        .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
        .animation(.spring(), value: isPresented)
    }
    
        // SENDING MESSAGE FUNCTION
        private func sendMessage() {
            let userMessage = ChatMessage(text: message, isFromCurrentUser: true)
            messages.append(userMessage)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoading = true

                networkManager.fetchRecommendations(for: userMessage.text) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let recommendations):
                            let responseText = recommendations.joined(separator: "\n")
                            let responseMessage = ChatMessage(text: responseText, isFromCurrentUser: false)
                            messages.append(responseMessage)
                        case .failure(let error):
                            let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isFromCurrentUser: false)
                            messages.append(errorMessage)
                        }
                        isLoading = false
                    }
                }
            }
            message = "" // Clear the text field
            isInputActive = false // Hide keyboard
        }
    }
    
    
    // CHAT BUBBLE ROW VIEW
    struct ChatBubbleRow: View {
        let text: String
        let isFromCurrentUser: Bool
        
        var body: some View {
            HStack {
                if isFromCurrentUser {
                    Spacer()
                    Text(text)
                        .padding(10)
                        .background(Color.blue.opacity(0.9))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Text(text)
                        .padding(10)
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
            }
            .padding(.horizontal)
        }
    }
    

    // LOADING BUBBLE VIEW
    struct LoadingBubbleView: View {
        @State private var dot1Scale: CGFloat = 1.0
        @State private var dot2Scale: CGFloat = 1.0
        @State private var dot3Scale: CGFloat = 1.0
        
        var body: some View {
            HStack {
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color.gray.opacity(0.8))
                        .frame(width: 9, height: 9)
                        .scaleEffect(dot1Scale)
                        .animation(Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true), value: dot1Scale)
                    Circle()
                        .fill(Color.gray.opacity(0.8))
                        .frame(width: 9, height: 9)
                        .scaleEffect(dot2Scale)
                        .animation(Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true).delay(0.2), value: dot2Scale)
                    Circle()
                        .fill(Color.gray.opacity(0.8))
                        .frame(width: 9, height: 9)
                        .scaleEffect(dot3Scale)
                        .animation(Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true).delay(0.4), value: dot3Scale)
                }
                .padding(15)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(20)
                Spacer()
            }
            .onAppear {
                dot1Scale = 1.3
                dot2Scale = 1.3
                dot3Scale = 1.3
            }
            .padding(.horizontal)
        }
    }

#Preview {
    ChatbotView()
}
