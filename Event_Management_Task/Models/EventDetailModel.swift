//
//  EventDetailModel.swift
//  Event_Management_Task
//
//  Created by HP's Mac on 31/08/25.
//
import Foundation

// MARK: Event Detail Response
struct EventDetailResponse: Codable {
    let status: String
    let message: String
    let data: EventDetail
}

// MARK: Event Details
struct EventDetail: Identifiable, Codable {
    let id: String
    let name: String
    let description: String?
    let date: String
    let imageURLs: [String]
    let longitude: Double?
    let latitude: Double?
    let categoryID: String?
    let category: String?
    let attendees: Int?
    let ticketPrice: Double?
    let organizerContact: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "event_id"
        case name = "event_name"
        case description = "event_description"
        case date = "event_date"
        case imageURLs = "event_image_urls"
        case longitude, latitude
        case categoryID = "event_category_id"
        case category = "event_category"
        case attendees = "num_attendees"
        case ticketPrice = "ticket_price"
        case organizerContact = "organizer_contact"
    }
}
