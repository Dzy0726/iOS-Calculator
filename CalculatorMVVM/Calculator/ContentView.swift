import SwiftUI


struct ContentView: View {
    
    @State var data:CalData = CalData()
    
    var body: some View {
            VStack(spacing : 20) {
                Text(self.data.text)
                    .frame(maxWidth:.infinity,maxHeight:200,alignment: .trailing)
                    .padding(.trailing,50)
                    .font(.system(size: 60))
                    .foregroundColor(Color("result_fg"))
                    .opacity(self.data.opacity)
                
                ForEach(0..<calculatorNumber.count) { i in
                    HStack {
                        ForEach(0..<calculatorNumber[i].count ) { j in
                            CustomButton(calculatorNumber[i][j],self.$data)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(Color("Color_bg"))
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
