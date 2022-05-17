//
//  TambahData.swift
//  Wallsmart
//
//  Created by naufalazizz on 20/03/22.
//

import SwiftUI

struct TambahData: View {
    
//    @State var kateInText = ""
    @State var jumPemText = ""
    
    var body: some View {
        ScrollView{
            VStack{
                Rectangle()
                    .fill(.black)
                    .frame(height: 2)
                    .padding(.horizontal, 166)
                    .padding(.bottom, 54)
                
                VStack(alignment: .leading) {
                    Text("Tambah Data")
                            .font(.headline)
                    
                    Divider()
                        .hidden()
                }
                
                NavigationLink(destination: TambahPemasukan()) {
                    VStack (alignment: .leading, spacing: 4){
                        HStack{
                            Text("Input Pemasukan")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        Divider()
                            .hidden()
                    }
                }
                .padding(.top, 8) // padding ke dlm card
                .padding(.bottom, 4) // padding ke dlm card
                .padding(.horizontal, 14) // padding ke dlm card
                .foregroundColor(.black)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth:1))
                
                NavigationLink(destination: TambahPengeluaran()) {
                    VStack (alignment: .leading, spacing: 4){
                        HStack{
                            Text("Input Pengeluaran")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        Divider()
                            .hidden()
                    }
                }
                .padding(.top, 8) // padding ke dlm card
                .padding(.bottom, 4) // padding ke dlm card
                .padding(.horizontal, 14) // padding ke dlm card
                .foregroundColor(.black)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth:1))
                
                NavigationLink(destination: TambahKategori()) {
                    VStack (alignment: .leading, spacing: 4){
                        HStack{
                            Text("Input Kate")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        Divider()
                            .hidden()
                    }
                }
                .padding(.top, 8) // padding ke dlm card
                .padding(.bottom, 4) // padding ke dlm card
                .padding(.horizontal, 14) // padding ke dlm card
                .foregroundColor(.black)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth:1))
            }
            .padding(.horizontal, 20)
        }
    }
}

struct TambahData_Previews: PreviewProvider {
    static var previews: some View {
        TambahData()
    }
}
