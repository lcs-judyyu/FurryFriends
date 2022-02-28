//
//  LottieView.swift
//  FurryFriends
//
//  Created by Judy Yu on 2022-02-28.
//

import UIKit
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {

    @State var animationNamed: String

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        
        let view = UIView(frame: .zero)
        
        // Lottie View
        let animationView = AnimationView()
        let animation = Animation.named(animationNamed)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.play()
        
        // Constraints
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    typealias UIViewType = UIView
    
    struct LottieView_Previews: PreviewProvider {
        static var previews: some View {
            LottieView(animationNamed: "782-check-mark-success")
        }
    }
}
