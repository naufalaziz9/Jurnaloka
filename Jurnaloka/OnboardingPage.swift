//
//  OnboardingPage.swift
//  Wallsmart
//
//  Created by naufalazizz on 27/04/22.
//

import SwiftUI

struct OnboardingPageStep {
    let title: String
    let desc: String
}

private let OnboardingPageSteps = [
    OnboardingPageStep(title: "Discover", desc: "Discover hidden gem restaurant and get informations about them"),
    
    OnboardingPageStep(title: "Order", desc: "Scan the QR code to see the restaurant’s menus and order"),
    
    OnboardingPageStep(title: "Enjoy!", desc: "Enjoy your meal!")
]

struct OnboardingPage: View {
    
    @State private var currentStep = 0
    @State private var x = 0
    @State private var tapCount = UserDefaults.standard.integer(forKey: "Open")
    
    @State var nicknameText = ""
    
    @State var hariTglText = Date()
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                if tapCount > 2 {
                    TabBar()
                } else {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.currentStep = OnboardingPageSteps.count - 1
                        }){
                            Text("Skip")
                                .padding(16)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    TextField("Deskripsi", text: self.$nicknameText)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 14)
                        .background(Color.gray)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                    
                    TabView(selection: $currentStep) {
                        ForEach(0..<OnboardingPageSteps.count) { it in
                            VStack {
//                                Image(OnboardingPageSteps[it].image)
//                                    .resizable()
//                                    .frame(width: 300, height: 300)
                                Text(OnboardingPageSteps[it].title)
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                                    .bold()
                                    .frame(width: 300, height: 40, alignment: .leading)
                                Text(OnboardingPageSteps[it].desc)
                                    .foregroundColor(.gray)
                                    .frame(width: 300, height: 70, alignment: .leading)
                            }
                            .tag(it)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    HStack {
                        ForEach(0..<OnboardingPageSteps.count) {it in
                            if it == currentStep {
                                Rectangle()
                                    .frame(width: 20, height: 10)
                                    .foregroundColor(.yellow)
                                    .cornerRadius(10)
                            } else {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                
                Button("Notification") {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {success, error in
                        if success {
                            print("All set!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Catat keuangan kamu di Wallsmart!"
                    content.body = "Katanya pengen kaya, kok gak rajin catat keuangan?"
                    content.sound = UNNotificationSound.default

                    if let thisHour = Calendar.current.dateComponents([.day], from: Date()).day,
                        let selectedHour = Calendar.current.dateComponents([.day], from: self.hariTglText).day {
                        // Note, this sends the notification at the selectedHour or later
                        if (thisHour >= selectedHour) {
                            var dateComponents = DateComponents()
                            dateComponents.day = selectedHour
                            dateComponents.hour = 00

                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2592000, repeats: true)
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request)
                        }
                    }
                }
                
                Button(action: {
                    if self.currentStep < OnboardingPageSteps.count - 1 {
                        self.currentStep += 1
                    }
                    tapCount += 1
                    UserDefaults.standard.set(self.tapCount, forKey: "Open")
                    print(tapCount)
                }){
                    Text(currentStep < OnboardingPageSteps.count - 1 ? "Next" : "Get Start!")
                        .foregroundColor(.white)
                        .bold()
                }
                .frame(width: 320, height: 40)
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(color:.gray, radius: 3, x: 2, y: 3)
                .padding(.bottom, 80)
                .padding(.top, 20)
            }
        }
        .animation(.default)
    }
}

struct OnboardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage()
    }
}
