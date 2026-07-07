//
//  SupabaseStorageService.swift
//  QuickMart
//
//  Created by siam on 07/07/2026.
//

import Foundation
import UIKit

enum SupabaseError: Error, LocalizedError {
    case invalidURL
    case uploadFailed(String)
    case invalidResponse
    case imageCompressionFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return AppStrings.Supabase.invalidURL
        case .uploadFailed(let msg): return AppStrings.Supabase.uploadFailed(msg)
        case .invalidResponse: return AppStrings.Supabase.invalidResponse
        case .imageCompressionFailed: return AppStrings.Supabase.imageCompressionFailed
        }
    }
}

class SupabaseStorageService {
    static let shared = SupabaseStorageService()
    
    private init() {}
    
    /// Uploads an image data to Supabase Storage and returns the public URL.
    /// - Parameter imageData: The image Data to upload.
    /// - Returns: The public URL string of the uploaded image.
    func uploadImage(imageData: Data) async throws -> String {
        let filename = "\(UUID().uuidString).jpg"
        let endpointString = "\(SupabaseConfig.projectURL)/storage/v1/object/\(SupabaseConfig.bucketName)/\(filename)"
        
        guard let url = URL(string: endpointString) else {
            throw SupabaseError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: imageData)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SupabaseError.invalidResponse
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            if httpResponse.statusCode == 403 {
                throw SupabaseError.uploadFailed(AppStrings.Supabase.permissionDenied)
            } else {
                throw SupabaseError.uploadFailed(AppStrings.Supabase.serverError)
            }
        }
        
        // Return public URL
        let publicURL = "\(SupabaseConfig.projectURL)/storage/v1/object/public/\(SupabaseConfig.bucketName)/\(filename)"
        return publicURL
    }
}
