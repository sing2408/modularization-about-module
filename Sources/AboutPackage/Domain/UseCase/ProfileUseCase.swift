//
//  ProfileUseCase.swift
//  About
//
//  Created by Singgih Tulus Makmud on 13/05/25.
//

import Foundation
import Core

public protocol ProfileUseCaseProtocol {
    func getProfile() -> Result<Profile?, Error>
    func saveProfile(profile: Profile) -> Result<Void, Error>
}

public class ProfileUseCase: ProfileUseCaseProtocol {
    private let profileRepository: ProfileRepositoryProtocol

    public init(profileRepository: ProfileRepositoryProtocol) {
        self.profileRepository = profileRepository
    }

    public func getProfile() -> Result<Profile?, Error> {
        return profileRepository.getProfile()
    }

    public func saveProfile(profile: Profile) -> Result<Void, Error> {
        return profileRepository.saveProfile(profile: profile)
    }
}

