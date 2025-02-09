//
//  ContentView.swift
//  Moonshot
//
//  Created by Malak Yehia on 23/01/2025.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    @State var grid: Bool = true
    
    var body: some View {
        NavigationStack {
            Group {
                if grid {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(missions) { mission in
                                NavigationLink {
                                    MissionView(mission: mission, astronauts: astronauts)
                                } label: {
                                    VStack {
                                        Image(mission.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .padding()
                                        VStack {
                                            Text(mission.displayName)
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                            Text(mission.formattedLaunchDate)
                                                .font(.caption)
                                                .foregroundStyle(.gray)
                                        }
                                        .padding(.vertical)
                                        .frame(maxWidth: .infinity)
                                        .background(.lightBackground)
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.lightBackground)
                                    )
                                }
                            }
                        }
                        .padding([.horizontal, .bottom])
                    }
                } else {
                    List(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astronauts: astronauts)
                        } label: {
                            HStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding()
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                            }
                            .background(.lightBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .listRowBackground(Color.darkBackground)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(.darkBackground)
                    
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button(action: {grid.toggle()}) {
                    Image(systemName: grid ? "list.bullet" : "square.grid.2x2")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
