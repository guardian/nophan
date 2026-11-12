//
//  DeviceModel.swift
//
//

import Foundation

/// Provides the hardware model identifier of the current device.
///
/// `UIDevice.current.name` and `UIDevice.current.model` only return a generic
/// "iPhone" / "iPad" on iOS 16+, so the identifier is read from the kernel instead.
enum DeviceModel {
    /// Hardware identifier, e.g. "iPhone16,2" (iPhone 15 Pro Max) or "iPad14,1".
    /// Simulators return "Simulator-<identifier>", iOS apps on Mac return e.g. "Mac14,2".
    static let identifier: String = {
        #if targetEnvironment(simulator)
        let simulatorModel = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Unknown"
        return "Simulator-\(simulatorModel)"
        #else
        if ProcessInfo.processInfo.isiOSAppOnMac, let macModel = sysctlString(named: "hw.model") {
            return macModel
        }
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafeBytes(of: &systemInfo.machine) { bytes in
            String(decoding: bytes.prefix(while: { $0 != 0 }), as: UTF8.self)
        }
        #endif
    }()

    private static func sysctlString(named name: String) -> String? {
        var size = 0
        guard sysctlbyname(name, nil, &size, nil, 0) == 0, size > 0 else { return nil }
        var buffer = [CChar](repeating: 0, count: size)
        guard sysctlbyname(name, &buffer, &size, nil, 0) == 0 else { return nil }
        return String(cString: buffer)
    }
}
