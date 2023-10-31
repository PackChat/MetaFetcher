// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftSoup

public class MetaFetcher {
    
    enum MetaFetcherError: Error {
        case dataFailure
    }
    
    private let urlSession = URLSession(configuration: .ephemeral)
    
    public init() {}
    
    public func fetchFor(url: URL) async throws -> Metadata? {
        
        let htmlData = try await urlSession.data(from: url)
        guard let htmlString = String(data: htmlData.0, encoding: .utf8) else {
            throw MetaFetcherError.dataFailure
        }
        
        let parsedHTML = try SwiftSoup.parse(htmlString)
        
        var metadata = Metadata()
        
        // Extract title from <title> tag
        if let titleElement = try? parsedHTML.select("meta[property=og:title]").last() {
            metadata.title = try titleElement.attr("content")
        }
        
        // Extract image from <meta property="og:image"> or <meta name="image">
        if let imageElement = try? parsedHTML.select("meta[property=og:image], meta[name=image]").first() {
            let imageURLString = try imageElement.attr("content")
            metadata.imageURL = URL(string: imageURLString)
        }
        
        // Extract description from <meta name="description">
        if let descriptionElement = try? parsedHTML.select("meta[name=description]").first() {
            metadata.description = try descriptionElement.attr("content")
        }
        
        return metadata
    }
}
