//
//  HomeScreen.swift
//  Price Chart SwiftUI
//
//  Created by Samony Chithian on 14/1/23.
//

import SwiftUI
import Charts


struct HomeScreen: View {
    
    //MARK:  State Chart data for animation
    @State var sample:[Price] = sample_analytics
    
    @State var currentTab: String = "1Day"
    //MARK: gesture properties
    @State var currentActiveItem: Price?
    
    @State var plotWidth: CGFloat = 0
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack(alignment: .leading, spacing: 12){
                    HStack{
                        Text("BTC")
                            .fontWeight(.bold)
                            .foregroundColor(Color.orange)
                            .font(.title)
                            .padding(.leading,12)
                        Picker("", selection: $currentTab) {
                            Text("1Day").tag("1Day")
                            Text("1Week").tag("1Week")
                            Text("1Month").tag("1Month")
                        }
                        .pickerStyle(.segmented)
                        .padding(.leading,20)
                    }
                     
                    
                    AnimationChart()
                }
                .background {
                    RoundedRectangle(cornerRadius: 10,style: .continuous)
                        .fill(.white.shadow(.drop(radius: 2)))
                }
                
            }
        
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationTitle("Crypto Currency")
            
            //MARK : Update Value of Picker for Segmented Tab
            .onChange(of: currentTab) {newValue in
                sample = sample_analytics
                if newValue != "1Day"{
                    for (index,_) in sample.enumerated(){
                        sample[index].price = .random(in: 100...2000)
                    }
                }
                
                //Re-Animation
                animationGraph(formChange:  true)
                
            }
        }
    }
     
    @ViewBuilder
    func AnimationChart()->some View{
        
        let max = sample.max{ item1,item2 in
            return item2.price > item1.price
        }?.price ?? 0
        Chart {
            ForEach(sample) {item in
                //Bar Chart
                BarMark(
                    x: .value("Hours", item.hour, unit: .hour ),
                    y: .value("Price", item.animate ? item.price : 0)
                )
                .foregroundStyle(Color.orange.gradient)
                
                //MARK: Rule Mark for current
                if let currentActiveItem, currentActiveItem.id == item.id {
                    RuleMark(x: .value("Hour", currentActiveItem.hour))
                    
                    //MARK: Dotted Style
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [5]))
                    
                        //MARK: Setting in middle of each BAr
                        .offset(x: (plotWidth / CGFloat(sample.count)) / 2)
                        .annotation(position: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Price")
                                    .font(.caption)
                                    .foregroundColor(Color.red)
                                 
                            }
                        }
                }
                    
            }
        }
        .foregroundColor(Color.orange)
        .chartYScale(domain: 0...(max + 100))
        //MARK: Gesture to Hightlight Current Bar
        .chartOverlay(content: { proxy in
            GeometryReader{innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged{value in
                                //
                                let location   = value.location
                                if let date:Date = proxy.value(atX: location.x) {
                                    
                                    let calendar = Calendar.current
                                    let hour  = calendar.component(.hour, from: date)
                                    print(hour)
                                    
                                    if let currentItem = sample.first(where: {item in
                                        calendar.component(.hour, from: date) == hour
                                        
                                    }){
                                        print(currentItem.price)
                                        self.currentActiveItem = currentItem
                                        self.plotWidth = proxy.plotAreaSize.width
                                    }
                                }
                            }.onEnded{value in
                                //
                                self.currentActiveItem = nil
                            }
                    )
                
            }
            
        })
        .frame(height:350)
        .onAppear {
            animationGraph()
        }
        
        
    }
    
    //MARK: Animation
    
    func animationGraph(formChange:Bool = false){
        for (index,_) in sample.enumerated(){
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (formChange ? 0.03 : 0.05)){
                withAnimation(formChange ? .easeInOut(duration: 0.8) :  .interactiveSpring(response: 0.8, dampingFraction: 0.8,blendDuration: 0.8)) {
                    sample[index].animate = true
                }
            }
        }

    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
