//
//  InputColumn.swift
//  DesignWeek23
//
//  Created by Peter Kolski on 08.05.23.
//

import SwiftUI

struct InputColumn: View {
    @ObservedObject var viewModel: ImageGeneratorModel
    var folderName: String
    
    var body: some View {
        VStack {
            TextInputSection(viewModel: viewModel)
            
            if let errorMessage = viewModel.errorMessage {
                ErrorMessageSection(errorMessage: errorMessage)
            }
            
            StyleSelectionSection(viewModel: viewModel)
            
            GenerateButtonSection(viewModel: viewModel, folderName: folderName)
        }
    }
}

struct TextInputSection: View {
    @ObservedObject var viewModel: ImageGeneratorModel
    
    var body: some View {
        VStack {
            HStack {
                Text("1.")
                    .modifier(RedTextStyle())
                Text("Type your vision")
                    .modifier(WhiteBigTextStyle())
                Spacer()
            }
            TextField("Enter text", text: $viewModel.text, axis: .vertical)
                .modifier(MyTextFieldStyle())
                .lineLimit(4, reservesSpace: true)
                .padding([.leading, .trailing], 50)
        }
    }
}

struct ErrorMessageSection: View {
    var errorMessage: String
    
    var body: some View {
        Text(errorMessage)
            .foregroundColor(.red)
            .padding()
    }
}

struct StyleSelectionSection: View {
    @ObservedObject var viewModel: ImageGeneratorModel
    
    var body: some View {
        VStack {
            HStack {
                Text("2.")
                    .modifier(RedTextStyle())
                Text("Choose Your Style")
                    .modifier(WhiteBigTextStyle())
                Spacer()
            }
            HStack {
                StyleView(promtAddition: $viewModel.promtAddition)
                    .padding([.leading, .trailing], 100)
                Spacer()
            }
        }
    }
}

struct GenerateButtonSection: View {
    @ObservedObject var viewModel: ImageGeneratorModel
    var folderName: String
    
    var body: some View {
        HStack {
            Text("3.")
                .modifier(RedTextStyle())
            Button("Generate image") {
                viewModel.generateImage(folderName: folderName) { result in
                    switch result {
                    case .success(let image):
                        DispatchQueue.main.async {
                            viewModel.image = image
                            viewModel.errorMessage = nil
                        } 
                    case .failure(let error):
                        DispatchQueue.main.async {
                            viewModel.image = nil
                            viewModel.errorMessage = error.localizedDescription
                        }
                    }
                }
            }
            .font(.largeTitle)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.pink]), startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .bold()
            .cornerRadius(25)
            .padding()
            .shadow(color: .black, radius: 5, x: 5, y: 5)
            Spacer()
        }
        .padding(10)
    }
}

struct InputColumn_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            InputColumn(viewModel: ImageGeneratorModel(), folderName: "Nix")
        }
    }
}
