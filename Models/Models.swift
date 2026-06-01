import Foundation

struct Transaction: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let amount: Double
    let date: Date
    let iconName: String
    let isCredit: Bool
}

struct Account: Identifiable {
    let id = UUID()
    let balance: Double
    let cardNumber: String
    let cardHolder: String
    let cardType: String
    let transactions: [Transaction]
}

extension Account {
    static let mock = Account(
        balance: 14250.75,
        cardNumber: "**** **** **** 4281",
        cardHolder: "HEMANG J. SOLANKI",
        cardType: "Visa",
        transactions: [
            Transaction(title: "Apple Store", subtitle: "Electronics", amount: 999.00, date: Date(), iconName: "applelogo", isCredit: false),
            Transaction(title: "Salary", subtitle: "Monthly Income", amount: 5500.00, date: Date().addingTimeInterval(-86400 * 2), iconName: "briefcase.fill", isCredit: true),
            Transaction(title: "Starbucks", subtitle: "Coffee", amount: 5.50, date: Date().addingTimeInterval(-86400 * 3), iconName: "cup.and.saucer.fill", isCredit: false)
        ]
    )
}
