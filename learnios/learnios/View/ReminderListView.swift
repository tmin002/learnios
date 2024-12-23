import SwiftUI
import UIKit

struct ReminderView: View {
    var body: some View {
        HStack {
            VStack {
                Text("wake me up at 6am")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Image(systemName: "clock")
                    Text("2024-09-09 12:34:44")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            Button(action: {}) {
                Image(systemName: "trash")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct ReminderListView: View {
    var body: some View {
        Text("Reminders")
            .font(.title)
            .fontWeight(.bold)
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        VStack(alignment: .trailing) {
            VStack {
                ReminderView()
                ReminderView()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .padding()
    }
}

#Preview {
    ReminderListView()
}
