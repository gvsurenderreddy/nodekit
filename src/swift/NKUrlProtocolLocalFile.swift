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

import Foundation
import Cocoa

class NKUrlProtocolLocalFile: NSURLProtocol {
    
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        
        if (request.URL.host == nil)
        { return false;}
        
        
        if ((request.URL.scheme?.caseInsensitiveCompare("internal") == NSComparisonResult.OrderedSame)
        || (request.URL.host?.caseInsensitiveCompare("internal") == NSComparisonResult.OrderedSame))
        {
            return true
        }
        else
        {
        return false
        }
       
    }
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request;
    }
    
    override class func requestIsCacheEquivalent(a: NSURLRequest?, toRequest:NSURLRequest?) -> Bool {
        return false
    }
  
    override func startLoading() {
        
        let request: NSURLRequest = self.request
        let client: NSURLProtocolClient! = self.client;
        
        
        if (request.URL.absoluteString == "internal://close") || (request.URL.absoluteString == "http://internal/close")
        {
            NSApplication.sharedApplication().terminate(nil)
            return
        }
        println(request.URL.absoluteString!)
   
        let urlDecode = NKUrlFileDecode(request: request)
        
        if (urlDecode.exists())
        {
            let data: NSData! = NSData(contentsOfFile: urlDecode.resourcePath!)
            
            let response: NSURLResponse = NSURLResponse(URL: request.URL, MIMEType: urlDecode.mimeType, expectedContentLength: data.length, textEncodingName: urlDecode.textEncoding)
            
            client.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: NSURLCacheStoragePolicy.AllowedInMemoryOnly)
            
            client.URLProtocol(self, didLoadData: data)
            client.URLProtocolDidFinishLoading(self)
            
        }
        else {
            NSLog("Missing File %@", request.URL);
            client.URLProtocol(self, didFailWithError: NSError(domain: NSURLErrorDomain, code: NSURLErrorFileDoesNotExist, userInfo:  nil))
        }
    }
    
    override func stopLoading() {
    }
}
