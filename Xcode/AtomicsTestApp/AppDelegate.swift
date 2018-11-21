//
//  AppDelegate.swift
//  Atomics_TestApp
//

import UIKit

import Atomics
import CAtomics

#if !swift(>=4.2)
extension UIApplication { typealias LaunchOptionsKey = UIApplicationLaunchOptionsKey }
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
  {
    var padded = AtomicCacheLineAlignedOptionalRawPointer()
    assert(MemoryLayout<AtomicCacheLineAlignedOptionalRawPointer>.alignment > MemoryLayout<UnsafeRawPointer>.alignment)
    assert(MemoryLayout<AtomicCacheLineAlignedOptionalRawPointer>.alignment == 64)
    let p = UnsafeRawPointer(bitPattern: 1013)
    padded.initialize(p)
    assert(padded.load(.relaxed) != nil)
    let q = padded.swap(nil, .sequential)
    assert(q == p)
    assert(padded.load(.relaxed) == nil)

    var bool = AtomicBool()
    bool.store(false)
    let f = bool.swap(true, .sequential)
    assert(f == false)
    assert(bool.load(order: .acquire))
    return bool.value
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

