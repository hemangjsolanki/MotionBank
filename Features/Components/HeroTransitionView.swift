import SwiftUI

struct HeroTransitionView: View {
    @Namespace var animation
    @State private var selectedCard: String? = nil
    
    let cards = ["Visa", "Mastercard", "Amex"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 30) {
                        ForEach(cards, id: \.self) { card in
                            if selectedCard != card {
                                WalletCardView(cardName: card)
                                    .matchedGeometryEffect(id: "card_\(card)", in: animation)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            selectedCard = card
                                        }
                                    }
                                    .padding(.horizontal)
                            } else {
                                // Placeholder space to keep scroll position
                                Color.clear.frame(height: 220)
                            }
                        }
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                }
                .navigationTitle("My Cards")
                
                // Detail Overlay
                if let selected = selectedCard {
                    CardDetailOverlay(
                        cardName: selected,
                        animation: animation,
                        onClose: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                selectedCard = nil
                            }
                        }
                    )
                }
            }
        }
    }
}

struct CardDetailOverlay: View {
    let cardName: String
    var animation: Namespace.ID
    var onClose: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Close Button (Now scrolls with content)
                    HStack {
                        Spacer()
                        Button(action: onClose) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                                .padding(.trailing, 20)
                                .padding(.top, 20)
                        }
                    }
                    
                    // Header Card
                    VStack {
                        WalletCardView(cardName: cardName)
                            .matchedGeometryEffect(id: "card_\(cardName)", in: animation)
                            .padding(.top, 10)
                            .padding(.horizontal)
                    }
                    
                    // Action Buttons
                    HStack(spacing: 30) {
                        NavigationLink(destination: LockCardView()) {
                            DetailActionButton(icon: "lock.fill", title: "Lock Card", color: .red)
                        }
                        NavigationLink(destination: CardDetailsView()) {
                            DetailActionButton(icon: "eye.fill", title: "Show Details", color: .blue)
                        }
                        NavigationLink(destination: CardLimitsView()) {
                            DetailActionButton(icon: "slider.horizontal.3", title: "Limits", color: .green)
                        }
                        NavigationLink(destination: CardSettingsView()) {
                            DetailActionButton(icon: "gearshape.fill", title: "Settings", color: .gray)
                        }
                    }
                    .padding(.top, 10)
                    .buttonStyle(PlainButtonStyle())
                    
                    // Card Details Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Card Information")
                            .font(.title3)
                            .bold()
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            InfoRow(title: "Card Name", value: "Everyday \(cardName)")
                            Divider().padding(.leading)
                            InfoRow(title: "Credit Limit", value: "$10,000.00")
                            Divider().padding(.leading)
                            InfoRow(title: "Available Credit", value: "$4,250.00")
                            Divider().padding(.leading)
                            InfoRow(title: "Next Payment Due", value: "Oct 15, 2026")
                        }
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    // Transactions
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Recent on this card")
                            .font(.title3)
                            .bold()
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            ForEach(Account.mock.transactions.prefix(2)) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                }
            }
        }
        .transition(.opacity)
        .zIndex(1)
    }
}

struct DetailActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.1))
                .clipShape(Circle())
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
    }
}
