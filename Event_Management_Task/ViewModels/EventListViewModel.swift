//
//  EventList.swift
//  Event_Management_Task
//
//  Created by HP's Mac on 30/08/25.
//
import Foundation

@MainActor
class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var query = ""
    @Published var page = 1
    
    private var searchTask: Task<Void, Never>? = nil
    
    // Load events
    func loadEvents(reset: Bool = false,
                    forSearch: Bool = false,
                    isSearching: Bool) async {
        
        if reset && isSearching {
            page = 1
            events.removeAll()
            events = await APIService.shared.fetchEvents(
                page: page,
                query: forSearch ? query : nil
            )
        } else if reset && !isSearching {
            events = await APIService.shared.fetchEvents(
                page: page,
                query: forSearch ? query : nil
            )
        }
        
        isLoading = true
        
        let newEvents = await APIService.shared.fetchEvents(page: page, query: forSearch ? query : nil)
        
        // To append new data on refresh
        if !reset {
            events.append(contentsOf: newEvents)

        } //else {
        // To assign new loaded events directly to the current array
//            events = newEvents
//        }
        
        page += 1
        isLoading = false
    }
    
    //Search function
    func triggerSearch() {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard let self = self, !Task.isCancelled else { return }
            
            if query.count >= 3 {
                await self.loadEvents(reset: true, forSearch: true, isSearching: true)
            } else if query.isEmpty {
                await self.loadEvents(reset: true, forSearch: false, isSearching: true)
            }
        }
    }
    
    //Pull to refresh function
    func refresh() async {
        searchTask?.cancel()
        query = ""
        await loadEvents(reset: true, forSearch: false, isSearching: false)
    }
}
