import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Balance Header
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Total Balance")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(String(format: "$%.2f", globalState.account.balance))
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .shimmer(when: isLoading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Wallet Cards
                    WalletCardExpansion()
                        .padding(.top, 10)
                        .shimmer(when: isLoading)
                    
                    // Actions
                    HStack(spacing: 20) {
                        NavigationLink(destination: SendMoneyView()) {
                            ActionButton(icon: "arrow.up.right", title: "Send")
                        }
                        NavigationLink(destination: ReceiveMoneyView()) {
                            ActionButton(icon: "arrow.down.left", title: "Receive")
                        }
                        NavigationLink(destination: TopUpView()) {
                            ActionButton(icon: "plus", title: "Top Up")
                        }
                        NavigationLink(destination: MoreSettingsView()) {
                            ActionButton(icon: "ellipsis", title: "More")
                        }
                    }
                    .padding(.horizontal)
                    .shimmer(when: isLoading)
                    .buttonStyle(PlainButtonStyle())
                    
                    // Transactions
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Recent Activity")
                            .font(.title3)
                            .bold()
                        
                        ForEach(globalState.account.transactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                    .padding(.horizontal)
                    .shimmer(when: isLoading)
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .background(AppColors.dynamicBackground)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { isLoading = false }
            }
        }
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 60, height: 60)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
                .foregroundColor(.blue)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: transaction.iconName)
                .font(.title2)
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.headline)
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(String(format: "%@$%.2f", transaction.isCredit ? "+" : "-", transaction.amount))
                .font(.headline)
                .foregroundColor(transaction.isCredit ? .green : .primary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(15)
    }
}
