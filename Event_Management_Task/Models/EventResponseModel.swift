//
//  Event.swift
//  Event_Management_Task
//
//  Created by HP's Mac on 30/08/25.
//
import Foundation

// MARK: Event List Response
struct EventListResponse: Codable {
    let status: String
    let message: String
    let data: EventListData
}

// MARK: Event List Data
struct EventListData: Codable {
    let numPages: Int
    let count: Int
    let totalCount: Int
    let results: [Event]
    
    enum CodingKeys: String, CodingKey {
        case numPages = "num_pages"
        case count
        case totalCount = "total_count"
        case results
    }
}

// MARK: Event Data
struct Event: Identifiable, Codable {
    let id: String
    let name: String
    let date: String
    let imageURL: String
    let longitude: Double?
    let latitude: Double?
    let categoryID: String?
    let category: String?
    let ticketPrice: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "event_id"
        case name = "event_name"
        case date = "event_date"
        case imageURL = "event_image_url"
        case longitude, latitude
        case categoryID = "event_category_id"
        case category = "event_category"
        case ticketPrice = "ticket_price"
    }
}

