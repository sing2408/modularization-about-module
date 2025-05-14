//
//  ProfileRepository.swift
//  GamersHub
//
//  Created by Singgih Tulus Makmud on 30/04/25.
//

import Foundation
import CoreData
import Core

public class ProfileRepository: ProfileRepositoryProtocol {
    
    let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func getProfile() -> Result<Profile?, Error> {
        let fetchRequest = NSFetchRequest<ProfileCoreData>(entityName: "ProfileCoreData")
        fetchRequest.fetchLimit = 1
        
        do {
            let profileEntity = try context.fetch(fetchRequest).first
            if let profileEntity = profileEntity {
                let profile = Profile(name: profileEntity.name ?? "", imageData: profileEntity.imageData)
                return .success(profile)
            } else {
                return .success(nil)
            }
        } catch {
            return .failure(error)
        }
    }
    
    public func saveProfile(profile: Profile) -> Result<Void, Error> {
        let fetchRequest = NSFetchRequest<ProfileCoreData>(entityName: "ProfileCoreData")
        fetchRequest.fetchLimit = 1
        
        do {
            let existingProfileEntity = try context.fetch(fetchRequest).first
            let profileEntity: ProfileCoreData
            
            if let existingProfileEntity = existingProfileEntity {
                profileEntity = existingProfileEntity
            } else {
                profileEntity = ProfileCoreData(context: context)
            }
            
            profileEntity.name = profile.name
            profileEntity.imageData = profile.imageData
            
            try context.save()
            return .success(())
            
        } catch {
            return .failure(error)
        }
    }
}
