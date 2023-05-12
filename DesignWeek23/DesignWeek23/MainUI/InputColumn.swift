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
        VStack(spacing: 0) {
            TextInputSection(viewModel: viewModel)
            
            StyleSelectionSection(viewModel: viewModel)
            
            GenerateButtonSection(viewModel: viewModel, folderName: folderName)
            Spacer()
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
                .padding([.top,.bottom], -30)
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
            generateButton
                .padding(.trailing,70)
            Spacer()
        }
        .padding(10)
    }
}

extension GenerateButtonSection {
    var generateButton: some View {
        Button( action: {
            viewModel.generateImage(folderName: folderName) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        viewModel.image = image
                    }
                case .failure(let error):
                    print("ERROR: GenerateButtonSection - Not generated viewModel.generateImage(folderName: folderName) ")
                }
            }
        }) {
            let gradient = Gradient(colors: [Color(red: 19/100, green: 9/100, blue: 84/100),
                                             Color(red: 54/100, green: 34/100, blue: 96/100)])
            let linearGradient = LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing)
            
            Text("Generate")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .padding(10)
                .padding([.leading, .trailing], 90)
                .background(linearGradient)
                .cornerRadius(60)
                .frame(maxWidth: .infinity)
        }
        .shadow(color: .black, radius: 5, x: 5, y: 5)
    }
}

struct InputColumn_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            InputColumn(viewModel: ImageGeneratorModel(), folderName: "Nix")
        }
    }
}
