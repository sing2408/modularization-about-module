//
//  AboutViewModel.swift
//  GamersHub
//
//  Created by Singgih Tulus Makmud on 30/04/25.
//

import SwiftUI
import PhotosUI
import Combine
import Core

public class AboutViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var profileImage: Image?
    @Published var hasChanges: Bool = false
    @Published var errorMessage: String?
    @Published var uiImage: UIImage?

    private let profileUseCase: ProfileUseCaseProtocol

    public init(profileUseCase: ProfileUseCaseProtocol) {
        self.profileUseCase = profileUseCase
        loadProfile()
    }

    func loadProfile() {
        let result = profileUseCase.getProfile()
        switch result {
        case .success(let profile):
            if let profile = profile {
                name = profile.name
                if let imageData = profile.imageData, let uiImage = UIImage(data: imageData) {
                    self.uiImage = uiImage
                    profileImage = Image(uiImage: uiImage)
                } else {
                    self.uiImage = UIImage(named: "default_profile")
                    profileImage = Image(uiImage: UIImage(named: "default_profile")!)
                }
            } else {
                name = "Singgih Tulus Makmud"
                self.uiImage = UIImage(named: "profile")
                profileImage = Image(uiImage: UIImage(named: "profile")!)
            }
        case .failure(let error):
            errorMessage = "Failed to load profile: \(error.localizedDescription)"
        }
    }

    func selectImage(imageData: Data) {
        if let uiImage = UIImage(data: imageData) {
            self.uiImage = uiImage
            profileImage = Image(uiImage: uiImage)
            hasChanges = true
        }
        
    }

     func updateName(newName: String) {
         name = newName
         hasChanges = true
     }

    func saveProfile() {
        let profile = Profile(name: name, imageData: uiImage?.jpegData(compressionQuality: 1.0))
        let result = profileUseCase.saveProfile(profile: profile)
        switch result {
        case .success:
            hasChanges = false
            loadProfile()
        case .failure(let error):
            errorMessage = "Failed to save profile: \(error.localizedDescription)"
        }
    }
}
