//
//  ContentView.swift
//  MotionBankWidgetEntryView
//
//  Created by Hemang Solanki on 01/06/26.
//

import SwiftUI
import WidgetKit
import ActivityKit

struct MotionBankWidgetEntryView : View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Balance")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("$14,250.75")
                .font(.title2)
                .bold()
            
            Spacer()
            
            HStack {
                Image(systemName: "arrow.up.right")
                    .foregroundColor(.red)
                Text("$999.00 Apple")
                    .font(.caption2)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

// Note: A full Widget requires TimelineProvider and @main which conflicts with the app @main in a single file setup,
// so this serves as the UI showcase for the widget.

// Dynamic Island (Live Activity) Attributes
struct TransferAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var status: String
        var progress: Double
    }

    var transferAmount: String
    var recipientName: String
}
