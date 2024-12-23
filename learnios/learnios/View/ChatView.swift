import SwiftUI
import UIKit

struct UserMessage: View {
    var text: String
    init(_ text: String = "Hello") {
        self.text = text
    }
    
    var body: some View {
        Text(self.text)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct AIMessage: View {
    
    var message: String
    var responseDetail: String?
    var responseType: ChatResponse.ResponseType
    var targetReminder: Reminder?
    var error: Bool
    
    init(_ message: String = "Hello", responseDetail: String? = nil, responseType: ChatResponse.ResponseType = .plainMessage, targetReminder: Reminder? = nil) {
        self.message = message
        self.responseDetail = responseDetail
        self.responseType = responseType
        self.targetReminder = targetReminder
        self.error = (self.responseType == .error)
    }
    
    var body: some View {
        VStack {
            Image(systemName: "apple.terminal")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
            Text(self.message)
                .frame(maxWidth: .infinity, alignment: .leading)
                 
            
            if self.responseType != .plainMessage {
                HStack {
                    Image(systemName: self.error ? "exclamationmark.triangle" : "info.circle")
                        .padding(.horizontal, 10)
                    VStack {
                        Text(responseType.description())
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 10)
                        if let detail = self.responseDetail {
                            Text(detail)
                                .font(.callout)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 10)
                        }
                    }
                }
                    .background((self.error ? Color.red : Color.blue).opacity(0.3))
                    .cornerRadius(10)
                    .padding()
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct ChatView: View {
    @State private var inputText: String = "hello world"
    @State private var showAlarmList: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Reminders") {
                    showAlarmList = true
                }
                .padding(5)
                .sheet(isPresented: $showAlarmList) {
                    ReminderListView()
                }
            }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray)
                        .padding(.top, 44),
                    alignment: .bottom
                )
            VStack {
                ScrollView {
                    VStack {
                        UserMessage()
                        AIMessage("Hello! How can I help you today?", responseDetail: "server not respond", responseType: .error)
                        UserMessage()
                        AIMessage("Hello! How can I help you today?", responseType: .reminderAdded)
                        UserMessage()
                        AIMessage("Hello! How can I help you today?")
                        UserMessage()
                        AIMessage("Hello! How can I help you today?")
                        UserMessage()
                        AIMessage("Hello! How can I help you today?")
                    }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                }
                HStack {
                    TextEditor(text: $inputText)
                        .frame(height: 50)
                        .background(.gray)
                        .padding(Edge.Set.horizontal, 10)
                        .multilineTextAlignment(.leading)
                    Button(action: {}) {
                        Image(systemName: "paperplane.fill")
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .padding(10)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(15)
            }
        }
    }
}

#Preview {
    ChatView()
}
