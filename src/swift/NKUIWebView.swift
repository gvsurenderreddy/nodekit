/*
* nodekit.io
*
* Copyright (c) 2015 Domabo. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Cocoa
import WebKit

class NKUIWebView: NSObject {
    
    var mainWindow : NSWindow! = nil
    
    init(urlAddress: NSString, title:NSString, width:CGFloat, height:CGFloat )
    {
        var windowRect : NSRect = (NSScreen.mainScreen()!).frame
        var frameRect : NSRect = NSMakeRect(
            (NSWidth(windowRect) - width)/2,
            (NSHeight(windowRect) - height)/2,
            width, height)
        
        var viewRect : NSRect = NSMakeRect(0,0,width, height);
     
        mainWindow = NSWindow(contentRect: frameRect, styleMask: NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask, backing: NSBackingStoreType.Buffered, defer: false, screen: NSScreen.mainScreen())
        
        if (mainWindows == nil) {
            mainWindows = NSMutableArray()
        }
        
        mainWindows?.addObject(mainWindow)
        var webview:WebView = WebView(frame: viewRect)
        
        super.init()
        
        var webPrefs : WebPreferences = WebPreferences.standardPreferences()
        
        webPrefs.javaEnabled = false
        webPrefs.plugInsEnabled = false
        webPrefs.javaScriptEnabled = true
        webPrefs.javaScriptCanOpenWindowsAutomatically = false
        webPrefs.loadsImagesAutomatically = true
        webPrefs.allowsAnimatedImages = true
        webPrefs.allowsAnimatedImageLooping = true
        webPrefs.shouldPrintBackgrounds = true
        webPrefs.userStyleSheetEnabled = false
   
        webview.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable
        
        webview.applicationNameForUserAgent = "nodeKit"
        webview.drawsBackground = false
        webview.preferences = webPrefs
        
        mainWindow.makeKeyAndOrderFront(nil)
        mainWindow.contentView = webview
        mainWindow.title = title
        
        NSURLProtocol.registerClass(NKUrlProtocolLocalFile)
        NSURLProtocol.registerClass(NKUrlProtocolCustom)
        
        NKJavascriptBridge.registerStringViewer( { (msg: String?, title: String?) -> () in
          webview.mainFrame.loadHTMLString(msg, baseURL: NSURL(string: "about:blank"))
            return
        });
        
        NKJavascriptBridge.registerNavigator ({ (uri: String?, title: String?) -> () in
            var requestObj: NSURLRequest = NSURLRequest(URL: NSURL(string: uri!)!)
            self.mainWindow.title = title
            webview.mainFrame.loadRequest(requestObj)
            return
        });
        
        NKJavascriptBridge.registerResizer ({ (width: NSNumber?, height: NSNumber?) -> () in
            var widthCG = CGFloat(width!)
            var heightCG = CGFloat(height!)
            
            var windowRect : NSRect = (NSScreen.mainScreen()!).frame
            var frameRect : NSRect = NSMakeRect(
                (NSWidth(windowRect) - widthCG)/2,
                (NSHeight(windowRect) - heightCG)/2,
                widthCG, heightCG)
            
            self.mainWindow.setFrame(frameRect, display: true,animate: true)
                 return
        });
        
          
        var url = NSURL(string: urlAddress)
        var requestObj: NSURLRequest = NSURLRequest(URL: url!)
        webview.mainFrame.loadRequest(requestObj)
    }
    
    
}
