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
 
*/


import SwiftUI

struct ChatbotView: View {
    @State private var isAnimating = false
    @State private var isSheetPresented = false
    
    var body: some View {
        ZStack {
//            Color(.theme)
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                Image(systemName: "globe")
//                    .imageScale(.large)
//                    .foregroundStyle(.tint)
//                
//                Text("HWIBOT TEST")
//            }
//            .padding()
            

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
                    .shadow(radius: 11)
            }
            .offset(x: 0, y: isAnimating ? -20 : 0)
            .position(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 60)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever()) {
                    isAnimating.toggle()
                }
            }
            
       
            if isSheetPresented {
                ChatBubble(isPresented: $isSheetPresented)
                    .transition(.move(edge: .bottom))
                    .zIndex(1) // Ensure it's above other views
            }
        }
    }
}

// ChatBubble view
struct ChatBubble: View {
    @Binding var isPresented: Bool
    @State private var message: String = "" // State to hold user input message
    @State private var messages: [String] = [] // Array to store chat messages
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .padding()
                        .clipShape(Circle())
                }
                .padding()
            }
            
        
            ScrollView {
                VStack(spacing: 10) {
                    // Iterate through messages and display each in a chat bubble
                    ForEach(messages, id: \.self) { msg in
                        HStack {
                            // Conditional styling based on whether message is from user or bot
                            if msg == message {
                                Spacer()
                                Text(msg)
                                    .padding(10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(ChatBubbleShape(isFromCurrentUser: true))
                                    .overlay(
                                        ChatBubbleShape(isFromCurrentUser: true)
                                            .stroke(Color.blue, lineWidth: 1)
                                    )
                            } else {
                                Spacer()
                                Text(msg)
                                    .padding(10)
                                    .background(Color.theme.opacity(0.3))
                                    .foregroundColor(.black)
                                    .clipShape(ChatBubbleShape(isFromCurrentUser: false))
                                    .overlay(
                                        ChatBubbleShape(isFromCurrentUser: false)
                                            .stroke(Color.theme.opacity(0.7), lineWidth: 1))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            
          
            HStack {
                TextField("Type your message here!", text: $message)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(36)
                    .overlay(RoundedRectangle(cornerRadius: 36).stroke(Color.gray).opacity(0.6))
                    .frame(height: 50)
                
                // Send button
                Button(action: {
                    if !message.isEmpty {
                        withAnimation {
                            messages.append(message)
                            message = "" // Clear input field
                        }
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
        .cornerRadius(36)
        .shadow(radius: 20)
        .padding(.horizontal)
        .frame(maxHeight: 670)
        .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
        .animation(.spring(), value: isPresented)
    }
}


struct ChatBubbleShape: Shape {
    var isFromCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = 16
        var path = Path() // Initialize path
        
        if isFromCurrentUser {
            // Draw chat bubble for messages sent by the current user
            path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        } else {
            // Chat bubble for messages received from others (not implemented yet)
            path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        }
        
        return path
    }
}

#Preview {
    ChatbotView()
}
