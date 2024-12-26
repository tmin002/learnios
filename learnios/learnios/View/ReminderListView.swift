import SwiftUI
import UIKit

struct ReminderView: View {
    var body: some View {
        HStack {
            VStack {
                Text(self.reminder.title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Image(systemName: "clock")
                    Text(self.reminder.getDate.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            Button(action: {
                Task {
                    do {
                        try await Reminder.removeReminderFromServer(reminder: self.reminder)
                        self.container.updateReminderViews()
                    } catch {
                        print("error while delete: \(error)")
                    }
                }
            }) {
                Image(systemName: "trash")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    let reminder: Reminder
    let container: ReminderListView
    init(_ reminder: Reminder, _ container: ReminderListView) {
        self.reminder = reminder
        self.container = container
    }
}

struct ReminderListView: View {
    @State private var reminders: [Reminder] = []
    
    var body: some View {
        Text("Reminders")
            .font(.title)
            .fontWeight(.bold)
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        VStack(alignment: .trailing) {
            VStack {
                ForEach(reminders, id: \.id) { reminder in
                    ReminderView(reminder, self)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .padding()
        .onAppear {
            updateReminderViews()
        }
    }
    
    func updateReminderViews() -> Void {
        Task {
            do {
                let reminders: [Reminder] = try await Reminder.getRemindersFromServer()
                self.reminders = reminders
            } catch {
               print("error while update: \(error)")
            }
        }
    }
    
    init() {
        updateReminderViews()
    }
}

#Preview {
    ReminderListView()
}
