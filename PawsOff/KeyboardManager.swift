import Foundation
import CoreGraphics
import ApplicationServices
import Combine
import AppKit

final class KeyboardManager: ObservableObject {
    @Published private(set) var isLocked = false
    @Published private(set) var hasAccessibilityPermission = false
    
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var permissionCheckTimer: Timer?
    
    init() {
        checkAccessibilityPermission()
        startPermissionPolling()
    }
    
    private func startPermissionPolling() {
        permissionCheckTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.checkAccessibilityPermission()
        }
    }
    
    func checkAccessibilityPermission() {
        let trusted = AXIsProcessTrusted()
        
        if trusted != hasAccessibilityPermission {
            hasAccessibilityPermission = trusted
        }
        
        if trusted {
            permissionCheckTimer?.invalidate()
            permissionCheckTimer = nil
        }
    }
    
    func requestAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.checkAccessibilityPermission()
        }
    }
    
    func openAccessibilitySettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }
    
    func toggleLock() {
        checkAccessibilityPermission()
        
        if isLocked {
            stopBlocking()
        } else {
            startBlocking()
        }
    }
    
    private func startBlocking() {
        let trusted = AXIsProcessTrusted()
        
        guard trusted else {
            hasAccessibilityPermission = false
            requestAccessibilityPermission()
            return
        }
        
        hasAccessibilityPermission = true
        
        let eventMask: CGEventMask = (1 << CGEventType.keyDown.rawValue) |
                                      (1 << CGEventType.keyUp.rawValue) |
                                      (1 << CGEventType.flagsChanged.rawValue) |
                                      (1 << 14)
        
        let callback: CGEventTapCallBack = { proxy, type, event, refcon in
            if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
                if let refcon = refcon {
                    let manager = Unmanaged<KeyboardManager>.fromOpaque(refcon).takeUnretainedValue()
                    if let tap = manager.eventTap {
                        CGEvent.tapEnable(tap: tap, enable: true)
                    }
                }
                return Unmanaged.passRetained(event)
            }
            
            return nil
        }
        
        let refcon = Unmanaged.passUnretained(self).toOpaque()
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: callback,
            userInfo: refcon
        )
        
        guard let eventTap = eventTap else {
            return
        }
        
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        
        if let runLoopSource = runLoopSource {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
            isLocked = true
        }
    }
    
    private func stopBlocking() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            
            if let runLoopSource = runLoopSource {
                CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            }
            
            CFMachPortInvalidate(eventTap)
        }
        
        eventTap = nil
        runLoopSource = nil
        isLocked = false
    }
    
    deinit {
        permissionCheckTimer?.invalidate()
        stopBlocking()
    }
}
