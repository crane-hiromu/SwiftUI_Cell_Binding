//
//  ContentView.swift
//  SwiftUI_Cell_Binding
//
//  Created by admin on 2019/10/01.
//  Copyright © 2019 h.crane. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    private var viewModel = WatchingListViewModel()
    @State var watchings: [WatchingModel] = []
    
    var body: some View {
        List{
            ForEach(watchings.enumerated().map { $0.offset }, id: \.self) { i in
               Cell(watching: self.$watchings[i])
            }
        }.onReceive(viewModel.$watchings, perform: { watchings in
            self.watchings = watchings
        }).onAppear {
            self.viewModel.fetch()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WatchingModel: Identifiable {
    let id: Int
    let name: String
    var isReceiveNotification: Bool
}

class WatchingListViewModel {
    @Published var watchings: [WatchingModel] = []

    func fetch() {
        //２秒後に値が取得できたとしてスタブを差し込む
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.watchings = [
                WatchingModel(id: 0, name: "name", isReceiveNotification: false)
            ]
        }
        
        //４秒後に値を変更する
        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            self.watchings[0].isReceiveNotification = true
        }
    }
}

struct Cell: View {
    @Binding var watching: WatchingModel
    
    var body: some View {
        HStack {
            Toggle(isOn: $watching.isReceiveNotification) { () in
                Text(watching.name).font(.headline).lineLimit(1)
            }
        }
    }
}
