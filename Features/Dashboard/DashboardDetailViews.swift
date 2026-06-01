import SwiftUI
import CoreImage.CIFilterBuiltins

struct Recipient: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let phone: String
    let iconColor: Color
}

struct SendMoneyView: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.presentationMode) var presentationMode
    @State private var amount: String = "0"
    @State private var showingRecipientList = false
    
    var formattedAmount: String {
        let parts = amount.split(separator: ".", omittingEmptySubsequences: false)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        if let wholePart = parts.first,
           let wholeNumber = Double(String(wholePart)),
           let formattedWhole = formatter.string(from: NSNumber(value: wholeNumber)) {
            
            if amount.contains(".") {
                if parts.count > 1 {
                    return "\(formattedWhole).\(parts[1])"
                } else {
                    return "\(formattedWhole)."
                }
            } else {
                return formattedWhole
            }
        }
        return amount
    }
    
    @State private var selectedRecipient: Recipient? = Recipient(name: "Sarah Jenkins", phone: "+1 (555) 123-4567", iconColor: .blue)
    
    let mockRecipients = [
        Recipient(name: "Sarah Jenkins", phone: "+1 (555) 123-4567", iconColor: .blue),
        Recipient(name: "Michael Chen", phone: "+1 (555) 987-6543", iconColor: .purple),
        Recipient(name: "Emma Watson", phone: "+1 (555) 555-0192", iconColor: .green),
        Recipient(name: "David Smith", phone: "+1 (555) 246-8101", iconColor: .orange)
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        // Transfer Details (To & From)
                        VStack(spacing: 0) {
                            HStack {
                                Text("To")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(width: 50, alignment: .leading)
                                
                                Button(action: {
                                    showingRecipientList = true
                                }) {
                                    HStack {
                                        if let recipient = selectedRecipient {
                                            Image(systemName: "person.circle.fill")
                                                .font(.title)
                                                .foregroundColor(recipient.iconColor)
                                            VStack(alignment: .leading) {
                                                Text(recipient.name).bold().foregroundColor(.primary)
                                                Text(recipient.phone).font(.caption).foregroundColor(.secondary)
                                            }
                                        } else {
                                            Image(systemName: "person.crop.circle.badge.plus")
                                                .font(.title)
                                                .foregroundColor(.blue)
                                            Text("Select Recipient").bold().foregroundColor(.primary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.caption).foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding()
                            
                            Divider().padding(.leading, 65)
                            
                            HStack {
                                Text("From")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(width: 50, alignment: .leading)
                                
                                HStack {
                                    Image(systemName: "creditcard.fill")
                                        .font(.title2)
                                        .foregroundColor(.purple)
                                        .frame(width: 32)
                                    VStack(alignment: .leading) {
                                        Text("Everyday Checking").bold()
                                        Text("Available: $\(String(format: "%.2f", globalState.account.balance))").font(.caption).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right").font(.caption).foregroundColor(.gray)
                                }
                            }
                            .padding()
                        }
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    }
                }
                
                Spacer(minLength: 0)
                
                // Fixed Amount Entry Area (Always Visible)
                VStack(spacing: 10) {
                    Text("Amount")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("$\(formattedAmount)")
                        .font(.system(size: 65, weight: .bold, design: .rounded))
                        .foregroundColor(Double(amount) ?? 0 > globalState.account.balance ? .red : .primary)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding(.horizontal)
                    
                    if Double(amount) ?? 0 > globalState.account.balance {
                        Text("Insufficient funds")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else {
                        Text("No fee for this transfer")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 15)
                
                // Keypad Area
                VStack(spacing: 20) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                        ForEach(1...9, id: \.self) { number in
                            KeypadButton(text: "\(number)") {
                                if amount == "0" { amount = "\(number)" }
                                else if amount.count < 8 { amount += "\(number)" }
                            }
                        }
                        KeypadButton(text: ".") {
                            if !amount.contains(".") { amount += "." }
                        }
                        KeypadButton(text: "0") {
                            if amount != "0" { amount += "0" }
                        }
                        KeypadButton(text: "<") {
                            if amount.count > 1 { amount.removeLast() }
                            else { amount = "0" }
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    // Action Button
                    Button(action: {
                        if let value = Double(amount), value > 0, value <= globalState.account.balance {
                            globalState.sendMoney(amount: value)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Send Money")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                (Double(amount) ?? 0) > 0 && (Double(amount) ?? 0) <= globalState.account.balance
                                ? Color.blue
                                : Color.gray.opacity(0.5)
                            )
                            .cornerRadius(20)
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled((Double(amount) ?? 0) <= 0 || (Double(amount) ?? 0) > globalState.account.balance)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top, 20)
                .background(
                    Color(UIColor.systemBackground)
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                        .shadow(color: Color.black.opacity(0.05), radius: 10, y: -5)
                )
            }
        }
        .navigationTitle("Send Money")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingRecipientList) {
            NavigationView {
                List(mockRecipients) { recipient in
                    Button(action: {
                        selectedRecipient = recipient
                        showingRecipientList = false
                    }) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(recipient.iconColor)
                            VStack(alignment: .leading) {
                                Text(recipient.name).bold().foregroundColor(.primary)
                                Text(recipient.phone).font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            if selectedRecipient?.id == recipient.id {
                                Image(systemName: "checkmark").foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .navigationTitle("Select Recipient")
                .navigationBarItems(trailing: Button("Cancel") {
                    showingRecipientList = false
                })
            }
        }
    }
}

// Helper for corner radius on specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct KeypadButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.title)
                .fontWeight(.medium)
                .frame(width: 80, height: 80)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(Circle())
                .foregroundColor(.primary)
        }
    }
}

struct ReceiveMoneyView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Show this QR code to receive money instantly.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.secondary)
            
            if let qrImage = generateQRCode(from: "MB-9421-4829") {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
            }
            
            Text("HEMANG j. SOLANKI")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                Text("Wallet ID:")
                Text("MB-9421-4829")
                    .fontWeight(.bold)
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding(.top, 40)
        .navigationTitle("Receive Money")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
}

struct TopUpView: View {
    var body: some View {
        List {
            Section(header: Text("Funding Sources")) {
                HStack {
                    Image(systemName: "building.columns.fill")
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text("Chase Bank")
                        Text("**** 1234").font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                
                HStack {
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.orange)
                    VStack(alignment: .leading) {
                        Text("Apple Card")
                        Text("**** 8899").font(.caption).foregroundColor(.secondary)
                    }
                }
            }
            
            Section {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Funding Source")
                    }
                }
            }
        }
        .navigationTitle("Top Up")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MoreSettingsView: View {
    @EnvironmentObject var globalState: GlobalState
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingLogoutPopup = false
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    // Profile Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 100, height: 100)
                            Text(String(globalState.account.cardHolder.prefix(1)))
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        
                        Text(globalState.account.cardHolder)
                            .font(.title2)
                            .bold()
                        
                        Text("Member since 2024")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Account Details Card
                    VStack(spacing: 15) {
                        DetailCopyRow(title: "Account Number", value: "3948 2910 8472")
                        Divider()
                        DetailCopyRow(title: "Routing Number", value: "021000021")
                        Divider()
                        DetailCopyRow(title: "Account Type", value: "Saving")
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Preferences Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Preferences")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            NavigationLink(destination: NotificationSettingsView()) {
                                ProfileNavRow(icon: "bell.fill", color: .red, title: "Notifications")
                            }
                            Divider().padding(.leading, 50)
                            NavigationLink(destination: PrivacySettingsView()) {
                                ProfileNavRow(icon: "hand.raised.fill", color: .blue, title: "Privacy & Security")
                            }
                        }
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 20)
                    
                    // Logout Button (Source of animation)
                    if !showingLogoutPopup {
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                showingLogoutPopup = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Secure Log Out")
                            }
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)
                    } else {
                        // Placeholder to maintain layout space
                        Color.clear
                            .frame(height: 55)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.inline)
            
            // Animated Popup Overlay
            if showingLogoutPopup {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            showingLogoutPopup = false
                        }
                    }
                    .zIndex(1)
                
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                    
                    Text("Secure Log Out")
                        .font(.title2)
                        .bold()
                    
                    Text("Are you sure you want to securely log out of your MotionBank account?")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 10)
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                showingLogoutPopup = false
                            }
                        }) {
                            Text("Cancel")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                showingLogoutPopup = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                globalState.showNotification(message: "Logged Out Successfully", icon: "checkmark.circle.fill", color: .green)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("Log Out")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(25)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(25)
                .shadow(color: Color.red.opacity(0.15), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 30)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
                .zIndex(2)
            }
        }
    }
}

struct DetailCopyRow: View {
    @EnvironmentObject var globalState: GlobalState
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .bold()
                    .foregroundColor(.primary)
            }
            Spacer()
            Button(action: {
                UIPasteboard.general.string = value
                globalState.showNotification(message: "\(title) Copied", icon: "doc.on.doc", color: .blue)
            }) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.blue)
                    .font(.subheadline)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
        }
    }
}

struct ProfileNavRow: View {
    let icon: String
    let color: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(color)
                .frame(width: 30, height: 30)
                .background(color.opacity(0.1))
                .cornerRadius(8)
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct NotificationSettingsView: View {
    @State private var pushEnabled = true
    @State private var emailEnabled = false
    @State private var smsEnabled = true
    @State private var largeTransfers = true
    
    var body: some View {
        Form {
            Section(header: Text("Alert Channels")) {
                Toggle("Push Notifications", isOn: $pushEnabled)
                Toggle("Email Alerts", isOn: $emailEnabled)
                Toggle("SMS Text Messages", isOn: $smsEnabled)
            }
            
            Section(header: Text("Transaction Alerts")) {
                Toggle("Large Transfers (>$500)", isOn: $largeTransfers)
                Toggle("International Purchases", isOn: .constant(true))
                Toggle("Card Declined", isOn: .constant(true))
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacySettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("Security Features")) {
                HStack {
                    Text("Face ID for Login")
                    Spacer()
                    Image(systemName: "checkmark").foregroundColor(.blue)
                }
                HStack {
                    Text("Two-Factor Authentication")
                    Spacer()
                    Text("Enabled").foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Data Privacy")) {
                Button("Manage App Permissions") {}
                Button("Download My Data") {}
                Button("Request Account Deletion") {}.foregroundColor(.red)
            }
        }
        .navigationTitle("Privacy & Security")
        .navigationBarTitleDisplayMode(.inline)
    }
}
