//
//  LocationSearchActivationView.swift
//  UberSwiftUI
//
//  Created by Maciej on 12/10/2022.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(.black)
                .frame(width: 8,height: 8)
                .padding(.horizontal)
            
            Text("Where to?")
                .foregroundColor(Color(.darkGray))
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .background(
            Rectangle()
                .fill(.white)
                .shadow(color: .black.opacity(0.5), radius: 6)
        )
        .padding(.horizontal, 16)
        
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}
