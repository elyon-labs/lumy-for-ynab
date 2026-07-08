//
//  ContentView.swift
//  YNAB
//
//  Created by Brandon Trautmann on 6/28/23.
//

import SwiftUI

struct ContentView: View {
    let clientId = "3hyAebNx_82TtLJU4xv1QvBBNhpG3dBAWLKnw8TS5Ww"
    let redirectUri = "dev.brandontrautmann.ynab://authentication"
    var body: some View {
        VStack {
            Link(
                destination: URL(string: "https://app.ynab.com/oauth/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)&response_type=token")!
            ) {
                Text("Hello World")
        }
        .padding()
    }
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
