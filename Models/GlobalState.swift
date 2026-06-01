import Foundation
import SwiftUI

struct AppNotification: Equatable {
    let message: String
    let icon: String
    let color: Color
}

class GlobalState: ObservableObject {
    @Published var account: Account = Account.mock
    @Published var currentNotification: AppNotification? = nil
    
    func sendMoney(amount: Double) {
        guard amount > 0 && amount <= account.balance else { return }
        account = Account(
            balance: account.balance - amount,
            cardNumber: account.cardNumber,
            cardHolder: account.cardHolder,
            cardType: account.cardType,
            transactions: [
                Transaction(title: "Transfer Sent", subtitle: "To Contact", amount: amount, date: Date(), iconName: "arrow.up.right", isCredit: false)
            ] + account.transactions
        )
        showNotification(message: "$\(String(format: "%.2f", amount)) Sent Successfully", icon: "checkmark.circle.fill", color: .green)
    }
    
    func updateLimit(newLimit: Double) {
        showNotification(message: "Daily Limit Updated to $\(Int(newLimit))", icon: "slider.horizontal.3", color: .blue)
    }
    
    func lockCard(isLocked: Bool) {
        let message = isLocked ? "Card Locked Successfully" : "Card Unlocked Successfully"
        let color: Color = isLocked ? .red : .green
        showNotification(message: message, icon: isLocked ? "lock.fill" : "lock.open.fill", color: color)
    }
    
    func showNotification(message: String, icon: String, color: Color) {
        withAnimation(.spring()) {
            currentNotification = AppNotification(message: message, icon: icon, color: color)
        }
        
        // Haptic Feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Auto-hide
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.spring()) {
                if self.currentNotification?.message == message {
                    self.currentNotification = nil
                }
            }
        }
    }
}

struct NotificationBannerModifier: ViewModifier {
    @EnvironmentObject var state: GlobalState
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            if let notification = state.currentNotification {
                HStack {
                    Image(systemName: notification.icon)
                        .foregroundColor(notification.color)
                        .font(.title2)
                    Text(notification.message)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .padding(.top, 50)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(100)
            }
        }
    }
}

extension View {
    func withNotificationBanner() -> some View {
        self.modifier(NotificationBannerModifier())
    }
}
