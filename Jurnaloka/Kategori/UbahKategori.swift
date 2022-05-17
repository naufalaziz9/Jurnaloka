//
//  UbahKategori.swift
//  Wallsmart
//
//  Created by naufalazizz on 06/02/22.
//

import SwiftUI

struct UbahKategori: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var dataKate: Kategori
    @State private var kategoriis: [Kategori] = [Kategori]()
    @FetchRequest(entity: Kategori.entity(), sortDescriptors: [], predicate: NSPredicate(format: "nama_kategori == 'Primer'")) var katePrimer: FetchedResults<Kategori>
    @FetchRequest(entity: Kategori.entity(), sortDescriptors: [], predicate: NSPredicate(format: "nama_kategori == 'Investasi'")) var kateInvest: FetchedResults<Kategori>
    @FetchRequest(entity: Kategori.entity(), sortDescriptors: [], predicate: NSPredicate(format: "nama_kategori == 'Hiburan'")) var kateHiburan: FetchedResults<Kategori>
    @FetchRequest(entity: Kategori.entity(), sortDescriptors: [], predicate: NSPredicate(format: "nama_kategori == 'Dana Darurat'")) var kateDarurat: FetchedResults<Kategori>
    
    @State var namaKateText = ""
    @State var persenText: Int = 90
    @State var batasMinText: Int = 30
    @State var primerText: Int = 40
    @State var invesText: Int = 30
    @State var hiburanText: Int = 20
    @State var daruratText: Int = 10
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack(alignment: .center){
                    Text("Ubah Kategori")
                        .font(.title2).bold()
                    Spacer()
                    Button("Selesai") {
                        self.ubahKategori(c: self.dataKate)
                        self.presentationMode.wrappedValue.dismiss()
                        print("Button tapped!")
                    }
//                    .disabled((totalPersen() > 100 ? true : false))
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.top, 100)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity)
            .background(Color("myGreen1"))
            .padding(.top, -450)
            
            ScrollView{
                VStack{
                    TextField(dataKate.nama_kategori ?? "", text: $namaKateText)
                        .padding(14)
                        .background(Color("myGreen1"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.bottom, 10)
                        .disabled(true)
                    
                    TextField("\($dataKate.persentase)", value: $persenText, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .padding(14)
                        .background(Color("myGray"))
                        .foregroundColor(Color("myGray50"))
                        .cornerRadius(8)
                        .onAppear {
                            persenText = Int(dataKate.persentase)
                        }
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("% Kategori Anda saat ini (maks 100%)")
                            .font(.callout)
                        HStack(alignment: .center){
                            Text("\(persenPrimer())")
                            Spacer()
                            Text("\(persenInvest())")
                            Spacer()
                            Text("\(persenHiburan())")
                            Spacer()
                            Text("\(persenDarurat())")
                        }
                    }
                    .foregroundColor(.white)
                    .padding(14)
                    .frame(maxWidth: .infinity)
                    .background(Color("myGreen1"))
                    .cornerRadius(8)
                    .padding(.bottom, 16)
                    
                    TextField("\($dataKate.batas_min)", value: $batasMinText, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .padding(14)
                        .background(Color("myGray"))
                        .foregroundColor(Color("myGray50"))
                        .cornerRadius(8)
                        .onAppear {
                            batasMinText = Int(dataKate.batas_min)
                        }
                    
                    Text("Total persentase kategori maksimal 100%")
                        .foregroundColor(totalPersen() > 100 ? .red : .white)
                    
//                    NavigationLink(destination: UbahPersentaseKategori(coreDM: CDManager())) {
//                        VStack (alignment: .leading, spacing: 4){
//                            HStack{
//                                Text("\(dataKate.persentase)")
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                            }
//                            Divider()
//                                .hidden()
//                        }
//                    }
//                    .padding(.top, 8) // padding ke dlm card
//                    .padding(.bottom, 4) // padding ke dlm card
//                    .padding(.horizontal, 14) // padding ke dlm card
//                    .foregroundColor(.black)
//                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth:1))
//                    .padding(.bottom, 16)
                    
                    NavigationLink(destination: KategoriPage(coreDM: CDManager())) {
                        VStack (alignment: .center, spacing: 4){
                            Text("kategoripage")
                            Divider()
                                .hidden()
                        }
                    }
                    .padding(.top, 12) // padding ke dlm card
                    .padding(.bottom, 8) // padding ke dlm card
                    .padding(.horizontal, 14) // padding ke dlm card
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
            .padding(.top, 80)
            .onTapGesture {
                hideKeyboard()
            }
        }
        
    }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func ubahKategori(c: Kategori?) {
        c?.batas_min = Int64(batasMinText) ?? 0
        c?.persentase = Int64(persenText) ?? 0
        try? self.context.save()
    }
    
    func getPricer(value: Float) -> String{
        let format = NumberFormatter()
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
    func persenPrimer() -> Int {
        var hasil = 0
        
        katePrimer.forEach{ (n) in
            hasil += Int(n.persentase)
        }
        
        return hasil
    }
    
    func persenInvest() -> Int {
        var hasil = 0
        
        kateInvest.forEach{ (n) in
            hasil += Int(n.persentase)
        }
        
        return hasil
    }
    
    func persenHiburan() -> Int {
        var hasil = 0
        
        kateHiburan.forEach{ (n) in
            hasil += Int(n.persentase)
        }
        
        return hasil
    }
    
    func persenDarurat() -> Int {
        var hasil = 0
        
        kateDarurat.forEach{ (n) in
            hasil += Int(n.persentase)
        }
        
        return hasil
    }
    
    func totalPersen() -> Int {
        var hasil = persenPrimer() + persenInvest() + persenHiburan() + persenDarurat()
        
        return hasil
    }
}

struct UbahKategori_Previews: PreviewProvider {
    static var previews: some View {
        UbahKategori(dataKate: Kategori())
    }
}
