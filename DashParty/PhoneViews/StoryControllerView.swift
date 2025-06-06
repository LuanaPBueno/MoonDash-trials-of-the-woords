//
//  narrativePassingView.swift
//  DashParty
//
//  Created by Luana Bueno on 26/03/25.
//

import Foundation
import SwiftUI

struct StoryControllerView: View {
    @Binding var router:Router
    var multipeerSession : MPCSession = MPCSessionManager.shared
    
    //    var multipeerSession : MPCSession!
    var hubManager = GameInformation.instance
    //    @State private var navigate: Bool = false
    @State private var isActive = false
    @State private var showAlert = false
    @State private var showAlert2 = false
    
    var body: some View {
        ZStack{
            Image("illustrationTitle")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            HStack {
                Spacer()
                VStack{
                    Button {
                        showAlert2 = true
                        
                    } label: {
                        Image("skip")
                    }
                    .padding(.top, 40)
                    Spacer()
                }
                
            }
            .padding(.trailing, 40)
            
            VStack {
                
                Spacer()
                
                Text("Look at the screen and enjoy the story!")
                    .multilineTextAlignment(.center)
                    .font(.custom("TorukSC-Regular", size: 30))
                    .padding(40)
                    .foregroundColor(.white)
                Image("decorativeRectCream")
                
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: {
                                if hubManager.actualPage > 0 {
                                    hubManager.actualPage -= 1
                                }
                                else {
                                    print("entrou aq no else no back ")
                                    //                                    router = .matchmaking
                                }
                            }) {
                                Image("backNarrativeButton")
                                
                                
                                
                            }
                            
                            
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            
                            Button(action: {
                                if hubManager.actualPage < hubManager.narrativeText.count - 1 {
                                    hubManager.actualPage += 1
                                } else {
                                    print("entrou aqui no pass")
                                    router = .tutorial
                                    //showAlert = true
                                }
                            }) {
                                Image("passNarrativeButton")
                                
                                
                            }
                            
                            Spacer()
                        }
                            .padding(.horizontal, 24)
                    )
                Spacer()
                
            }
            .task{
                GameInformation.instance.users = GameInformation.instance.allPlayers.map { player in
                    return User(
                        id: player.id,
                        name: ""
                    )
                }
            }
//            .alert("The narrative has ended. Do you want to start the tutorial?", isPresented: $showAlert) {
//                Button("OK") {
//                    router = .tutorial
//                }
//                Button("Cancel", role: .cancel) {
//                    
//                }
//            }
            .alert("Are you sure you want to skip the narrative?", isPresented: $showAlert2) {
                Button("OK") {
                    hubManager.actualPage = hubManager.narrativeText.count - 1
                    router = .tutorial
                }
                Button("Cancel", role: .cancel) { }
                
            }
            
            
            
        }
    }
    
}

#Preview {
    StoryControllerView(router: .constant(.storyBoard))
}
