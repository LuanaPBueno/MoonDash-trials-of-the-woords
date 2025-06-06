//
//  PlayerSceneView .swift
//  DashParty
//
//  Created by Luana Bueno on 27/03/25.
//

import Foundation
import SwiftUI
import SceneKit

struct PlayerSceneView: View {
    var users: [User]
    @State var currentWinner : PlayerState?
    @State var ranking: [PlayerState]?
    @State var audioManager: AudioManager = AudioManager()
    var index: Int
    var multipeerSession = MPCSessionManager.shared
    @State var rankingTimer: Timer?
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var matchManager: MatchManager
    var currentSituation: Bool { GameInformation.instance.allPlayers[index].currentSituation }
    var currentChallenge: Challenge { GameInformation.instance.allPlayers[index].currentChallenge }
    @State var startTime = Date.now
    @State var finishTime: Date?
    @State var characterImage: Image = Image("characterFront")
    @State var winnerTimer: Timer?
    
    
    var body: some View {
        ZStack {
            if index < matchManager.scenes.count {
                SceneView(scene: matchManager.scenes[index])
                    .onChange(of: GameInformation.instance.allPlayers[index].currentChallenge, { oldValue, newValue in
                        matchManager.checkAddChallenge(distance: Float(GameInformation.instance.allPlayers[index].progress), playerIndex: index)
                    })
                    .frame(width: .infinity, height: .infinity)
                    .background(.brown)
                    .ignoresSafeArea()
            }
            VStack{
                HStack{
                    Text("")
                    if let ranking = ranking,
                       let position = ranking.firstIndex(where: { $0.name == GameInformation.instance.allPlayers[index].name}) {
                        Image("ranking\(position+1)")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .padding(.top, 120)
                            .padding(.leading, 120)
                    }
                    Spacer()
                }
                Spacer()
                
            }
            if GameInformation.instance.allPlayers[index].youWon {
                if let position = ranking?.firstIndex(where: { $0.name == GameInformation.instance.allPlayers[index].name }), position == 0 {
                    Image("youWon")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Image("youFinished")
                }

            }
        }
        .onDisappear{
            rankingTimer?.invalidate()
            rankingTimer = nil
        }
        .task {
//            audioManager.playSound(named: "Run Music")
            startTime = .now
            rankingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                DispatchQueue.main.async {
                    ranking = matchManager.startRankingUpdates()
                    if let ranking = ranking {
                        for player in ranking {
                            GameInformation.instance.allRank.append(player.name)
                        }
                    }
                   
                    self.currentWinner = ranking?.first
                    print("Current winner: \(currentWinner?.name ?? "None")")
                }
            }
            let message = "StartTime"
            if let data = message.data(using: .utf8) {
                multipeerSession.sendDataToAllPeers(data: data)
            }
            characterImage = GameInformation.instance.allPlayers[index].userClan?.image ?? Image("characterFront")
            GameInformation.instance.newGame = false
        }
        
        
    }
}
