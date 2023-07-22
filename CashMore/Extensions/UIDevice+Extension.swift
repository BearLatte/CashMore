//
//  UIDevice+Extension.swift
//  CashMore
//
//  Created by Tim on 2023/6/13.
//

import AdSupport
import CoreTelephony
import SystemConfiguration

fileprivate let OPEN_APP_TIME_STAMP = "kOPENAPPTIMESTAMP"

extension UIDevice : TMCompatible {}
extension TM where Base: UIDevice {
    
    
    /// 广告标识
    static var idfa : String {
        guard let idfa = UserDefaults.standard.value(forKey: Constants.IDFA_KEY) as? String else {
            return ""
        }
        
        return idfa == "00000000-0000-0000-0000-000000000000" ? "" : idfa
    }
    
    static var uuid : String? {
        Base.current.identifierForVendor?.uuidString
    }
    
    /// 手机型号
    static var model : String {
        Base.current.model
    }
    
    /// 手机充电状态
    static var batteryStatus : String {
        Base.current.isBatteryMonitoringEnabled = true
        let state = Base.current.batteryState
        switch state {
        case .charging:
            // 正在充电
            return "2"
        case .full:
            // 已充满
            return "5"
        case .unplugged:
            // 放电中
            return "3"
        default:
            // 未知
            return "1"
        }
    }
    
    /// 手机电量
    static var batteryLevel : String {
        return "\(Int(Base.current.batteryLevel * 100))"
    }
    
    /// 设置打开 App 时间
    static func setOpenAppTimeStamp() {
        let time = String(format: "%.f", Date().timeIntervalSince1970 * 1000)
        UserDefaults.standard.set(time, forKey: OPEN_APP_TIME_STAMP)
    }
    
    // 获取打开 app 时间
    static var openAppTimeStamp : String {
        return UserDefaults.standard.string(forKey: OPEN_APP_TIME_STAMP)!
    }
    
    /// ip地址
    static var ipAdress : String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? "0.0.0.0"
    }
    
    /// 开机时间
    static var bootTime : String {
        var boottime = timeval()
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout<timeval>.size

        var now = time_t()
//        var uptime: time_t = -1

        time(&now)
        if (sysctl(&mib, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0) {
//            uptime = now - boottime.tv_sec
            return String(format: "%d",  boottime.tv_sec)
        }
        return ""
    }
    
    
    /// 开机到现在的时间
    static var uptime : String {
        var boottime = timeval()
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout<timeval>.size

        var now = time_t()
        var uptime: time_t = -1

        time(&now)
        if (sysctl(&mib, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0) {
            uptime = now - boottime.tv_sec
        }
        return String(format: "%d", uptime)
    }

    static var language : String {
        // 返回设备曾使用过的语言列表
        let languages: [String] = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        // 当前使用的语言排在第一
        let currentLanguage = languages.first
        return currentLanguage ?? ""
    }
    
    /// 获取网络类型
    static var networkType : String {
        var zeroAddress = sockaddr_storage()
        bzero(&zeroAddress, MemoryLayout<sockaddr_storage>.size)
        zeroAddress.ss_len = __uint8_t(MemoryLayout<sockaddr_storage>.size)
        zeroAddress.ss_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { address in
                SCNetworkReachabilityCreateWithAddress(nil, address)
            }
        }
        guard let defaultRouteReachability = defaultRouteReachability else {
            return notReachable
        }
        var flags = SCNetworkReachabilityFlags()
        let didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        
        guard didRetrieveFlags == true,
              (flags.contains(.reachable) && !flags.contains(.connectionRequired)) == true
        else {
            return notReachable
        }
        if flags.contains(.connectionRequired) {
            return notReachable
        } else if flags.contains(.isWWAN) {
            return cellularType
        } else {
            return "NETWORK_WIFI"
        }
    }
        
    /// 获取蜂窝数据类型
    static var cellularType : String {
        let info = CTTelephonyNetworkInfo()
        var status: String
        
        if #available(iOS 12.0, *) {
            guard let dict = info.serviceCurrentRadioAccessTechnology,
                  let firstKey = dict.keys.first,
                  let statusTemp = dict[firstKey] else {
                return notReachable
            }
            status = statusTemp
        } else {
            guard let statusTemp = info.currentRadioAccessTechnology else {
                return notReachable
            }
            status = statusTemp
        }
        
        if #available(iOS 14.1, *) {
            if status == CTRadioAccessTechnologyNR || status == CTRadioAccessTechnologyNRNSA {
                return "NETWORK_5G"
            }
        }
        
        switch status {
        case CTRadioAccessTechnologyGPRS,
            CTRadioAccessTechnologyEdge,
        CTRadioAccessTechnologyCDMA1x:
            return "NETWORK_2G"
        case CTRadioAccessTechnologyWCDMA,
            CTRadioAccessTechnologyHSDPA,
            CTRadioAccessTechnologyHSUPA,
            CTRadioAccessTechnologyeHRPD,
            CTRadioAccessTechnologyCDMAEVDORev0,
            CTRadioAccessTechnologyCDMAEVDORevA,
        CTRadioAccessTechnologyCDMAEVDORevB:
            return "NETWORK_3G"
        case CTRadioAccessTechnologyLTE:
            return "NETWORK_4G"
        default:
            return notReachable
        }
    }
    
    /// 无网络返回字样
    private static var notReachable: String {
        get {
            return "notReachable"
        }
    }
    
    
    //MARK: - Get memory size
//    static var totalMemorySize : String {
//        let totalMemorySize = ProcessInfo().physicalMemory
//        return fileSizeToString(fileSize: totalMemorySize)
//    }
//

//    private static func fileSizeToString(fileSize: UInt64) -> String {
//        let KB : CGFloat = 1024
//        let MB : CGFloat = KB*KB
//        let GB : CGFloat = MB * MB
//
//        if fileSize < 10 {
//            return "0B"
//        } else if fileSize < Int(KB) {
//            return "< 1KB"
//        } else if fileSize < Int(MB) {
//            return String(format: "%.2fKB", CGFloat(fileSize) / KB)
//        } else if fileSize < Int(GB) {
//            return String(format: "%.2fMB", CGFloat(fileSize) / MB)
//        } else {
//            return String(format: "%.2fGB", CGFloat(fileSize) / GB)
//        }
//    }
    
    //MARK: - Get Disk size
    static var totalDiskSpaceInGB:String {
       return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    static var freeDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    static var usedDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    static var totalDiskSpaceInMB:String {
        return MBFormatter(totalDiskSpaceInBytes)
    }
    
    static var freeDiskSpaceInMB:String {
        return MBFormatter(freeDiskSpaceInBytes)
    }
    
    static var usedDiskSpaceInMB:String {
        return MBFormatter(usedDiskSpaceInBytes)
    }
    
    //MARK: Get raw value
    static var totalDiskSpaceInBytes:Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }
    
    /*
     Total available capacity in bytes for "Important" resources, including space expected to be cleared by purging non-essential and cached resources. "Important" means something that the user or application clearly expects to be present on the local system, but is ultimately replaceable. This would include items that the user has explicitly requested via the UI, and resources that an application requires in order to provide functionality.
     Examples: A video that the user has explicitly requested to watch but has not yet finished watching or an audio file that the user has requested to download.
     This value should not be used in determining if there is room for an irreplaceable resource. In the case of irreplaceable resources, always attempt to save the resource regardless of available capacity and handle failure as gracefully as possible.
     */
    static var freeDiskSpaceInBytes:Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
        }
    }
    
    static var usedDiskSpaceInBytes:Int64 {
       return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    }
    
    private static func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }
}
