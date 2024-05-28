//
//  NophanMonitorView.swift
//
//
//  Created by Usman Nazir on 28/05/2024.
//

import SwiftUI

public struct NophanMonitorView: View {
    
    @ObservedObject var monitor = NophanMonitor.shared
    
    public var body: some View {
        VStack(alignment: .leading) {
            headerView()
            List {
                ForEach(monitor.events) { event in
                    Section {
                        ForEach(event.parameters.keys.sorted(), id: \.self) { key in
                            if let value = event.parameters[key] {
                                Text("\(key) : \(String(describing: value))")
                            }
                        }
                    } header: {
                        Text(event.httpMethod)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func headerView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Nophan Monitor")
                    .font(.title)
                    .bold()
                Text("Latest Events")
                    .font(.headline)
            }
            .padding([.horizontal, .top])
            VStack(spacing: 2) {
                Rectangle().fill(.gray).frame(height: 1)
                Rectangle().fill(.gray).frame(height: 1)
                Rectangle().fill(.gray).frame(height: 1)
                Rectangle().fill(.gray).frame(height: 1)
            }
            .padding(.top, 4)
            .padding(.bottom, -8)
        }
    }
}

#Preview {
    NophanMonitorView()
}
