import SwiftUI

struct CardSettingsView: View {
    @State private var onlineTransactions = true
    @State private var atmWithdrawals = true
    @State private var foreignTransactions = false
    
    var body: some View {
        Form {
            Section(header: Text("Security")) {
                Toggle("Online Transactions", isOn: $onlineTransactions)
                Toggle("ATM Withdrawals", isOn: $atmWithdrawals)
                Toggle("Foreign Transactions", isOn: $foreignTransactions)
            }
            
            Section(header: Text("Card Management")) {
                Button("Report Lost or Stolen") {}.foregroundColor(.red)
                Button("Replace Card") {}
                Button("Change PIN") {}
            }
        }
        .navigationTitle("Card Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LockCardView: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var isLocked = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                .font(.system(size: 80))
                .foregroundColor(isLocked ? .red : .green)
                .padding()
            
            Text(isLocked ? "Card is Locked" : "Card is Active")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Locking your card will prevent any new purchases or ATM withdrawals. Recurring subscriptions may still be processed.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Toggle("Lock Card", isOn: Binding(
                get: { isLocked },
                set: { newValue in
                    isLocked = newValue
                    globalState.lockCard(isLocked: newValue)
                }
            ))
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(15)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 40)
        .navigationTitle("Lock Card")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CardLimitsView: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.presentationMode) var presentationMode
    @State private var dailyLimit: Double = 1500
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Daily Spending Limit")
                .font(.title2)
            
            Text("$\(Int(dailyLimit))")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.blue)
            
            Slider(value: $dailyLimit, in: 500...5000, step: 100)
                .padding(.horizontal, 40)
            
            HStack {
                Text("$500")
                Spacer()
                Text("$5000")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: {
                globalState.updateLimit(newLimit: dailyLimit)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Changes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .padding()
        }
        .padding(.top, 40)
        .navigationTitle("Limits")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CardDetailsView: View {
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        List {
            Section(header: Text("Card Information")) {
                InfoRow(title: "Card Holder", value: globalState.account.cardHolder)
                InfoRow(title: "Card Number", value: globalState.account.cardNumber)
                InfoRow(title: "Expiration", value: "12/28")
                InfoRow(title: "CVV", value: "***")
            }
            
            Section(header: Text("Billing Address")) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(globalState.account.cardHolder)
                    Text("1234 Silicon Valley Rd")
                    Text("San Francisco, CA 94107")
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("Card Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
