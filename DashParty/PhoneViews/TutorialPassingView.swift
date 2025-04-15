//
//  TutorialPassingView.swift
//  DashParty
//
//  Created by Luana Bueno on 26/03/25.
//

import Foundation

import SwiftUI

struct TutorialPassingView: View {
    @Binding var router:Router
    var multipeerSession : MPCSession
    var hubManager = HUBPhoneManager.instance
    
    
    //MARK: TIRAR
    let user = HUBPhoneManager.instance.user
    @State var matchManager = HUBPhoneManager.instance.matchManager
    var users: [User] = [User(name: "A"), User(name: "B")]
    //MARK: TIRAR
    
    @State var pass : Bool = false
    
    var currentTutorialImage: [String] = ["tutorialPhone1", "tutorialPhone2", "tutorialPhone3", "tutorialPhone4", "tutorialPhone5", "tutorialPhone6"]
    
    var body: some View {
        ZStack {
            // Background do tutorial
            Image(currentTutorialImage[safe: hubManager.actualTutorialIndex] ?? "fallbackImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Botão de Start, posicionado fixo no rodapé com ZStack
            if hubManager.actualTutorialIndex == 1 {
                VStack {
                    Spacer()
                    if multipeerSession.host{
                        
                        
                        Button {
                            HUBPhoneManager.instance.startMatch = true
                            router = .game
                        } label: {
                            Image("startMatchButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }

                     
                }
            }

            // Botões de navegação no rodapé
            if multipeerSession.host{
                
                
                VStack {
                    Spacer()
                    HStack {
                        // BACK BUTTON
                        Button(action: {
                            if hubManager.actualTutorialIndex > 0 {
                                hubManager.actualTutorialIndex -= 1
                            }
                        }) {
                            Image("backYellowButton")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .opacity(hubManager.actualTutorialIndex == 0 ? 0.2 : 1.0)
                        }
                        
                        Spacer()
                        
                        // NEXT BUTTON
                        Button(action: {
                            if hubManager.actualTutorialIndex < currentTutorialImage.count - 1 {
                                hubManager.actualTutorialIndex += 1
                            }
                        }) {
                            Image("nextYellowButton")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .opacity(hubManager.actualTutorialIndex == 1 ? 0.2 : 1.0)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
            }
        }

        .onAppear {
            hubManager.actualTutorialIndex = 0
        }
        

                
            }
}
    
#Preview {
    TutorialPassingView(router: .constant(.tutorial), multipeerSession: MPCSessionManager.shared)
}


