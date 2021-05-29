
import SwiftUI

struct ContentView: View {
  @State var game = Game()
  @State var guess: RGB
  @State var showScore = false

    let circleSize: CGFloat = 0.5
    let labelWidth: CGFloat = 0.53
    let labelHeignt: CGFloat = 0.06
    let buttonWidth: CGFloat = 0.87
    
  var body: some View {
    GeometryReader { geometry in
        ZStack {
           Color .element.edgesIgnoringSafeArea(.all)
            VStack {
                ColorCircle(rgb: game.target, size: geometry.size.width * circleSize)
              if !showScore {
                BevelText (
                    text: "R: ??? G: ??? B: ???", width: geometry.size.width * labelWidth, height: geometry.size.height * labelHeignt )
                  //.padding()
              } else {
                BevelText (
                    text: game.target.intString, width: geometry.size.width * labelWidth, height: geometry.size.height * labelHeignt
                )
                //.padding()
              }
                ColorCircle(rgb: guess, size: geometry.size.width * circleSize)
             BevelText (
                text: guess.intString, width: geometry.size.width * labelWidth, height: geometry.size.height * labelHeignt
                )
                VStack {
              ColorSlider(value: $guess.red, trackColor: .red)
              ColorSlider(value: $guess.green, trackColor: .green)
              ColorSlider(value: $guess.blue, trackColor: .blue)
                }.font(.subheadline)
              Button("Hit Me!") {
                self.showScore = true
                self.game.check(guess: guess)
              }
              .buttonStyle(NeuButtonStyle(width: geometry.size.width * buttonWidth, height: geometry.size.height * labelHeignt))
              .alert(isPresented: $showScore) {
                Alert(
                  title: Text("Your Score"),
                  message: Text(String(game.scoreRound)),
                  dismissButton: .default(Text("OK")) {
                    self.game.startNewRound()
                    self.guess = RGB()
                  })
              }
            }.font(.headline)
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
        ContentView(guess: RGB())
            
            
    }
        //.preferredColorScheme(.dark)
  }
}

struct ColorSlider: View {
  @Binding var value: Double
  var trackColor: Color
  var body: some View {
    HStack {
      Text("0")
      Slider(value: $value)
        .accentColor(trackColor)
      Text("255")
    }
    .padding(.horizontal)
  }
}
