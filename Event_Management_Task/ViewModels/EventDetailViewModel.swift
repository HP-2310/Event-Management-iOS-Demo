//
//  EventDetail.swift
//  Event_Management_Task
//
//  Created by HP's Mac on 30/08/25.
//
import Foundation

import Foundation

@MainActor
class EventDetailViewModel: ObservableObject {
    @Published var event: EventDetail?
    @Published var isLoading = false
    
    func loadEventDetail(id: String) async {
        isLoading = true
        event = await APIService.shared.fetchEventDetail(id: id)
        isLoading = false
    }
}

