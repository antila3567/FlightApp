//
//  Home.swift
//  flight
//
//  Created by Иван Легенький on 22.12.2023.
//

import SwiftUI

struct Home: View {
    var size: CGSize
    var safeArea: EdgeInsets
    
    @State var offsetY: CGFloat = 0
    @State var currentCardIndex: CGFloat = 0
    @StateObject var animator: Animator = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .overlay(alignment: .bottomTrailing, content: {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .frame(width: 40, height: 40)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .shadow(color: .white.opacity(0.8), radius: 6, x: 1, y: 1)
                            }
                    }
                    .offset(x: -15, y: 15)
                    .offset(x: animator.startAnimation ? 80 : 0)
                })
                .zIndex(1)
            PaymentCardsView()
                .zIndex(0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(content: {
            ZStack(alignment: .bottom) {
                ZStack {
                    if animator.showClouds {
                        Group {
                            CloudView(delay: 1, size: size)
                                .offset(y: size.height * -0.1)
                            CloudView(delay: 0, size: size)
                                .offset(y: size.height * 0.3)
                            CloudView(delay: 2.5, size: size)
                                .offset(y: size.height * 0.2)
                            CloudView(delay: 2.5, size: size)

                        }
                    }
                }
                .frame(maxHeight: .infinity)
                
                if animator.showLoadingView {
                    BackgroundView()
                        .transition(.scale)
                        .opacity(animator.showFinalView ? 0 : 1)
                }
            }
        })
        .allowsHitTesting(!animator.showFinalView)
        .background(content: {
            if animator.startAnimation {
                DetailsView(size: size, safeArea: safeArea)
                    .environmentObject(animator)
            }
        })
        .overlayPreferenceValue(RectKey.self, { value in
            if let anchor = value["PLANEBOUNDS"] {
                GeometryReader { proxy in
                    let rect = proxy[anchor]
                    let planeRect = animator.initialPlanePosition
                    let status = animator.currentPaymentStatus
                    let animationStatus = status == .finished && !animator.showFinalView
                    
                    Image("Airplane")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: planeRect.width, height: planeRect.height)
                        .rotationEffect(.init(degrees: animationStatus ? -10 : 0))
                        .shadow(color: .black.opacity(0.25), radius: 1, x: status == .finished ? -400 : 0, y: status == .finished ? 170 : 0)
                        .offset(x: planeRect.minX, y: planeRect.minY)
                        .offset(y: animator.startAnimation ? 50 : 0)
                        .scaleEffect(animator.showFinalView ? 0.9 : 1)
                        .offset(y: animator.showFinalView ? 30 : 0)
                        .onAppear {
                            animator.initialPlanePosition = rect
                        }
                        .animation(.easeInOut(duration: animationStatus ? 3.5 : 1.5), value: animationStatus)
                }
            }
        })
        .overlay(content: {
            if animator.showClouds {
                CloudView(delay: 2.2, size: size)
                    .offset(y: -size.height * 0.25)
            }
        })
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .onChange(of: animator.currentPaymentStatus) { newValue in
            if newValue == .finished {
                animator.showClouds = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animator.showFinalView = true
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 0.4)
                .frame(maxWidth: .infinity, alignment: .leading)
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
            
            Image("Airplane")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 160)
                .opacity(0)
                .anchorPreference(key: RectKey.self,value: .bounds, transform: { anchor in
                    return ["PLANEBOUNDS": anchor]
                })
                .padding(.bottom, -20)
        }
        .padding([.horizontal, .top],15)
        .padding(.top, safeArea.top)
        .background {
            Rectangle()
                .fill(.linearGradient(colors: [
                    Color("Dark"),
                    Color("Dark"),
                    Color(.black),
                ], startPoint: .top, endPoint: .bottom))
        }
        .rotation3DEffect(.init(degrees: animator.startAnimation ? 90 : 0), axis: (x: 1, y: 0, z: 0), anchor: .init(x: 0.5, y: 0.8))
        .offset(y: animator.startAnimation ? -100 : 0)
    }
    
    @ViewBuilder
    func PaymentCardsView() -> some View {
        VStack {
            Text("SELECT PAYMENT CARD")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.vertical)
            
            GeometryReader {_ in
                VStack(spacing: 0) {
                    ForEach(sampleCards.indices, id: \.self) {index in
                        CardView(index: index)
                    }
                }
                .padding(.horizontal, 30)
                .offset(y: offsetY)
                .offset(y: currentCardIndex * -200.0)
                
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .clear,
                        .clear,
                        .clear,
                        .clear,
                        .white.opacity(0.3),
                        .white.opacity(0.7),
                        .white
                    ], startPoint: .top, endPoint: .bottom))
                    .allowsHitTesting(false)
                
                Button(action: buyTicket) {
                    Text("Confirm $2,721.00")
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, safeArea.bottom == 0 ? 15 : safeArea.bottom - 10)
            }
            .coordinateSpace(name: "SCROLL")
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged({value in
                    offsetY = value.translation.height * 0.3
                }).onEnded({value in
                    let translation = value.translation.height
                    
                    withAnimation(.easeInOut) {
                        
                        if translation > 0 && translation > 100 && currentCardIndex > 0 {
                            currentCardIndex -= 1
                        }
                        
                        if translation < 0 && -translation > 100 && currentCardIndex < CGFloat(sampleCards.count - 1) {
                            CGFloat(sampleCards.count - 1)
                            currentCardIndex += 1
                        }
                        
                        offsetY = .zero
                    }
                })
        )
        .background {
            Color.black
                .ignoresSafeArea()
        }
        .clipped()
        .rotation3DEffect(.init(degrees: animator.startAnimation ? -90 : 0), axis: (x: 1, y: 0, z: 0), anchor: .init(x: 0.5, y: 0.25))
        .offset(y: animator.startAnimation ? 100 : 0)
    }
    
    func buyTicket() {
        withAnimation(.easeInOut(duration: 0.85)) {
            animator.startAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.7)) {
                animator.showLoadingView = true
            }
        }
    }
    
    @ViewBuilder
    func CardView(index: Int) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / size.height
            let constrainedProgress = progress > 1 ? 1 : progress < 0 ? 0 : progress
            
            Image(sampleCards[index].cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .shadow(color: .black.opacity(0.8), radius: 8, x: 6, y: 6)
                .rotation3DEffect(.init(degrees: constrainedProgress * 40.0), axis: (x: 1, y: 0, z: 0), anchor: .bottom)
                .padding(.top, progress * -160.0)
                .offset(y: progress < 0 ? progress * 250 : 0)
        }
        .frame(height: 200)
        .zIndex(Double(sampleCards.count - index))
        .onTapGesture {
            
        }
    }
    
    @ViewBuilder
    func BackgroundView() -> some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(PaymentStatus.allCases, id: \.rawValue) { status in
                    Text(status.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.3))
                        .frame(height: 30)
                }
            }
            .offset(y: animator.currentPaymentStatus == .started ? -30 : animator.currentPaymentStatus == .finished ? -60 : 0)
            .frame(height: 30, alignment: .top)
            .clipped()
            .zIndex(1)
            
            ZStack {
                Circle()
                    .fill(Color("BG"))
                    .shadow(color: .white.opacity(0.45), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: -5, y: -5)
                    .scaleEffect(animator.ringAnimation[0] ? 5 : 1)
                    .opacity(animator.ringAnimation[0] ? 0 : 1)
                Circle()
                    .fill(Color("BG"))
                    .shadow(color: .white.opacity(0.45), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: -5, y: -5)
                    .scaleEffect(animator.ringAnimation[1] ? 5 : 1)
                    .opacity(animator.ringAnimation[1] ? 0 : 1)
                Circle()
                    .fill(Color("BG"))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    .scaleEffect(1.22)
                Circle()
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    
                Image(systemName: animator.currentPaymentStatus.symbolImage)
                    .font(.largeTitle)
                    .foregroundColor(.black.opacity(0.5))
            }
            .frame( width: 80, height: 80)
            .padding(.top, 20)
            .zIndex(0)
          }
            .onReceive(Timer.publish(every: 2.3, on: .main, in: .common).autoconnect()) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    if animator.currentPaymentStatus == .initiated {
                        animator.currentPaymentStatus = .started
                    } else {
                        animator.currentPaymentStatus = .finished
                    }
                }
            }
            .onAppear(perform: {
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                    animator.ringAnimation[0] = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                        animator.ringAnimation[1] = true
                    }
                }
            })
            .padding(.bottom, size.height * 0.15)
        }
    }


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CloudView: View {
    var delay: Double
    var size: CGSize
    
    @State private var moveCloud: Bool = false
    
    var body: some View {
        ZStack {
            Image("Cloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 3)
                .offset(x: moveCloud ? -size.width * 2 : size.width * 2)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 5.5).delay(delay)) {
                moveCloud.toggle()
            }
        }
    }
}

class Animator: ObservableObject {
    @Published var startAnimation: Bool = false
    @Published var initialPlanePosition: CGRect = .zero
    @Published var currentPaymentStatus: PaymentStatus = .initiated
    @Published var ringAnimation: [Bool] = [false, false]
    @Published var showLoadingView: Bool = false
    @Published var showClouds: Bool = false
    @Published var showFinalView: Bool = false
}

struct RectKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()){$1}
    }
}
