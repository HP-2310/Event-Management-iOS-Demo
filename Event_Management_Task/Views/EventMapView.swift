//
//  EventMap.swift
//  Event_Management_Task
//
//  Created by HP's Mac on 30/08/25.
//
import SwiftUI
import MapKit

struct EventMapView: View {
    let events: [Event]
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629),
        span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
    )
    
    @State private var selectedIndex: Int? = nil
    
    private var eventsWithCoordinates: [Event] {
        events.filter { $0.latitude != nil && $0.longitude != nil }
    }
    
    var body: some View {
        ZStack {
            // MARK: Map with annotations
            Map(coordinateRegion: $region, annotationItems: eventsWithCoordinates) { event in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: event.latitude ?? 0,
                        longitude: event.longitude ?? 0
                    )
                ) {
                    Button {
                        if let idx = eventsWithCoordinates.firstIndex(where: { $0.id == event.id }) {
                            selectedIndex = idx
                            moveToEvent(eventsWithCoordinates[idx])
                        }
                    } label: {
                        Image(systemName: selectedIndex != nil && eventsWithCoordinates[selectedIndex!].id == event.id
                              ? "mappin.circle.fill"
                              : "mappin.circle")
                            .font(.title)
                            .foregroundColor(selectedIndex != nil && eventsWithCoordinates[selectedIndex!].id == event.id ? .blue : .red)
                    }
                }
            }
            .ignoresSafeArea()
            
            VStack {
                // MARK: Close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.trailing, 5)
                    }
                    .padding(.top)
                }
                Spacer()
                
                // MARK: Bottom card
                if let selectedIndex = selectedIndex {
                    EventCardView(event: eventsWithCoordinates[selectedIndex])
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width < -50 {
                                        // swipe left - previous
                                        if selectedIndex > 0 {
                                            self.selectedIndex = selectedIndex - 1
                                            moveToEvent(eventsWithCoordinates[self.selectedIndex!])
                                        }
                                    } else if value.translation.width > 50 {
                                        // swipe right - next
                                        if selectedIndex < eventsWithCoordinates.count - 1 {
                                            self.selectedIndex = selectedIndex + 1
                                            moveToEvent(eventsWithCoordinates[self.selectedIndex!])
                                        }
                                    }
                                }
                        )
                        .transition(.move(edge: .bottom))
                        .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            if let first = eventsWithCoordinates.first {
                selectedIndex = 0
                moveToEvent(first)
            }
        }
    }
    
    // MARK: Center map on selected event
    private func moveToEvent(_ event: Event) {
        if let lat = event.latitude, let lon = event.longitude {
            withAnimation {
                region.center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                region.span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            }
        }
    }
}


// MARK: Event Card
struct EventCardView: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Event image
            AsyncImage(url: URL(string: event.imageURL)) { img in
                img.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 150)
            .clipped()
            .cornerRadius(10)
            
            // Event details
            Text(event.name)
                .font(.headline)
                .lineLimit(1)
            
            if !event.date.isEmpty {
                Text("📅 \(event.date)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            if let price = event.ticketPrice {
                Text("🎟 $\(price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}

