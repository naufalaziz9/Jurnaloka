//
//  AktivitasPage.swift
//  Wallsmart
//
//  Created by naufalazizz on 03/02/22.
//

import SwiftUI

struct AktivitasPage: View {
    
    let coreDM: CDManager
    @State private var pengeluaranns: [Pengeluaran] = [Pengeluaran]()
    @State private var pemasukanns: [Pemasukan] = [Pemasukan]()
    
    @State private var needsRefresh: Bool = false
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Pengeluaran.entity(), sortDescriptors: []) var pengeluaran: FetchedResults<Pengeluaran>
    @FetchRequest(entity: Pemasukan.entity(), sortDescriptors: []) var pemasukan: FetchedResults<Pemasukan>
    
    @State var hariTglText = Date()
    
    @State private var searchIsi = ""
    @State var selectedSegmented = 0
    
    @ObservedObject var myText = MyText()
    
    @State private var showingSheet = false
    @State private var showingSheet2 = false
    
    let formatter = DateFormatter()
    
    var body: some View {
//        VStack{
        VStack(alignment: .leading){
            HStack(alignment: .center){
                Text("Jurnal")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Spacer()
                
                Button(action: {
                    showingSheet.toggle()
                    print("Button tapped!")
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                            .foregroundColor(Color("myGreen1"))
                    }
                }
                
                Button(action: {
                    showingSheet2.toggle()
                    print("Button tapped!")
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                            .foregroundColor(Color("myRed"))
                    }
                }
            }
        
            Picker("Favorite Color", selection: $selectedSegmented, content: {
                Text("Pemasukan")
                    .tag(0)
                
                Text("Pengeluaran")
                    .tag(1)
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            // isi
            if selectedSegmented == 0 {
                VStack{
                    List{
                        ForEach(pemasukanns, id: \.self) {pema in
//                                Button(action: {
//                                    showingSheet.toggle()
//                                    print("Button tapped!")
//                                }) {
//                                    HStack(alignment: .top, spacing: 8){
//                                        Circle()
//                                            .fill(Color("myGreen1"))
//                                            .frame(width: 30, height: 30)
//
//                                        VStack(alignment: .leading){
//                                            Text("\(pema.deskripsi ?? "Data nil")")
//                                            Text("\(pema.tanggal ?? hariTglText, style: .date)")
//                                                .foregroundColor(Color("myGray50"))
//                                            Text("\(pema.id_kategori ?? "Data nil")")
//                                                .foregroundColor(Color("myGray50"))
//                                        }
//
//                                        Spacer()
//
//                                        VStack(alignment: .trailing, spacing: 8){
//                                            Text("\(pema.jumlah)")
//                                            Circle()
//                                                .fill(Color("myGreen1"))
//                                                .frame(width: 20, height: 20)
//                                        }
//                                    }
//                                }
//                                .frame(maxWidth: .infinity)
//                                .padding(12)
//                                .background(Color("myGray"))
//                                .cornerRadius(8)
                            
                            NavigationLink (destination: UbahPemasukan(dataPem: pema)) {
                                HStack(alignment: .top, spacing: 8){
                                    Image(systemName: "arrow.down.circle.fill")
                                        .foregroundColor(Color("myGreen1"))
                                        .font(.title2)

                                    VStack(alignment: .leading){
                                        Text("\(pema.deskripsi ?? "Data nil")")
                                        Text("\(pema.tanggal ?? hariTglText, style: .date)")
                                            .foregroundColor(Color("myGray50"))
                                        Text("\(pema.id_kategori ?? "Data nil")")
                                            .foregroundColor(Color("myGray50"))
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 8){
                                        Text("\(pema.jumlah)")
                                        Circle()
                                            .fill(Color("myGreen1"))
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color("myGray"))
                            .cornerRadius(8)
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach { index in
                                let pemasukan = pemasukanns[index]
                                coreDM.hapusPemasukan(pemasukan: pemasukan)
                                pemasukanns = coreDM.getAllPemasukan()
                            }
                        })
                    }
                    .listStyle(.plain)
                }
                .padding(.top, 10)
            } else {
                VStack{
                    List{
                        ForEach(pengeluaranns, id: \.self) {peng in
                            NavigationLink (destination: UbahPengeluaran(dataPeng: peng)) {
                                HStack(alignment: .top, spacing: 8){
                                    Image(systemName: "arrow.up.circle.fill")
                                        .foregroundColor(Color("myRed"))
                                        .font(.title2)

                                    VStack(alignment: .leading){
                                        Text("\(peng.deskripsi ?? "Data nil")")
                                        Text("\(peng.tanggal ?? hariTglText, style: .date)")
                                            .foregroundColor(Color("myGray50"))
                                        Text("\(peng.id_kategori ?? "Data nil")")
                                            .foregroundColor(Color("myGray50"))
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 8){
                                        Text("\(peng.jumlah)")
                                        Circle()
                                            .fill(Color("myRed"))
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color("myGray"))
                            .cornerRadius(8)
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach { index in
                                let pengeluaran = pengeluaranns[index]
                                coreDM.hapusPengeluaran(pengeluaran: pengeluaran)
                                pengeluaranns = coreDM.getAllPengeluaran()
                            }
                        })
                    }
                    .listStyle(.plain)
                }
                .padding(.top, 10)
            }
            // close isi
        }
        .frame(maxHeight: .infinity)
        .padding(.bottom, 10)
        .padding(.horizontal, 20)
        .onAppear(perform: {
            pemasukanns = coreDM.getAllPemasukan()
            pengeluaranns = coreDM.getAllPengeluaran()
        })
        .sheet(isPresented: $showingSheet) {
            TambahPemasukan()
        }
        .sheet(isPresented: $showingSheet2) {
            TambahPengeluaran()
        }
//        }
        
//        VStack{
//            Picker("Favorite Color", selection: $selectedSegmented, content: {
//                Text("Pemasukan")
//                    .tag(0)
//
//                Text("Pengeluaran")
//                    .tag(1)
//            })
//            .pickerStyle(SegmentedPickerStyle())
//            .padding(.horizontal, 20)
//            
//            Text("Data")
//            
//            HStack{
//                Image(systemName: "magnifyingglass")
//
//                TextField("Cari data kamu", text: $searchIsi, onEditingChanged: { isEditing in
//                }, onCommit: {
//                    print("onCommit")
//                })
//                    .foregroundColor(Color("myGray30"))
//
//                Button(action: {
//                    self.searchIsi = ""
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .opacity(searchIsi == "" ? 0 : 1)
//                }
//            }
//            .padding(.vertical, 6) // padding ke dlm
//            .padding(.horizontal, 10) // padding ke dlm
//            .foregroundColor(Color("myGray30"))
//            .background(Color("myGray"))
//            .cornerRadius(8)
//            
//            ScrollView {
//                if selectedSegmented == 0{
//                    VStack{
//                        List {
//                            ForEach(pemasukanns, id: \.self) {pema in
//                                NavigationLink (destination: UbahPemasukan(dataPem: pema)) {
//                                    HStack(alignment: .top, spacing: 8){
//                                        Circle()
//                                            .fill(Color("myGreen1"))
//                                            .frame(width: 30, height: 30)
//                                        
//                                        VStack(alignment: .leading){
//                                            Text("\(pema.deskripsi ?? "Data nil")")
//                                            Text("\(pema.tanggal ?? hariTglText, style: .date)")
//                                                .foregroundColor(Color("myGray50"))
//                                            Text("\(pema.id_kategori ?? "Data nil")")
//                                                .foregroundColor(Color("myGray50"))
//                                        }
//                                        
//                                        Spacer()
//                                        
//                                        VStack(alignment: .trailing, spacing: 8){
//                                            Text("\(pema.jumlah)")
//                                            Circle()
//                                                .fill(Color("myGreen1"))
//                                                .frame(width: 20, height: 20)
//                                        }
//                                    }
//                                }
//                                .padding(12)
//                                .background(Color("myGray"))
//                                .cornerRadius(8)
//                            }
//                            .onDelete(perform: { indexSet in
//                                indexSet.forEach { index in
//                                    let pemasukan = pemasukanns[index]
//                                    pemasukanns = coreDM.getAllPemasukan()
//                                }
//                            })
//                        }
//                        .listStyle(.plain)
//                    }
//                    .frame(height: 600)
//                    .padding(.bottom, 60)
//                } else {
//                    VStack(alignment: .leading){
//                        List {
//                            ForEach(pengeluaranns, id: \.self) {peng in
//                                NavigationLink (destination: UbahPengeluaran(dataPeng: peng)) {
//                                    HStack(alignment: .top, spacing: 8){
//                                        Circle()
//                                            .fill(Color("myGreen1"))
//                                            .frame(width: 30, height: 30)
//                                        
//                                        VStack(alignment: .leading){
//                                            Text("\(peng.deskripsi ?? "Data nil")")
//                                            Text("\(peng.tanggal ?? hariTglText, style: .date)")
//                                                .foregroundColor(Color("myGray50"))
//                                            Text("\(peng.id_kategori ?? "Data nil")")
//                                                .foregroundColor(Color("myGray50"))
//                                        }
//                                        
//                                        Spacer()
//                                        
//                                        VStack(alignment: .trailing, spacing: 8){
//                                            Text("\(peng.jumlah)")
//                                            Circle()
//                                                .fill(Color("myGreen1"))
//                                                .frame(width: 20, height: 20)
//                                        }
//                                    }
//                                }
//                                .padding(12)
//                                .background(Color("myGray"))
//                                .cornerRadius(8)
//                            }
//                            .onDelete(perform: { indexSet in
//                                indexSet.forEach { index in
//                                    let pengeluaran = pengeluaranns[index]
//                                    pengeluaranns = coreDM.getAllPengeluaran()
//                                }
//                            })
//                        }
//                        .listStyle(.plain)
//                    }
//                    .frame(height: 600)
//                    .padding(.bottom, 60)
//                }
//            }
//            .padding(.top, 20)
//            .padding(.horizontal, 20)
//            .padding(.bottom, 20)
//            .onAppear(perform: {
//                pemasukanns = coreDM.getAllPemasukan()
//                pengeluaranns = coreDM.getAllPengeluaran()
//            })
//        }
    }
    
    func getPricer(value: Float) -> String{
        let format = NumberFormatter()
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
    func totalPengeluaran() -> String {
        var result: Float = 0
        
        pengeluaran.forEach{ (n) in
            result += Float(n.jumlah)
        }
        
        return getPricer(value: result)
    }
    
}

struct AktivitasPage_Previews: PreviewProvider {
    static var previews: some View {
        AktivitasPage(coreDM: CDManager())
    }
}

class MyText: ObservableObject {
    
    
    @FetchRequest(entity: Pengeluaran.entity(), sortDescriptors: []) var pengeluaran: FetchedResults<Pengeluaran>
    
    func getPricer(value: Float) -> String{
        let format = NumberFormatter()
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
    func totalPengeluaran() -> String {
        var result: Float = 0
        
        pengeluaran.forEach{ (n) in
            result += Float(n.jumlah)
        }
        
        return getPricer(value: result)
    }
}
