//
//  TambahKategori.swift
//  Wallsmart
//
//  Created by naufalazizz on 18/04/22.
//

import SwiftUI

struct TambahKategori: View {
    @Environment(\.managedObjectContext) var context
    @State var newAnimalsName = ""
    
    @State var jumKateText: Int = 0
    @State var namaKateText = ""
    @State var persenText: Int = 0
    @State var batasMinText: Int = 0
    
    @State var tujKateSelection = ""
    let tujKateList = ["Primer", "Investasi", "Hiburan", "Dana Darurat"]
    
    var body: some View {
        ScrollView{
            VStack{
                VStack(alignment: .leading) {
                    Text("Tambah Kate")
                            .font(.headline)
                    
                    Divider()
                        .hidden()
                }
                
                TextField(
                    "nama", text: self.$namaKateText
                )
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                
                TextField(
                    "persen", value: $persenText, formatter: NumberFormatter()
                )
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                
                TextField(
                    "batas min", value: $batasMinText, formatter: NumberFormatter()
                )
                    .keyboardType(.numberPad)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                
                Button("Selesai") {
                    self.inputKategori()
                    print("Button tapped!")
                }
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(16)
                
                NavigationLink(destination: KategoriPage(coreDM: CDManager())) {
                    VStack (alignment: .leading, spacing: 4){
                            Text("kategoripage")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        
                        Divider()
                            .hidden()
                    }
                }
                .padding(.vertical, 14) // padding ke dlm card
                .padding(.horizontal, 18) // padding ke dlm card
                .background(Color.black)
                .foregroundColor(.green)
                .cornerRadius(22)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func inputKategori() {
        let newKategori = Kategori(context: self.context)
        newKategori.nama_kategori = namaKateText
        newKategori.persentase = Int64(persenText)
        newKategori.batas_min = Int64(batasMinText)
        do {
            try self.context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

struct TambahKategori_Previews: PreviewProvider {
    static var previews: some View {
        TambahKategori()
    }
}
