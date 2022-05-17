//
//  TabBar.swift
//  Wallsmart
//
//  Created by naufalazizz on 08/01/22.
//

import SwiftUI

struct TabBar: View {
    init() {
        UINavigationBar.appearance().isOpaque = true
        UITabBar.appearance().backgroundColor = UIColor(Color("myGray"))
        UIScrollView.appearance().bounces = true
    }
    
    let persistenceContainer = CDManager.shared
    
    @State private var selectedView = 1
    @State var color = UIColor.white
    
    var body: some View {
        NavigationView{
            TabView(selection: $selectedView) {
                LaporanPage(coreDM: persistenceContainer)
                    .tabItem {
                        Label("Laporan", systemImage: "chart.pie.fill")
                    }
                    .tag(2)
                
                KategoriPage(coreDM: persistenceContainer)
                    .tabItem {
                        Label("Kategori", systemImage: "rectangle.grid.2x2.fill")
                    }
                    .tag(3)
                
                AktivitasPage(coreDM: persistenceContainer)
                    .tabItem {
                        Label("Aktivitas", systemImage: "arrow.up.arrow.down")
                    }
                    .tag(1)
            }
            .accentColor(Color("myGreen1"))
            .preferredColorScheme(.light)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
