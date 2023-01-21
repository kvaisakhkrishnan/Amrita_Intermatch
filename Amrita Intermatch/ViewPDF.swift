//
//  ViewPDF.swift
//  Amrita Intermatch
//
//  Created by Vaisakhkrishnan K on 16/12/22.
//


import SwiftUI
import WebKit

struct ViewPDF: View {
    @State var link : String
    var body: some View {
        Webview(url: URL(string: "https://google.com")!, navigationDelegate: WebViewNavigationDelegate())
    }
}

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // remove activity indicator here
    }
}

struct Webview: UIViewRepresentable {
    let url: URL
    let navigationDelegate: WKNavigationDelegate

    func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
        let webview = WKWebView()
        webview.navigationDelegate = navigationDelegate
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<Webview>) {
        let request = URLRequest(url: self.url)
        uiView.load(request)
    }
}



    
    



struct ViewPDF_Previews: PreviewProvider {
    static var previews: some View {
        ViewPDF(link: "")
    }
}
