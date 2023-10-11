//
//  GoogleView.swift
//  MOBILE
//
//  Created by Hugo Dubois on 09/10/2023.
//

import SwiftUI
import Alamofire

struct TokenCheckResponse: Decodable {
    let google: Bool
}

struct GoogleConnectView: View {
    @State private var isConnectedToGoogle: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            if !isConnectedToGoogle {
                Button("Se connecter", action: connectGoogle)
                if let error = errorMessage {
                    Text(error).foregroundColor(.red)
                }
            } else {
                Text("Connected to Google")
            }
        }
        .onAppear(perform: checkGoogleConnectionStatus)
    }
    
    func checkGoogleConnectionStatus() {
        if let authToken = AuthManager.getAuthToken() {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + authToken
            ]
            
            AF.request("http://127.0.0.1:8000/api/checktokens", method: .get, headers: headers)
                .responseDecodable(of: TokenCheckResponse.self) { response in
                    switch response.result {
                    case .success(let tokenStatus):
                        self.isConnectedToGoogle = tokenStatus.google
                    case .failure(let error):
                        self.errorMessage = "Erreur lors de la vérification de la connexion à Google: \(error.localizedDescription)"
                    }
                }
        } else {
            errorMessage = "AuthToken est nul"
        }
    }
    
    func connectGoogle() {
        if let authToken = AuthManager.getAuthToken() {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + authToken
            ]
            
            AF.request("http://127.0.0.1:8000/api/oauth2callback", method: .get, headers: headers)
                .responseString { response in
                    switch response.result {
                    case .success(let urlString):
                        if let urlObj = URL(string: urlString) {
                            UIApplication.shared.open(urlObj)
                        } else {
                            self.errorMessage = "URL non valide"
                        }
                    case .failure(let error):
                        errorMessage = "Erreur lors de la connexion à Google: \(error.localizedDescription)"
                    }
                }
        } else {
            errorMessage = "AuthToken est nul"
        }
    }
}

struct GoogleConnectView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleConnectView()
    }
}
