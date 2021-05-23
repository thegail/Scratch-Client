//
//  ContentView.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/6/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RenderView()
			.frame(width: 400, height: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
