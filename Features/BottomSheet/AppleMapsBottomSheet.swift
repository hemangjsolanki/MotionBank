import SwiftUI

struct ActivityInsightsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Header Summary
                        VStack(spacing: 10) {
                            Text("Total Spent This Month")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("$2,450.80")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                            
                            HStack(spacing: 5) {
                                Image(systemName: "arrow.down.right.circle.fill")
                                    .foregroundColor(.green)
                                Text("12% less than last month")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Advanced Spend Categories (Ring Chart Mockup)
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Top Categories")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            HStack(spacing: 20) {
                                // Circular Progress (Mocking a ring chart)
                                ZStack {
                                    Circle()
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                                    Circle()
                                        .trim(from: 0, to: 0.4)
                                        .stroke(Color.orange, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                    Circle()
                                        .trim(from: 0.45, to: 0.7)
                                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                    Circle()
                                        .trim(from: 0.75, to: 0.95)
                                        .stroke(Color.purple, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                    
                                    VStack {
                                        Text("Food")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text("40%")
                                            .font(.headline)
                                            .bold()
                                    }
                                }
                                .frame(width: 120, height: 120)
                                .padding()
                                
                                // Legend
                                VStack(alignment: .leading, spacing: 15) {
                                    CategoryLegend(color: .orange, name: "Food & Dining", amount: "$980")
                                    CategoryLegend(color: .blue, name: "Shopping", amount: "$612")
                                    CategoryLegend(color: .purple, name: "Transport", amount: "$490")
                                }
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }
                        
                        // Recent Transactions List (Embedded, no sheet)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Recent Transactions")
                                    .font(.headline)
                                Spacer()
                                Button("See All") { }
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 10) {
                                ForEach(Account.mock.transactions) { transaction in
                                    HStack {
                                        Image(systemName: transaction.iconName)
                                            .font(.title2)
                                            .frame(width: 50, height: 50)
                                            .background(Color.blue.opacity(0.1))
                                            .clipShape(Circle())
                                            .foregroundColor(.blue)
                                        
                                        VStack(alignment: .leading) {
                                            Text(transaction.title).font(.headline)
                                            Text(transaction.subtitle).font(.caption).foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Text(String(format: "$%.2f", transaction.amount))
                                            .font(.headline)
                                            .foregroundColor(transaction.isCredit ? .green : .primary)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .background(Color(UIColor.secondarySystemGroupedBackground))
                                    .cornerRadius(15)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Activity")
        }
    }
}

struct CategoryLegend: View {
    let color: Color
    let name: String
    let amount: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            VStack(alignment: .leading) {
                Text(name).font(.subheadline).bold()
                Text(amount).font(.caption).foregroundColor(.secondary)
            }
        }
    }
}

// Keep the old typealias so the rest of the app doesn't break
typealias AppleMapsBottomSheet = ActivityInsightsView
