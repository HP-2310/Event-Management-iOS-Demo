//
//  APIServices.swift
//  Event_Management_Task
//
//  Created by HP's Mac on 30/08/25.
//
import Foundation

class APIService {
    static let shared = APIService()
    private init() {}
    
    func fetchEvents(page: Int = 1,
                     query: String? = nil,
                     category: String? = nil,
                     startDate: String? = nil,
                     endDate: String? = nil) async -> [Event] {
        
        do {
            var urlComponents = URLComponents(string: "http://18.208.147.119/events")!
            
            var queryItems = [
                URLQueryItem(name: "items_per_page", value: "20"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
            if let query = query, !query.isEmpty {
                queryItems.append(URLQueryItem(name: "search", value: query))
            }
            if let category = category {
                queryItems.append(URLQueryItem(name: "event_category_id", value: category))
            }
            if let start = startDate, let end = endDate {
                queryItems.append(URLQueryItem(name: "start_date", value: start))
                queryItems.append(URLQueryItem(name: "end_date", value: end))
            }
            
            urlComponents.queryItems = queryItems
            
            let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
            let decoded = try JSONDecoder().decode(EventListResponse.self, from: data)
            return decoded.data.results
            
        } catch {
            print("❌ Error fetching events: \(error.localizedDescription)")
            return []
        }
    }
    
    // Fetch Event Detail
    func fetchEventDetail(id: String) async -> EventDetail? {
        do {
            let url = URL(string: "http://18.208.147.119/events/\(id)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(EventDetailResponse.self, from: data)
            return decoded.data
        } catch {
            print("❌ Error fetching event detail: \(error.localizedDescription)")
            return nil
        }
    }
}
