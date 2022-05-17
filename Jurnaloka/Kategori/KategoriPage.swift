//
//  KategoriPage.swift
//  Wallsmart
//
//  Created by naufalazizz on 06/02/22.
//

import UserNotifications
import SwiftUI

struct KategoriPage: View {
    
    let coreDM: CDManager
    @State private var kategoriis: [Kategori] = [Kategori]()
    
    @State var hariTglText = Date()
    @State private var showingSheet = false
    @State private var showingSheet2 = false
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    private var dateFormatter2: DateFormatter {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd"
        return dateFormatter2
    }
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Kategori.entity(), sortDescriptors: []) var kategori: FetchedResults<Kategori>
    @FetchRequest(entity: Pemasukan.entity(), sortDescriptors: []) var pemasukan: FetchedResults<Pemasukan>
    @FetchRequest(entity: Pengeluaran.entity(), sortDescriptors: []) var pengeluaran: FetchedResults<Pengeluaran>
    
    @FetchRequest(entity: Pemasukan.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id_kategori == 'Primer'")) var pemPrimer: FetchedResults<Pemasukan>
    @FetchRequest(entity: Pemasukan.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id_kategori == 'Investasi'")) var pemInvest: FetchedResults<Pemasukan>
    @FetchRequest(entity: Pemasukan.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id_kategori == 'Hiburan'")) var pemHiburan: FetchedResults<Pemasukan>
    @FetchRequest(entity: Pemasukan.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id_kategori == 'Dana Darurat'")) var pemDarurat: FetchedResults<Pemasukan>
    
    @FetchRequest(entity: Pengeluaran.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id_kategori == 'Primer'")) var pengPrimer: FetchedResults<Pengeluaran>
    @FetchRequest(entity: Pengeluaran.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id_kategori == 'Investasi'")) var pengInvest: FetchedResults<Pengeluaran>
    @FetchRequest(entity: Pengeluaran.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id_kategori == 'Hiburan'")) var pengHiburan: FetchedResults<Pengeluaran>
    @FetchRequest(entity: Pengeluaran.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id_kategori == 'Dana Darurat'")) var pengDarurat: FetchedResults<Pengeluaran>
    
    var body: some View {
        GeometryReader{ geo in
            ScrollView{
                VStack{
                    VStack(alignment: .center){
                        HStack{
                            Spacer()
                            Button(action: {
                                showingSheet.toggle()
                                print("Button tapped!")
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                        .foregroundColor(Color.white)
                                }
                            }
                            
                            Button(action: {
                                showingSheet2.toggle()
                                print("Button tapped!")
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                        .foregroundColor(Color.white)
                                }
                            }
                            
//                            Menu {
//                                Button(action: {
//                                    showingSheet.toggle()
//                                    print("Button tapped!")
//                                }) {
//                                    HStack(spacing: 10) {
//                                        Text("Tambah Pemasukan")
//                                            .foregroundColor(Color.blue)
//                                    }
//                                }
//
//                                Button(action: {
//                                    showingSheet.toggle()
//                                    print("Button tapped!")
//                                }) {
//                                    HStack(spacing: 10) {
//                                        Text("Tambah Pengeluaran")
//                                            .foregroundColor(Color.blue)
//                                    }
//                                }
//                            } label: {
//                                Image(systemName: "plus")
//                            }
                        }
                        
                        VStack(alignment: .center, spacing: 8){
                            Text("Uang Anda saat ini")
                            Text("Rp\(totalKategori()),-")
                                .font(.title)
                                .fontWeight(.heavy)
                            Text("Warna merah berarti mendekati batas minimal")
                        }
                        .padding(.top)
                    }
                    .padding(.top,100)
                    .padding(.horizontal, 20)
                    .ignoresSafeArea() // gatau ga ngefek apa"
                    .foregroundColor(.white)
                    .frame(height: geo.size.height * 0.4)
                    .background(Color("myGreen1"))
                    
//                    Button("Allow Notification") {
//                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                            if success {
//                                print("All set")
//                            } else if let error = error {
//                                print(error.localizedDescription)
//                            }
//                        }
//
//                        let content = UNMutableNotificationContent()
//                        content.title = "Feed dod"
//                        content.subtitle = "hungryyy"
//                        content.sound = UNNotificationSound.default
//                        var dateComponents = DateComponents()
//                        dateComponents.hour = 10
//                        dateComponents.minute = 01
//                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)
//                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//                        UNUserNotificationCenter.current().add(request)
//                    }
                    
                    Button("Allow Notification") {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {success, error in
                            if success {
                                print("All set!")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }

                        let content = UNMutableNotificationContent()
                        content.title = "Wallsmart Reminder"
                        content.body = "Jangan lupa catat pemasukan dan pengeluaranmu hari ini!"
                        content.sound = UNNotificationSound.default

                        if let thisHour = Calendar.current.dateComponents([.day], from: Date()).day,
                            let selectedHour = Calendar.current.dateComponents([.day], from: self.hariTglText).day {
                            if (thisHour >= selectedHour) {
                                var dateComponents = DateComponents()
//                                dateComponents.day = selectedHour
                                dateComponents.hour = 20
                                dateComponents.minute = 01

//                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2592000, repeats: true)
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)
                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(request)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 20){
                        Text("Kategori")
                            .font(.title2).bold()
                        
                        LazyVGrid(columns: gridItemLayout, spacing: 20) {
                            ForEach(kategoriis, id: \.self) {kate in
//                                Text("(!) adalah uang mendekati batas minimal")
//                                    .foregroundColor(totalPrimer2() > kate.batas_min ? .red : .yellow)
//                                if totalPrimer() > kate.batas_min {
//                                    Text("(!) adalah uang mendekati batas minimal")
//                                }
                                NavigationLink (destination: UbahKategori(dataKate: kate)) {
                                    VStack(spacing: 0){
                                        if Int(totalKategori()) ?? 0 < 100 {
                                            HStack(alignment: .center){
                                                Image(systemName: "exclamationmark.circle.fill")
                                                    .hidden()
                                                Spacer()
                                                Text("\(kate.nama_kategori ?? "Data nil")")
                                                Spacer()
                                                Image(systemName: "exclamationmark.circle.fill")
                                            }
                                            .foregroundColor(.white)
                                            .padding(.vertical, 6)
                                            .padding(.horizontal, 6)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.red)
                                        } else {
                                            Text("\(kate.nama_kategori ?? "Data nil")")
                                                .foregroundColor(.white)
                                                .padding(.vertical, 6)
                                                .frame(maxWidth: .infinity)
                                                .background(Color("myGreen1"))
                                        }

                                        VStack(alignment: .leading, spacing: 8){
                                            if kate.nama_kategori == "Primer" {
                                                Text("Rp\(totalPrimer())")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(totalPrimer() <= (25/100) + kate.batas_min ? Color("myRed") : Color("myGreen1"))
                                            } else if kate.nama_kategori == "Investasi" {
                                                Text("Rp\(totalInvest())")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(totalInvest() <= (25/100) + kate.batas_min ? Color("myRed") : Color("myGreen1"))
                                            } else if kate.nama_kategori == "Hiburan" {
                                                Text("Rp\(totalHiburan())")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(totalHiburan() <= (25/100) + kate.batas_min ? Color("myRed") : Color("myGreen1"))
                                            } else if kate.nama_kategori == "Dana Darurat" {
                                                Text("Rp\(totalDarurat())")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(totalDarurat() <= (25/100) + kate.batas_min ? Color("myRed") : Color("myGreen1"))
                                            } else {
                                                Text("Tidak ada")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                            }
                                            Text("persen \(kate.persentase)")
                                            Text("minimal \(kate.batas_min)")
                                            
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .frame(maxWidth: .infinity)
                                        .background(Color("myGray"))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .cornerRadius(6)
                            }
                        }
                        
                        Text("Artikel")
                            .font(.title2).bold()
                        
                        VStack(spacing: 16){
                            Link(destination: URL(string: "https://easyaccountingsystem.co.id/mengatur-gaji-bulanan/")!) {
                                HStack(alignment: .top, spacing: 10){
                                    Rectangle()
                                        .fill(Color("myGreen2"))
                                        .frame(width: 72, height: 72)
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading){
                                        Text("2 Formula Mengatur Gaji Bulanan Agar Tidak Langsung Habis & Masih Bisa Ditabung")
                                            .foregroundColor(.black)
                                        Text("Easy Accounting System")
                                            .foregroundColor((Color("myGray50")))
                                    }
                                    .foregroundColor(.black)
                                             
                                    Spacer()
                                }
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color("myGray"))
                            .cornerRadius(8)
                            
                            Link(destination: URL(string: "https://www.joinan.co.id/blog/cara-melakukan-perencanaan-keuangan-pribadi-agar-tidak-boncos/")!) {
                                HStack(alignment: .top, spacing: 10){
                                    Rectangle()
                                        .fill(Color("myGreen2"))
                                        .frame(width: 72, height: 72)
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading){
                                        Text("Cara Mengatur Keuangan Pribadi Agar Tidak Boncos")
                                            .foregroundColor(.black)
                                        Text("Joinan")
                                            .foregroundColor((Color("myGray50")))
                                    }
                                             
                                    Spacer()
                                }
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color("myGray"))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .onAppear(perform: {
                        kategoriis = coreDM.getAllKategori()
                    })
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.white)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.white)
            .sheet(isPresented: $showingSheet) {
                TambahPemasukan()
            }
            .sheet(isPresented: $showingSheet2) {
                TambahPengeluaran()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(backgroundColor: UIColor(named: "myGreen1"), titleColor: .white) // warna navigation bar bawaan ipon
        
        
//        ZStack{
//
//
//            ScrollView {
//                    VStack(alignment: .leading, spacing: 8){
//
//                    }
//                    .onAppear(perform: {
//                        kategoriis = coreDM.getAllKategori()
//                    })
//                    .padding(.horizontal, 20)
//            }
//            .padding(.top, 160)
//            .background(Color.white)
//        }
//        .background(Color("myGreen1"))
//        .sheet(isPresented: $showingSheet) {
//            TambahPengeluaran()
//        }
        
    }
    
    func getPricer(value: Float) -> String{
        let format = NumberFormatter()
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
    func totalKategori() -> String {
        var pemResult: Float = 0
        var pengResult: Float = 0
        
        pemasukan.forEach{ (n) in
            pemResult += Float(n.jumlah)
        }
        
        pengeluaran.forEach{ (n) in
            pengResult += Float(n.jumlah)
        }
        
        return getPricer(value: pemResult - pengResult)
    }
    
    func totalPrimer() -> Int {
        var pemResult = 0
        var pengResult = 0
        
        pemPrimer.forEach{ (n) in
            pemResult += Int(n.jumlah)
        }
        
        pengPrimer.forEach{ (n) in
            pengResult += Int(n.jumlah)
        }
        
        return pemResult - pengResult
    }
    
    func totalInvest() -> Int {
        var pemResult = 0
        var pengResult = 0
        
        pemInvest.forEach{ (n) in
            pemResult += Int(n.jumlah)
        }
        
        pengInvest.forEach{ (n) in
            pengResult += Int(n.jumlah)
        }
        
        return pemResult - pengResult
    }
    
    func totalHiburan() -> Int {
        var pemResult = 0
        var pengResult = 0
        
        pemHiburan.forEach{ (n) in
            pemResult += Int(n.jumlah)
        }
        
        pengHiburan.forEach{ (n) in
            pengResult += Int(n.jumlah)
        }
        
        return pemResult - pengResult
    }
    
    func totalDarurat() -> Int {
        var pemResult = 0
        var pengResult = 0
        
        pemDarurat.forEach{ (n) in
            pemResult += Int(n.jumlah)
        }
        
        pengDarurat.forEach{ (n) in
            pengResult += Int(n.jumlah)
        }
        
        return pemResult - pengResult
    }
    
    func addNotification(for prospect: KategoriPage) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "title"
            content.subtitle = "subtitle"
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        // more code to come
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
    
}

struct KategoriPage_Previews: PreviewProvider {
    static var previews: some View {
        KategoriPage(coreDM: CDManager())
    }
}
