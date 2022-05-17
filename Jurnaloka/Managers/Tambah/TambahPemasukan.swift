//
//  TambahPemasukan.swift
//  Wallsmart
//
//  Created by naufalazizz on 20/03/22.
//

import SwiftUI

struct TambahPemasukan: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    @State var jumPemText: Int = 0
    @State var deskText = ""
    @State var hariTglText = Date()
    
    @State var tujKateSelection = ""
    let tujKateList = ["Primer", "Investasi", "Hiburan", "Dana Darurat"]
    
    var body: some View {
        NavigationView {
            ZStack{
                ScrollView{
                    VStack(spacing: 16){
                        TextField("Jumlah pemasukan", value: $jumPemText, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .padding(14)
                            .background(Color("myGray"))
                            .foregroundColor(Color("myGray50"))
                            .cornerRadius(8)
                            .onAppear {
                                jumPemText = jumPemText
                            }
                        
                        Menu {
                            ForEach(tujKateList, id: \.self){ client in
                                Button(client) {
                                    self.tujKateSelection = client
                                }
                            }
                        } label: {
                            VStack(spacing: 5){
                                HStack{
                                    Text(tujKateSelection.isEmpty ? "Sumber kategori" : tujKateSelection)
                                        .foregroundColor(tujKateSelection.isEmpty ? Color("myGray50") : Color("myGray50"))
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color("myGray50"))
                                        .font(Font.system(size: 16, weight: .medium))
                                }
                            }
                            .padding(14)
                            .background(Color("myGray"))
                            .foregroundColor(Color("myGray50"))
                            .cornerRadius(8)
                        }
                        
                        TextField("Deskripsi (maks 20 karakter)", text: self.$deskText)
                            .padding(14)
                            .background(Color("myGray"))
                            .foregroundColor(Color("myGray50"))
                            .cornerRadius(8)
                        
                        DatePicker(
                            "Tanggal",
                            selection: $hariTglText,
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
                    self.inputPemasukan()
                    self.presentationMode.wrappedValue.dismiss()
                    print("Button tapped!")
                }, label: {
                    Text("Selesai")
                        .foregroundColor(.white)
                })
                )
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text("Tambah Pemasukan"))
            }
        }
        .navigationBarColor2(backgroundColor: UIColor(named: "myGreen1"), titleColor: .white)
    }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func inputPemasukan() {
        let newPemasukan = Pemasukan(context: self.context)
        newPemasukan.jumlah = Int64(jumPemText)
        newPemasukan.id_kategori = tujKateSelection
        newPemasukan.tanggal = hariTglText
        newPemasukan.deskripsi = deskText
        do {
            try self.context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

struct TambahPemasukan_Previews: PreviewProvider {
    static var previews: some View {
        TambahPemasukan()
    }
}

struct NavigationBarModifier2: ViewModifier {
    
    var backgroundColor: UIColor?
    var titleColor: UIColor?
    
    init(backgroundColor: UIColor?, titleColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func navigationBarColor2(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier2(backgroundColor: backgroundColor, titleColor: titleColor))
    }
}
