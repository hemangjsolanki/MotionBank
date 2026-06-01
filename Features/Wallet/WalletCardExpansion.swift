import SwiftUI

struct WalletCardExpansion: View {
    @State private var isExpanded = false
    @Namespace private var animation
    
    let cards = ["Visa", "Mastercard", "Amex"]
    
    var body: some View {
        ZStack {
            if isExpanded {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(cards, id: \.self) { card in
                            WalletCardView(cardName: card)
                                .matchedGeometryEffect(id: card, in: animation)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        isExpanded.toggle()
                                    }
                                }
                        }
                    }
                    .padding()
                }
            } else {
                VStack(spacing: -150) {
                    ForEach(cards.indices, id: \.self) { index in
                        WalletCardView(cardName: cards[index])
                            .matchedGeometryEffect(id: cards[index], in: animation)
                            .offset(y: CGFloat(index * 20))
                            .scaleEffect(1.0 - CGFloat(index) * 0.05)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    isExpanded.toggle()
                                }
                            }
                    }
                }
                .padding()
            }
        }
    }
}

struct WalletCardView: View {
    let cardName: String
    
    var gradientColors: [Color] {
        switch cardName {
        case "Visa": return [Color.blue, Color.purple]
        case "Mastercard": return [Color.orange, Color.red]
        case "Amex": return [Color.gray, Color.black]
        default: return [Color.green, Color.blue]
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 220)
                .shadow(color: gradientColors.first!.opacity(0.4), radius: 15, x: 0, y: 10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("MotionBank")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text(cardName)
                        .font(.headline)
                        .fontWeight(.black)
                        .italic()
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "cpu")
                        .font(.title)
                        .foregroundColor(.yellow.opacity(0.8))
                        .rotationEffect(.degrees(90))
                    
                    Image(systemName: "wave.3.right")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.leading, 10)
                }
                .padding(.bottom, 10)
                
                Text("**** **** **** 4281")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .tracking(2)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("CARDHOLDER")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                        Text("HEMANG j. SOLANKI")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("VALID THRU")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                        Text("12/28")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 5)
            }
            .padding(25)
        }
    }
}
