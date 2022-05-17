//
//  UbahPengeluaran.swift
//  Wallsmart
//
//  Created by naufalazizz on 06/02/22.
//

import SwiftUI

struct UbahPengeluaran: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    @ObservedObject var dataPeng: Pengeluaran
    
    @State var jumPengText: Int = 2320
    @State var deskText = ""
    @State var hariTglText = Date()
    
    let tujKateList = ["Primer", "Investasi", "Hiburan", "Dana Darurat"]
    
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                    VStack(spacing: 16){
                        TextField("\($dataPeng.jumlah)", value: $jumPengText, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .padding(14)
                            .background(Color("myGray"))
                            .foregroundColor(Color("myGray50"))
                            .cornerRadius(8)
                            .onAppear {
                                jumPengText = Int(dataPeng.jumlah)
                            }
                        
                        Menu {
                            ForEach(tujKateList, id: \.self){ client in
                                Button(client) {
                                    self.dataPeng.id_kategori = client
                                }
                            }
                        } label: {
                            VStack(spacing: 5){
                                HStack{
                                    Text(dataPeng.id_kategori ?? "Kosong")
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color("myGray50"))
                                        .font(Font.system(size: 20, weight: .bold))
                                }
                            }
                            .padding(14)
                            .background(Color("myGray"))
                            .foregroundColor(Color("myGray50"))
                            .cornerRadius(8)
                        }
                        
                        TextField(dataPeng.deskripsi ?? "", text: $deskText)
                            .padding(14)
                            .background(Color("myGray"))
                            .foregroundColor(Color("myGray50"))
                            .cornerRadius(8)
                        
                        DatePicker(
                            "Tanggal",
                            selection: $dataPeng.tanggal.toUnwrapped(defaultValue: Date()),
                            displayedComponents: [.date]
                        )
                            .padding(8)
                            .background(Color("myGray"))
                            .foregroundColor(Color("myGray50"))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
                .padding(.top, 20)
                .onTapGesture {
                    hideKeyboard()
                }
                .navigationBarItems(leading:
                                        Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Batal")
                        .foregroundColor(.white)
                }), trailing:
                                        Button(action: {
                    self.ubahPengeluaran(a: self.dataPeng)
                    self.presentationMode.wrappedValue.dismiss()
                    print("Button tapped!")
                }, label: {
                    Text("Selesai")
                        .foregroundColor(.white)
                })
                )
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text("Ubah Pengeluaran"))
            }
        }
        .navigationBarColor(backgroundColor: UIColor(named: "myGreen1"), titleColor: .white)
    }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func ubahPengeluaran(a: Pengeluaran?) {
        a?.jumlah = Int64(jumPengText) ?? 0
        a?.deskripsi = deskText
        try? self.context.save()
    }
}

struct UbahPengeluaran_Previews: PreviewProvider {
    static var previews: some View {
        UbahPengeluaran(dataPeng: Pengeluaran())
    }
}
