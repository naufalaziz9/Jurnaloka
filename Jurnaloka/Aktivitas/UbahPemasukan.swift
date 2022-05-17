//
//  UbahPemasukan.swift
//  Wallsmart
//
//  Created by naufalazizz on 06/02/22.
//

import SwiftUI

struct UbahPemasukan: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    @ObservedObject var dataPem: Pemasukan
    
    @State var jumPemText: Int = 2320
    @State var deskText = ""
    @State var hariTglText = Date()
    
    let tujKateList = ["Primer", "Investasi", "Hiburan", "Dana Darurat"]
    
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                    VStack(spacing: 16){
                        TextField("\(dataPem.jumlah)", value: $jumPemText, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .padding(14)
                            .background(Color("myGray"))
                            .foregroundColor(Color("myGray50"))
                            .cornerRadius(8)
                            .onAppear {
                                jumPemText = Int(dataPem.jumlah)
                            }
                        
                        Menu {
                            ForEach(tujKateList, id: \.self){ client in
                                Button(client) {
                                    self.dataPem.id_kategori = client
                                }
                            }
                        } label: {
                            VStack(spacing: 5){
                                HStack{
                                    Text(dataPem.id_kategori ?? "Kosong")
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
                        
                        TextField(dataPem.deskripsi ?? "", text: $deskText)
                            .padding(14)
                            .background(Color("myGray"))
                            .foregroundColor(Color("myGray50"))
                            .cornerRadius(8)
                        
                        DatePicker(
                            "Tanggal",
                            selection: $dataPem.tanggal.toUnwrapped(defaultValue: Date()),
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
                    self.ubahPemasukan(a: self.dataPem)
                    self.presentationMode.wrappedValue.dismiss()
                    print("Button tapped!")
                }, label: {
                    Text("Selesai")
                        .foregroundColor(.white)
                })
                )
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text("Ubah Pemasukan"))
            }
        }
        .navigationBarColor(backgroundColor: UIColor(named: "myGreen1"), titleColor: .white)
    }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func ubahPemasukan(a: Pemasukan?) {
        a?.jumlah = Int64(jumPemText) ?? 0
        a?.deskripsi = deskText
        try? self.context.save()
    }
}

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

struct UbahPemasukan_Previews: PreviewProvider {
    static var previews: some View {
        UbahPemasukan(dataPem: Pemasukan())
    }
}
