//
//  PDFView.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 15/12/22.
//

import SwiftUI
import WebKit


struct WebView: UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}

struct PDFView: View {
    @AppStorage("resume") var s_resume = ""
    var body: some View {
        WebView(request: URLRequest(url: URL(string: s_resume)!))
                  
               }
    
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFView()
    }
}
