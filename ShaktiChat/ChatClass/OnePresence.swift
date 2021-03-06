//
//  OnePresence.swift
//  OneChat
//
//  Created by Paul on 27/02/2015.
//  Copyright (c) 2015 ProcessOne. All rights reserved.
//

import Foundation
import XMPPFramework

// MARK: Protocol
public protocol OnePresenceDelegate {
    func onePresenceDidReceivePresence(status:String)
}

open class OnePresence: NSObject {
	var delegate: OnePresenceDelegate!
	
	// MARK: Singleton
	
	class var sharedInstance : OnePresence {
		struct OnePresenceSingleton {
			static let instance = OnePresence()
		}
		return OnePresenceSingleton.instance
	}
	
	// MARK: Functions
	
	class func goOnline() {
		let presence = XMPPPresence()
		let domain = OneChat.sharedInstance.xmppStream!.myJID.domain
		
		if domain == "gmail.com" || domain == "gtalk.com" || domain == "talk.google.com" {
			let priority: DDXMLElement = DDXMLElement(name: "priority", stringValue: "24")
			presence?.addChild(priority)
		}
		
		OneChat.sharedInstance.xmppStream?.send(presence)
	}
	
	class func goOffline() {
		var _ = XMPPPresence(type: "unavailable")
	}
}

extension OnePresence: XMPPStreamDelegate {
	
    public func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence) {
        //    print("presence-\(presence)-")
        let presenceType = presence.type()
        let username = sender.myJID.user
        let presenceFromUser = presence.from().user
        
        if presenceFromUser != username  {
            if presenceType == "available" {
                delegate?.onePresenceDidReceivePresence(status: "Online")
                print("available")
            }
            else if presenceType == "subscribe" {
                   print("subscribe")
                delegate?.onePresenceDidReceivePresence(status: "")
            }
            else {
                print("presence type \(presenceType)")
                delegate?.onePresenceDidReceivePresence(status: "")

            }
        }
        
    }
}
