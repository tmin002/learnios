import SwiftUI
import UIKit

struct UserMessage: View {
    var text: String
    init(_ text: String) {
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

struct ServerResponse: View {
    
    var chatResponse: ChatResponse
    var message: String?
    var detail: String?
    var backgroundColor: Color?
    var iconName: String?
    
    init(response: ChatResponse) {
        self.chatResponse = response
        self.message = response.message
        
        switch chatResponse.responseType {
        case .reminderAdded:
            self.detail = "Reminder added:"
                 + "\n\(chatResponse.targetReminder!.title),"
                 + "\(chatResponse.targetReminder!.getDate.description)"
            self.backgroundColor = Color.blue.opacity(0.3)
            self.iconName = "info.circle"
            if self.message == nil {
                self.message = "Reminder added!"
            }
            
        case .error:
            self.detail = "Error: \(response.detail!)"
            self.backgroundColor = Color.red.opacity(0.3)
            self.iconName = "exclamationmark.triangle"

        case .plainMessage:
            self.detail = nil
            self.backgroundColor = nil
            self.iconName = nil
        }
    }
    
    var body: some View {
        VStack {
            Image(systemName: "apple.terminal")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
            if let message = self.message {
                Text(message)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if self.chatResponse.responseType != .plainMessage {
                HStack {
                    Image(systemName: self.iconName!)
                        .padding(.horizontal, 10)
                    VStack {
                        Text(self.detail!)
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 10)
                    }
                }
                    .background(self.backgroundColor!)
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
    @State private var isWaitingResponse: Bool = false
    @State var chatViews: [AnyView] = []
    
    func send(_ text: String) -> Void {
        if isWaitingResponse {
            return
        }
        isWaitingResponse = true
        inputText = ""
        
        Task {
            do {
                self.chatViews.append(AnyView(UserMessage(text)))
                let response: ChatResponse = try await Chat.chat(text)
                self.chatViews.append(AnyView(ServerResponse(response: response)))
                isWaitingResponse = false
            } catch {
                self.chatViews.append(AnyView(ServerResponse(
                    response: ChatResponse(.error, detail: "Client error: \(error)"))))
                isWaitingResponse = false
            }
        }
    }
    
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
                Spacer()
                Button("Clear") {
                    chatViews.removeAll()
                }
                .padding(5)
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
                        ForEach(chatViews.indices, id: \.self) { index in
                            chatViews[index]
                        }
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
                    Button(action: {
                        self.send(inputText)
                    }) {
                        Image(systemName: "paperplane.fill")
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.white)
                            .background(self.isWaitingResponse ? Color.gray : Color.blue)
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
