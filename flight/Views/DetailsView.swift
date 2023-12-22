//
//  DetailsView.swift
//  flight
//
//  Created by Иван Легенький on 22.12.2023.
//

import SwiftUI

struct DetailsView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    
    @EnvironmentObject var animator: Animator
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    Text("Your order has submitted")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    Text("We are waiting for booking confirmation")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 30)
                .padding(.bottom, 40)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.white.opacity(0.1))
                }
                
                HStack {
                    FlightDetailsView(place: "Odessa sity", code: "ODS", timing: "31 Dec, 23:59")
                    
                    VStack {
                        Text("30m")
                            .padding(.bottom, 10)
                        Image(systemName: "chevron.right")
                            .font(.title2)

                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    
                    FlightDetailsView(alligment: .trailing, place: "Kyiv sity", code: "KYV", timing: "1 Jan, 00:30")
                }
                .padding(.top, 20)
                .padding(.bottom, 70)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
                .padding(.top, -30)
            }
            .padding(.horizontal, 20)
            .padding(.top, safeArea.top + 15)
            .padding([.horizontal, .bottom], 15)
            .offset(y: animator.showFinalView ? 0 : 300)
            .background {
                Rectangle()
                    .fill(Color("Dark"))
                    .scaleEffect(y: animator.showFinalView ? 1 : 0.001, anchor: .top)
                    .padding(.bottom, 80)
            }
            .clipped()
            
            GeometryReader {proxy in
                ViewThatFits {
                    ContactInformation()
                    ScrollView(.vertical, showsIndicators: false) {
                        ContactInformation()
                    }
                }
                .offset(y: animator.showFinalView ? 0 : size.height)
            }
        }
        .animation(.easeInOut(duration: animator.showFinalView ? 0.7 : 0.3).delay(animator.showFinalView ? 0.7 : 0), value: animator.showFinalView)

    }
    
    @ViewBuilder
    func ContactInformation() -> some View {
        VStack(spacing: 15) {
            HStack {
                InfoView(title: "Flight", subTitle: "FMC 224")
                InfoView(title: "Class", subTitle: "Luxury")
                InfoView(title: "Aircraft", subTitle: "B 737-007")
                InfoView(title: "Time", subTitle: "22:00")
            }
            ContactView(name: "Jane", email: "Jane.smth@gmail.com", profile: "User 1")
                .padding(.top, 30)
            ContactView(name: "Victoria", email: "Victoria@apple.com", profile: "User 2")
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Price")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                Text("$2,534.00")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)

            
            Button(action: resetAnimationAndView){
                 Text("Go to Home Screen")
                    .font(.system(size: 22))
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 35)
                    .padding(.vertical, 13)
                    .background {
                        Rectangle()
                            .fill(Color("Dark"))
                            .cornerRadius(18)
                    }
            }
            .padding(.top, 15)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, safeArea.bottom)
        }
        .padding(15)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func ContactView(name: String, email: String, profile: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text(email)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(profile)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
        }
    }
    
    @ViewBuilder
    func InfoView(title: String, subTitle: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text(subTitle)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }
    
    func resetAnimationAndView() {
        animator.currentPaymentStatus = .started
        animator.showClouds = false
        withAnimation(.easeInOut(duration: 0.3)) {
            animator.showFinalView = false
        }
        animator.ringAnimation = [false, false]
        animator.showLoadingView = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut) {
                animator.startAnimation = false
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
