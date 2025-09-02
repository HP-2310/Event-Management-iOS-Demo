//
//  Discover.swift
//  Event_Management_Task
//
//  Created by HP's Mac on 30/08/25.
//
import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel = EventListViewModel()
    @State private var showMap = false
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading && viewModel.events.isEmpty {
                    // Loading state
                    ProgressView("Loading events...")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if viewModel.events.isEmpty {
                    // Empty state
                    Text("No events found")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    // Events list
                    ForEach(viewModel.events) { event in
                        NavigationLink(destination: EventDetailView(eventID: event.id)) {
                            EventRowView(event: event)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.refresh()
            }
            .navigationTitle("Event List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showMap = true }) {
                        Image(systemName: "map")
                    }
                }
            }
            .searchable(text: $viewModel.query, prompt: "Search events")
            .onChange(of: viewModel.query) { _ in
                viewModel.triggerSearch()
            }
            // load data initially
            .task {
                if viewModel.events.isEmpty {
                    await viewModel.loadEvents(reset: true, forSearch: false, isSearching: false)
                }
            }
            // Map screen
            .sheet(isPresented: $showMap) {
                EventMapView(events: viewModel.events)
            }
        }
    }
}



