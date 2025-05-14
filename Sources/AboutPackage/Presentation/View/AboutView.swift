//
//  ProfileView.swift
//  GamersHub
//
//  Created by Singgih Tulus Makmud on 04/04/25.
//

import SwiftUI
import PhotosUI

public struct AboutView: View {
    @StateObject var viewModel: AboutViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var isSaved: Bool = false
    @State private var saveButtonOpacity: Double = 1.0
    @State private var saveButtonScale: CGFloat = 1.0
    @State private var saveButtonColor: Color = .blue

    public init(viewModel: AboutViewModel) { 
            _viewModel = StateObject(wrappedValue: viewModel)
        }

    public var body: some View {
        NavigationView {
            VStack {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 150, height: 150)

                    if let image = viewModel.profileImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                }

                PhotosPicker(selection: $selectedItem,
                               matching: .images,
                               preferredItemEncoding: .automatic) {
                    Text("Choose Photo")
                }
                .padding(.top, 10)
                .onChange(of: selectedItem) {
                    if let newItem = selectedItem {
                        Task {
                            if let data = try? await newItem.loadTransferable(type: Data.self) {
                                viewModel.selectImage(imageData: data)
                            }
                        }
                    }
                }

                VStack(alignment: .center) {
                    Text("Name:")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                    TextField("Type your name", text: $viewModel.name)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                        .multilineTextAlignment(.center)
                        .onChange(of: viewModel.name) { _, newName in
                            viewModel.updateName(newName: newName)
                        }
                }

                Spacer()

                Button {
                    viewModel.saveProfile()
                    isSaved = true

                    withAnimation(.easeInOut(duration: 0.3)) {
                        saveButtonColor = .green
                        saveButtonScale = 0.8
                        saveButtonOpacity = 0.5
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            saveButtonOpacity = 0.0
                        }
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isSaved = false
                        saveButtonColor = .blue
                        saveButtonScale = 1.0
                        saveButtonOpacity = 1.0
                    }

                } label: {
                    Text("Save Profile")
                        .padding()
                        .foregroundColor(.white)
                        .background(saveButtonColor)
                        .cornerRadius(8)
                        .scaleEffect(saveButtonScale)
                        .opacity(saveButtonOpacity)

                }
                .padding(.bottom)
                .disabled(!viewModel.hasChanges)
                .opacity(viewModel.hasChanges ? 1.0 : 0.5)

            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
