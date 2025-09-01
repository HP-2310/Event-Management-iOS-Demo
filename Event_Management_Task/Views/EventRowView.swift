//
//  EventRow.swift
//  Event_Management_Task
//
//  Created by HP's Mac on 30/08/25.
//
import SwiftUI

struct EventRowView: View {
    let event: Event
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: event.imageURL))
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.headline)
                
                Text(event.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if let price = event.ticketPrice {
                    Text("₹\(price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
