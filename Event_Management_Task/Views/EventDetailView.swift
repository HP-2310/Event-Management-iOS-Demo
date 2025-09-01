//
//  EventDetails.swift
//  Event_Management_Task
//
//  Created by HP's Mac on 30/08/25.
//
import SwiftUI

struct EventDetailView: View {
    let eventID: String
    @StateObject private var viewModel = EventDetailViewModel()
    
    var body: some View {
        VStack {
            if let event = viewModel.event {
                VStack(spacing: 20) {
                    
                    // Hero Image Carousel
                    TabView {
                        ForEach(event.imageURLs, id: \.self) { urlStr in
                            if let url = URL(string: urlStr) {
                                AsyncImage(url: url) { img in
                                    img.resizable().scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(height: 250)
                                .clipped()
                            }
                        }
                    }
                    .frame(height: 250)
                    .tabViewStyle(PageTabViewStyle())
                    
                    // Event Title
                    Text(event.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    // Event Description
                    if let desc = event.description {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text(desc)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Event Info Section
                    VStack(alignment: .leading, spacing: 12) {
                        if !event.date.isEmpty {
                            HStack {
                                Text("Date")
                                    .font(.headline).bold()
                                Spacer()
                                Text(event.date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        if let price = event.ticketPrice {
                            HStack {
                                Text("Ticket Price")
                                    .font(.headline).bold()
                                Spacer()
                                Text("$\(price, specifier: "%.2f")")
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                            }
                        }
                        
                        if let attendees = event.attendees {
                            HStack {
                                Text("Attendees")
                                    .font(.headline).bold()
                                Spacer()
                                Text("\(attendees)")
                                    .font(.subheadline)
                            }
                        }
                        
                        if let email = event.organizerContact {
                            HStack {
                                Text("Email")
                                    .font(.headline).bold()
                                Spacer()
                                Text(email)
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            } else if viewModel.isLoading {
                ProgressView("Loading details…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("❌ Failed to load event details")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadEventDetail(id: eventID)
        }
    }
}
