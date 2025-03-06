//import Foundation
//import RealityKit
import ARKit
// contains "openxr.h" from the official sdk
import OpenXR
import Darwin // For strncpy
import SwiftUI
import CompositorServices
//import AppDelegate

// MARK: - OpenXR Function Pointer Type Aliases

public typealias PFN_xrCreateInstance = @convention(c) (UnsafePointer<XrInstanceCreateInfo>?, UnsafeMutablePointer<XrInstance>?) -> XrResult
public typealias PFN_xrEnumerateApiLayerProperties = @convention(c) (UInt32, UnsafeMutablePointer<UInt32>?, UnsafeMutablePointer<XrApiLayerProperties>?) -> XrResult
public typealias PFN_xrEnumerateInstanceExtensionProperties = @convention(c) (UnsafePointer<CChar>?, UInt32, UnsafeMutablePointer<UInt32>?, UnsafeMutablePointer<XrExtensionProperties>?) -> XrResult
public typealias PFN_xrGetInstanceProperties = @convention(c) (XrInstance, UnsafeMutablePointer<XrInstanceProperties>?) -> XrResult
public typealias PFN_xrGetMetalGraphicsRequirementsKHR = @convention(c) (XrInstance, XrSystemId, UnsafeMutablePointer<XrGraphicsRequirementsMetalKHR>?) -> XrResult
public typealias PFN_xrApplyHapticFeedback = @convention(c) (XrSession, UnsafePointer<XrHapticActionInfo>?, UnsafePointer<XrHapticBaseHeader>?) -> XrResult
public typealias PFN_xrEnumerateSwapchainImages = @convention(c) (XrSwapchain, UInt32, UnsafeMutablePointer<UInt32>?, UnsafeMutablePointer<XrSwapchainImageMetalKHR>?) -> XrResult
public typealias PFN_xrAcquireSwapchainImage = @convention(c) (XrSwapchain, UnsafePointer<XrSwapchainImageAcquireInfo>?, UnsafeMutablePointer<UInt32>?) -> XrResult
public typealias PFN_xrCreateSwapchain = @convention(c) (XrSession, UnsafePointer<XrSwapchainCreateInfo>?, UnsafeMutablePointer<XrSwapchain>?) -> XrResult
public typealias PFN_xrAttachSessionActionSets = @convention(c) (XrSession, UnsafePointer<XrSessionActionSetsAttachInfo>?) -> XrResult
public typealias PFN_xrBeginFrame = @convention(c) (XrSession, UnsafePointer<XrFrameBeginInfo>?) -> XrResult
public typealias PFN_xrBeginSession = @convention(c) (XrSession, UnsafePointer<XrSessionBeginInfo>?) -> XrResult
public typealias PFN_xrCreateAction = @convention(c) (XrActionSet, UnsafePointer<XrActionCreateInfo>?, UnsafeMutablePointer<XrAction>?) -> XrResult
public typealias PFN_xrCreateActionSet = @convention(c) (XrInstance, UnsafePointer<XrActionSetCreateInfo>?, UnsafeMutablePointer<XrActionSet>?) -> XrResult
public typealias PFN_xrCreateActionSpace = @convention(c) (XrSession, UnsafePointer<XrActionSpaceCreateInfo>?, UnsafeMutablePointer<XrSpace>?) -> XrResult
public typealias PFN_xrCreateReferenceSpace = @convention(c) (XrSession, UnsafePointer<XrReferenceSpaceCreateInfo>?, UnsafeMutablePointer<XrSpace>?) -> XrResult
public typealias PFN_xrDestroyAction = @convention(c) (XrAction) -> XrResult
public typealias PFN_xrDestroyActionSet = @convention(c) (XrActionSet) -> XrResult
public typealias PFN_xrDestroyInstance = @convention(c) (XrInstance) -> XrResult
public typealias PFN_xrDestroySession = @convention(c) (XrSession) -> XrResult
public typealias PFN_xrDestroySpace = @convention(c) (XrSpace) -> XrResult
public typealias PFN_xrDestroySwapchain = @convention(c) (XrSwapchain) -> XrResult
public typealias PFN_xrEndFrame = @convention(c) (XrSession, UnsafePointer<XrFrameEndInfo>?) -> XrResult
public typealias PFN_xrEndSession = @convention(c) (XrSession) -> XrResult
public typealias PFN_xrEnumerateReferenceSpaces = @convention(c) (XrSession, UInt32, UnsafeMutablePointer<UInt32>?, UnsafeMutablePointer<XrReferenceSpaceType>?) -> XrResult
public typealias PFN_xrEnumerateSwapchainFormats = @convention(c) (XrSession, UInt32, UnsafeMutablePointer<UInt32>?, UnsafeMutablePointer<Int64>?) -> XrResult
public typealias PFN_xrEnumerateEnvironmentBlendModes = @convention(c) (XrInstance, XrSystemId, XrViewConfigurationType, UInt32, UnsafeMutablePointer<UInt32>?, UnsafeMutablePointer<XrEnvironmentBlendMode>?) -> XrResult
public typealias PFN_xrEnumerateViewConfigurations = @convention(c) (XrInstance, XrSystemId, UInt32, UnsafeMutablePointer<UInt32>?, UnsafeMutablePointer<XrViewConfigurationType>?) -> XrResult
public typealias PFN_xrEnumerateViewConfigurationViews = @convention(c) (XrInstance, XrSystemId, XrViewConfigurationType, UInt32, UnsafeMutablePointer<UInt32>?, UnsafeMutablePointer<XrViewConfigurationView>?) -> XrResult
public typealias PFN_xrGetActionStateBoolean = @convention(c) (XrSession, UnsafePointer<XrActionStateGetInfo>?, UnsafeMutablePointer<XrActionStateBoolean>?) -> XrResult
public typealias PFN_xrGetActionStateFloat = @convention(c) (XrSession, UnsafePointer<XrActionStateGetInfo>?, UnsafeMutablePointer<XrActionStateFloat>?) -> XrResult
public typealias PFN_xrGetActionStateVector2f = @convention(c) (XrSession, UnsafePointer<XrActionStateGetInfo>?, UnsafeMutablePointer<XrActionStateVector2f>?) -> XrResult
public typealias PFN_xrGetCurrentInteractionProfile = @convention(c) (XrSession, XrPath, UnsafeMutablePointer<XrInteractionProfileState>?) -> XrResult
public typealias PFN_xrGetReferenceSpaceBoundsRect = @convention(c) (XrSession, XrReferenceSpaceType, UnsafeMutablePointer<XrExtent2Df>?) -> XrResult
public typealias PFN_xrGetSystem = @convention(c) (XrInstance, UnsafePointer<XrSystemGetInfo>?, UnsafeMutablePointer<XrSystemId>?) -> XrResult
public typealias PFN_xrGetSystemProperties = @convention(c) (XrInstance, XrSystemId, UnsafeMutablePointer<XrSystemProperties>?) -> XrResult
public typealias PFN_xrLocateViews = @convention(c) (XrSession, UnsafePointer<XrViewLocateInfo>?, UnsafeMutablePointer<XrViewState>?, UInt32, UnsafeMutablePointer<UInt32>?, UnsafeMutablePointer<XrView>?) -> XrResult
public typealias PFN_xrLocateSpace = @convention(c) (XrSpace, XrSpace, XrTime, UnsafeMutablePointer<XrSpaceLocation>?) -> XrResult
public typealias PFN_xrPathToString = @convention(c) (XrInstance, XrPath, UInt32, UnsafeMutablePointer<UInt32>?, UnsafeMutablePointer<CChar>?) -> XrResult
public typealias PFN_xrPollEvent = @convention(c) (XrInstance, UnsafeMutablePointer<XrEventDataBuffer>?) -> XrResult
public typealias PFN_xrReleaseSwapchainImage = @convention(c) (XrSwapchain, UnsafePointer<XrSwapchainImageReleaseInfo>?) -> XrResult
public typealias PFN_xrResultToString = @convention(c) (XrInstance, XrResult, UnsafeMutablePointer<CChar>?) -> XrResult
public typealias PFN_xrStringToPath = @convention(c) (XrInstance, UnsafePointer<CChar>?, UnsafeMutablePointer<XrPath>?) -> XrResult
public typealias PFN_xrSuggestInteractionProfileBindings = @convention(c) (XrInstance, UnsafePointer<XrInteractionProfileSuggestedBinding>?) -> XrResult
public typealias PFN_xrSyncActions = @convention(c) (XrSession, UnsafePointer<XrActionsSyncInfo>?) -> XrResult

public typealias PFN_xrWaitFrame = @convention(c) (XrSession, UnsafePointer<XrFrameWaitInfo>?, UnsafeMutablePointer<XrFrameState>?) -> XrResult
public typealias PFN_xrWaitSwapchainImage = @convention(c) (XrSwapchain, UnsafePointer<XrSwapchainImageWaitInfo>?) -> XrResult

// MARK: - OpenXR API Entry Points

/// xrGetInstanceProcAddr is the main entry point that the OpenXR loader uses to query function pointers.
@_cdecl("xrGetInstanceProcAddr")
public func xrGetInstanceProcAddr(_ instance: XrInstance,
                                  _ name: UnsafePointer<CChar>?,
                                  _ function: UnsafeMutablePointer<UnsafeMutableRawPointer?>?) -> XrResult {
    guard let name = name else {
        function?.pointee = nil
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    let funcName = String(cString: name)
    switch funcName {
    case "xrCreateInstance":
        function?.pointee = unsafeBitCast(xrCreateInstance as PFN_xrCreateInstance,
                                          to: UnsafeMutableRawPointer.self)
    case "xrEnumerateApiLayerProperties":
        function?.pointee = unsafeBitCast(xrEnumerateApiLayerProperties as PFN_xrEnumerateApiLayerProperties,
                                          to: UnsafeMutableRawPointer.self)
    case "xrEnumerateInstanceExtensionProperties":
        function?.pointee = unsafeBitCast(xrEnumerateInstanceExtensionProperties as PFN_xrEnumerateInstanceExtensionProperties,
                                          to: UnsafeMutableRawPointer.self)
    case "xrGetInstanceProperties":
        function?.pointee = unsafeBitCast(xrGetInstanceProperties as PFN_xrGetInstanceProperties,
                                          to: UnsafeMutableRawPointer.self)
    case "xrGetMetalGraphicsRequirementsKHR":
        function?.pointee = unsafeBitCast(xrGetMetalGraphicsRequirementsKHR as PFN_xrGetMetalGraphicsRequirementsKHR,
                                          to: UnsafeMutableRawPointer.self)
    case "xrEnumerateSwapchainImages":
        function?.pointee = unsafeBitCast(xrEnumerateSwapchainImages as PFN_xrEnumerateSwapchainImages,
                                          to: UnsafeMutableRawPointer.self)
    case "xrAcquireSwapchainImage":
        function?.pointee = unsafeBitCast(xrAcquireSwapchainImage as PFN_xrAcquireSwapchainImage,
                                          to: UnsafeMutableRawPointer.self)
    case "xrApplyHapticFeedback":
        function?.pointee = unsafeBitCast(xrApplyHapticFeedback as PFN_xrApplyHapticFeedback,
                                          to: UnsafeMutableRawPointer.self)
    case "xrAttachSessionActionSets":
        function?.pointee = unsafeBitCast(xrAttachSessionActionSets as PFN_xrAttachSessionActionSets,
                                          to: UnsafeMutableRawPointer.self)
    case "xrBeginFrame":
        function?.pointee = unsafeBitCast(xrBeginFrame as PFN_xrBeginFrame,
                                          to: UnsafeMutableRawPointer.self)
    case "xrBeginSession":
        function?.pointee = unsafeBitCast(xrBeginSession as PFN_xrBeginSession,
                                          to: UnsafeMutableRawPointer.self)
    case "xrCreateAction":
        function?.pointee = unsafeBitCast(xrCreateAction as PFN_xrCreateAction,
                                          to: UnsafeMutableRawPointer.self)
    case "xrCreateActionSet":
        function?.pointee = unsafeBitCast(xrCreateActionSet as PFN_xrCreateActionSet,
                                          to: UnsafeMutableRawPointer.self)
    case "xrCreateActionSpace":
        function?.pointee = unsafeBitCast(xrCreateActionSpace as PFN_xrCreateActionSpace,
                                          to: UnsafeMutableRawPointer.self)
    case "xrCreateReferenceSpace":
        function?.pointee = unsafeBitCast(xrCreateReferenceSpace as PFN_xrCreateReferenceSpace,
                                          to: UnsafeMutableRawPointer.self)
    case "xrCreateSession":
        function?.pointee = unsafeBitCast(xrCreateSession as PFN_xrCreateSession,
                                          to: UnsafeMutableRawPointer.self)
    case "xrCreateSwapchain":
        function?.pointee = unsafeBitCast(xrCreateSwapchain as PFN_xrCreateSwapchain,
                                          to: UnsafeMutableRawPointer.self)
    case "xrEnumerateEnvironmentBlendModes":
        function?.pointee = unsafeBitCast(xrEnumerateEnvironmentBlendModes as PFN_xrEnumerateEnvironmentBlendModes,
                                          to: UnsafeMutableRawPointer.self)
    case "xrDestroyAction":
        function?.pointee = unsafeBitCast(xrDestroyAction as PFN_xrDestroyAction,
                                          to: UnsafeMutableRawPointer.self)
    case "xrDestroyActionSet":
        function?.pointee = unsafeBitCast(xrDestroyActionSet as PFN_xrDestroyActionSet,
                                          to: UnsafeMutableRawPointer.self)
    case "xrDestroyInstance":
        function?.pointee = unsafeBitCast(xrDestroyInstance as PFN_xrDestroyInstance,
                                          to: UnsafeMutableRawPointer.self)
    case "xrDestroySession":
        function?.pointee = unsafeBitCast(xrDestroySession as PFN_xrDestroySession,
                                          to: UnsafeMutableRawPointer.self)
    case "xrDestroySpace":
        function?.pointee = unsafeBitCast(xrDestroySpace as PFN_xrDestroySpace,
                                          to: UnsafeMutableRawPointer.self)
    case "xrDestroySwapchain":
        function?.pointee = unsafeBitCast(xrDestroySwapchain as PFN_xrDestroySwapchain,
                                          to: UnsafeMutableRawPointer.self)
    case "xrEndFrame":
        function?.pointee = unsafeBitCast(xrEndFrame as PFN_xrEndFrame,
                                          to: UnsafeMutableRawPointer.self)
    case "xrEndSession":
        function?.pointee = unsafeBitCast(xrEndSession as PFN_xrEndSession,
                                          to: UnsafeMutableRawPointer.self)
    case "xrEnumerateReferenceSpaces":
        function?.pointee = unsafeBitCast(xrEnumerateReferenceSpaces as PFN_xrEnumerateReferenceSpaces,
                                          to: UnsafeMutableRawPointer.self)
    case "xrEnumerateSwapchainFormats":
        function?.pointee = unsafeBitCast(xrEnumerateSwapchainFormats as PFN_xrEnumerateSwapchainFormats,
                                          to: UnsafeMutableRawPointer.self)
    case "xrEnumerateViewConfigurations":
        function?.pointee = unsafeBitCast(xrEnumerateViewConfigurations as PFN_xrEnumerateViewConfigurations,
                                          to: UnsafeMutableRawPointer.self)
    case "xrEnumerateViewConfigurationViews":
        function?.pointee = unsafeBitCast(xrEnumerateViewConfigurationViews as PFN_xrEnumerateViewConfigurationViews,
                                          to: UnsafeMutableRawPointer.self)
    case "xrGetActionStateBoolean":
        function?.pointee = unsafeBitCast(xrGetActionStateBoolean as PFN_xrGetActionStateBoolean,
                                          to: UnsafeMutableRawPointer.self)
    case "xrGetActionStateFloat":
        function?.pointee = unsafeBitCast(xrGetActionStateFloat as PFN_xrGetActionStateFloat,
                                          to: UnsafeMutableRawPointer.self)
    case "xrGetActionStateVector2f":
        function?.pointee = unsafeBitCast(xrGetActionStateVector2f as PFN_xrGetActionStateVector2f,
                                          to: UnsafeMutableRawPointer.self)
    case "xrGetCurrentInteractionProfile":
        function?.pointee = unsafeBitCast(xrGetCurrentInteractionProfile as PFN_xrGetCurrentInteractionProfile,
                                          to: UnsafeMutableRawPointer.self)
    case "xrGetReferenceSpaceBoundsRect":
        function?.pointee = unsafeBitCast(xrGetReferenceSpaceBoundsRect as PFN_xrGetReferenceSpaceBoundsRect,
                                          to: UnsafeMutableRawPointer.self)
    case "xrGetSystem":
        function?.pointee = unsafeBitCast(xrGetSystem as PFN_xrGetSystem,
                                          to: UnsafeMutableRawPointer.self)
    case "xrGetSystemProperties":
        function?.pointee = unsafeBitCast(xrGetSystemProperties as PFN_xrGetSystemProperties,
                                          to: UnsafeMutableRawPointer.self)
    case "xrLocateViews":
        function?.pointee = unsafeBitCast(xrLocateViews as PFN_xrLocateViews,
                                          to: UnsafeMutableRawPointer.self)
    case "xrLocateSpace":
        function?.pointee = unsafeBitCast(xrLocateSpace as PFN_xrLocateSpace,
                                          to: UnsafeMutableRawPointer.self)
    case "xrPathToString":
        function?.pointee = unsafeBitCast(xrPathToString as PFN_xrPathToString,
                                          to: UnsafeMutableRawPointer.self)
    case "xrPollEvent":
        function?.pointee = unsafeBitCast(xrPollEvent as PFN_xrPollEvent,
                                          to: UnsafeMutableRawPointer.self)
    case "xrReleaseSwapchainImage":
        function?.pointee = unsafeBitCast(xrReleaseSwapchainImage as PFN_xrReleaseSwapchainImage,
                                          to: UnsafeMutableRawPointer.self)
    case "xrResultToString":
        function?.pointee = unsafeBitCast(xrResultToString as PFN_xrResultToString,
                                          to: UnsafeMutableRawPointer.self)
    case "xrStringToPath":
        function?.pointee = unsafeBitCast(xrStringToPath as PFN_xrStringToPath,
                                          to: UnsafeMutableRawPointer.self)
    case "xrSuggestInteractionProfileBindings":
        function?.pointee = unsafeBitCast(xrSuggestInteractionProfileBindings as PFN_xrSuggestInteractionProfileBindings,
                                          to: UnsafeMutableRawPointer.self)
    case "xrSyncActions":
        function?.pointee = unsafeBitCast(xrSyncActions as PFN_xrSyncActions,
                                          to: UnsafeMutableRawPointer.self)
    case "xrWaitFrame":
        function?.pointee = unsafeBitCast(xrWaitFrame as PFN_xrWaitFrame,
                                          to: UnsafeMutableRawPointer.self)
    case "xrWaitSwapchainImage":
        function?.pointee = unsafeBitCast(xrWaitSwapchainImage as PFN_xrWaitSwapchainImage,
                                          to: UnsafeMutableRawPointer.self)
    default:
        function?.pointee = nil
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    return XR_SUCCESS
}
// MARK: swift app stuff
struct MetalLayerConfiguration: CompositorLayerConfiguration {
    func makeConfiguration(capabilities: LayerRenderer.Capabilities,
                           configuration: inout LayerRenderer.Configuration)
    {
        let supportsFoveation = capabilities.supportsFoveation
        let supportedLayouts = capabilities.supportedLayouts(options: supportsFoveation ? [.foveationEnabled] : [])
        
        // The device supports the `dedicated` and `layered` layouts, and optionally `shared` when foveation is disabled
        // The simulator supports the `dedicated` and `shared` layouts.
        // However, since we use vertex amplification to implement shared rendering, it won't work on the simulator in this project.
        configuration.layout = supportedLayouts.contains(.layered) ? .layered : .dedicated
        print("layout: \(configuration.layout)")
        configuration.isFoveationEnabled = supportsFoveation
        print("supportsFoveation: \(supportsFoveation)")
        configuration.colorFormat = .rgba16Float
    }
}

public struct OpenXRScene: Scene {
    @State  var immersionStyle: (any ImmersionStyle) = FullImmersionStyle.full
    let onLayerRendererReceived: ((LayerRenderer) -> Void)?
    let onAppear: (() -> Void)?
    @Binding var setImmersiveSpace: Bool
    @Binding var isLoading: Bool
    
    public init(onLayerRendererReceived: ((LayerRenderer) -> Void)?, onAppear: (() -> Void)?, setImmersiveSpace: Binding<Bool>, isLoading: Binding<Bool>) {
        self.onLayerRendererReceived = onLayerRendererReceived
        self.onAppear = onAppear
        _setImmersiveSpace = setImmersiveSpace
        _isLoading = isLoading
    }
    
    public var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView($immersionStyle, $setImmersiveSpace, $isLoading)
                .frame(minWidth: 480, maxWidth: 480, minHeight: 200, maxHeight: 320)
                .onAppear {
                    onAppear?()
                }
        }
        .windowResizability(.contentSize)
        ImmersiveSpace(id: "OpenXR") {
            CompositorLayer(configuration: MetalLayerConfiguration()) { layerRenderer in
                onLayerRendererReceived?(layerRenderer)
                globalLayerRenderer = layerRenderer
            }
        }
        .immersionStyle(selection: $immersionStyle, in: .mixed, .full)
    }
}

struct ContentView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.dismiss) private var dismiss

    @Binding private var immersionStyle: any ImmersionStyle
    @Binding var showImmersiveSpace: Bool
    
//    @State private var useMixedImmersion = false
//    @State private var passthroughCutoffAngle = 60.0
    @Binding var isLoading: Bool

    init(_ immersionStyle: Binding<any ImmersionStyle>, _ showImmersiveSpace: Binding<Bool>, _ isLoading: Binding<Bool>) {
        _immersionStyle = immersionStyle
        _showImmersiveSpace = showImmersiveSpace
        _isLoading = isLoading
    }

    var body: some View {
        VStack {
            if isLoading {
                Image("SplashImage")
            }
        }
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                print("showImmersiveSpace", newValue)
                if newValue {
                    await openImmersiveSpace(id: "OpenXR")
                } else {
                    await dismissImmersiveSpace()
                }
            }
        }
//        .onChange(of: useMixedImmersion) { _, _ in
//            immersionStyle = useMixedImmersion ? .mixed : .full
//        }
//        .onChange(of: passthroughCutoffAngle) { _, _ in
//            // Adjust renderer configuration if needed.
//        }
        .onChange(of: isLoading) { _, newValue in
            if !newValue {
                dismiss()
            }
        }
    }
}

var globalLayerRenderer: LayerRenderer? = nil

// MARK: openxr impl
struct Instance {
    var eventQueue: [Event] = []
    var session: UnsafeMutablePointer<Session>? // just one session for now (mutable pointer cause
    let metalDevice: MTLDevice = MTLCreateSystemDefaultDevice()!
    
    mutating func enqueueEvent(_ event: Event) {
        eventQueue.append(event)
    }
    
    mutating func dequeueEvent() -> Event? {
        if eventQueue.isEmpty {
            return nil
        }
        return eventQueue.removeFirst()
    }
}

enum Event {
    case sessionStateChanged(state: XrSessionState)

    func fillEventDataBuffer(_ oxrr: Instance,  _ buffer: inout XrEventDataBuffer) {
        switch self {
        case .sessionStateChanged(let state):
            buffer.type = XR_TYPE_EVENT_DATA_SESSION_STATE_CHANGED
            
            print("new state: \(state)")
            withUnsafeMutablePointer(to: &buffer) { ptr in
                let sessionStateChangedPtr = UnsafeMutableRawPointer(ptr)
                    .assumingMemoryBound(to: XrEventDataSessionStateChanged.self)
                sessionStateChangedPtr.pointee.type = XR_TYPE_EVENT_DATA_SESSION_STATE_CHANGED
                sessionStateChangedPtr.pointee.session = OpaquePointer(oxrr.session)
                sessionStateChangedPtr.pointee.state = state
                sessionStateChangedPtr.pointee.time = Int64(Date().timeIntervalSince1970)
            }
        }
    }
}

struct Session {
    let metalDevice: MTLDevice
    let arSession: ARKitSession
    var worldTrackingProvider: WorldTrackingProvider
    var commandQueue : MTLCommandQueue
    
    var currentFrame: LayerRenderer.Frame?
    var swapchain: Swapchain?
}

class Swapchain {
    var textures: [MTLTexture]
    
    init(textures: [MTLTexture]) {
        self.textures = textures
    }
}

extension simd_float4x4 {
    var translation: simd_float3 {
        return simd_float3(columns.3.x, columns.3.y, columns.3.z)
    }
    
    var orientation: simd_quatf {
        return simd_quaternion(self)
    }
}
@_cdecl("xrCreateInstance")
public func xrCreateInstance(_ createInfo: UnsafePointer<XrInstanceCreateInfo>?,
                             _ instance: UnsafeMutablePointer<XrInstance>?) -> XrResult {
    print("xrCreateInstance called")
    guard let instanceOut = instance else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    let myInstancePtr = UnsafeMutablePointer<Instance>.allocate(capacity: 1)
    myInstancePtr.initialize(to: Instance())
    instanceOut.pointee = OpaquePointer(myInstancePtr)
    return XR_SUCCESS
}

@_cdecl("xrCreateSession")
public func xrCreateSession(_ instance: XrInstance,
                            _ createInfo: UnsafePointer<XrSessionCreateInfo>?,
                            _ session: UnsafeMutablePointer<XrSession>?) -> XrResult {
    print("xrCreateSession called")
    guard let sessionOut = session else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    guard WorldTrackingProvider.isSupported else {
        print("World tracking no work")
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    let inst_ptr = unsafeBitCast(instance, to: UnsafeMutablePointer<Instance>.self)
    var inst = inst_ptr.pointee
    
    if inst.session != nil { // only support one session at the moment
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    inst.session = UnsafeMutablePointer<Session>.allocate(capacity: 1)
    inst.session!.initialize(to: Session(metalDevice: inst.metalDevice, arSession: ARKitSession(), worldTrackingProvider: WorldTrackingProvider(), commandQueue: inst.metalDevice.makeCommandQueue()!))
    
    let session = inst.session?.pointee
    
    inst.enqueueEvent(Event.sessionStateChanged(state:XR_SESSION_STATE_READY))
    inst_ptr.pointee = inst
    
    inst.session?.pointee = session!
    sessionOut.pointee = OpaquePointer(inst.session!)
    return XR_SUCCESS
}

func printDeviceAnchorState(_ anchor: DeviceAnchor) {
    print("Device Anchor State:")
    print("ID: \(anchor.id)")
    print("Description: \(anchor.description)")
    print("Tracking State: \(anchor.trackingState)")
    print("Is Tracked: \(anchor.isTracked)")
    
    let transform = anchor.originFromAnchorTransform
    let translation = transform.translation
    let orientation = transform.orientation
    
    print("Origin From Anchor Transform:")
    print("  Translation: \(translation)")
    print("  Orientation: \(orientation)")
}

// basic sequence of events seem to be:
//xrBeginSession called
//xrCreateReferenceSpace called
//xrCreateSwapchain called
//requested number of textures 1
//xrEnumerateSwapchainImages called
//xrEnumerateSwapchainImages called

// then in a loop          => could be
//xrWaitFrame              => LayerRenderer.Clock.wait(timing)
//xrLocateViews            => getdeviceAnchor + queryNextFrame->view matrix
//xrBeginFrame
//xrAcquireSwapchainImage  => return frame index we got in xrLocateViews
//xrWaitSwapchainImage     => nop
//xrReleaseSwapchainImage  => nop
//xrEndFrame               => submit frame; timing = frame.predictTiming()

@_cdecl("xrLocateViews")
public func xrLocateViews(_ session: XrSession,
                          _ viewLocateInfo: UnsafePointer<XrViewLocateInfo>?,
                          _ viewState: UnsafeMutablePointer<XrViewState>?,
                          _ viewCapacityInput: UInt32,
                          _ viewCountOutput: UnsafeMutablePointer<UInt32>?,
                          _ views: UnsafeMutablePointer<XrView>?) -> XrResult {
    print("xrLocateViews called")
    
    let sess_ptr = unsafeBitCast(session, to: UnsafeMutablePointer<Session>.self)
    var sess = sess_ptr.pointee
    
    // maybe this should be in beginframe?
    let semaphore = DispatchSemaphore(value: 0)
    Task {
        do {
            let dataProviders: [DataProvider] = [sess.worldTrackingProvider]
            try await sess.arSession.run(dataProviders)
        } catch {
            fatalError("Failed to run ARSession")
        }
        semaphore.signal()
    }
    
    semaphore.wait()
    
    let timestamp = Date().timeIntervalSince1970
    guard let deviceAnchor = sess.worldTrackingProvider.queryDeviceAnchor(atTimestamp: timestamp) else {
        print("No device anchor available")
        return XR_ERROR_RUNTIME_FAILURE
    }
    if !deviceAnchor.isTracked {
        print("Device anchor is not tracked")
        return XR_ERROR_RUNTIME_FAILURE
    }
    // printDeviceAnchorState(deviceAnchor)
    
    var frame : LayerRenderer.Frame?
    if sess.currentFrame != nil {
        frame = sess.currentFrame
    } else {
        frame = globalLayerRenderer!.queryNextFrame()
        sess.currentFrame = frame
    }
    let drawable = frame!.queryDrawable()!
    drawable.deviceAnchor = deviceAnchor
    
    let viewCount = drawable.views.count
    viewCountOutput?.pointee = UInt32(viewCount)

    if let viewState = viewState {
        viewState.pointee.type = XR_TYPE_VIEW_STATE
        viewState.pointee.next = nil
        viewState.pointee.viewStateFlags = XR_VIEW_STATE_POSITION_VALID_BIT | XR_VIEW_STATE_ORIENTATION_VALID_BIT
    }

    if viewCapacityInput < viewCount {
        print("xrLocateViews not enough input capacity: required \(viewCount), got \(viewCapacityInput)")
        return XR_SUCCESS
    }

    if let views = views {
        for i in 0..<viewCount {
            // Get the local transform for this view.
            let localMatrix = drawable.views[i].transform
            // Compute the world transform by applying the device anchor.
            let worldMatrix = (deviceAnchor.originFromAnchorTransform * localMatrix).inverse
            let translation = worldMatrix.translation
            let orientation = worldMatrix.orientation

            // Populate the view structure for this index.
            views[i].type = XR_TYPE_VIEW
            views[i].next = nil
            views[i].pose.position.x = translation.x
            views[i].pose.position.y = translation.y
            views[i].pose.position.z = translation.z
            views[i].pose.orientation.x = orientation.vector.x
            views[i].pose.orientation.y = orientation.vector.y
            views[i].pose.orientation.z = orientation.vector.z
            views[i].pose.orientation.w = orientation.vector.w

            // i think these need to be calculated from the computeprojection call given a view
            // but aspect ratio and clipping planes are missing when reducing the projection matrix to fovs https://developer.apple.com/documentation/compositorservices/layerrenderer/drawable/computeprojection(convention:viewindex:)
            views[i].fov.angleLeft  = -0.5
            views[i].fov.angleRight =  0.5
            views[i].fov.angleUp    =  0.5
            views[i].fov.angleDown  = -0.5
        }
    }
    sess_ptr.pointee = sess
    return XR_SUCCESS
}

@_cdecl("xrBeginFrame")
public func xrBeginFrame(_ session: XrSession,
                         _ frameBeginInfo: UnsafePointer<XrFrameBeginInfo>?) -> XrResult {
    print("xrBeginFrame called")
    
    let sess_ptr = unsafeBitCast(session, to: UnsafeMutablePointer<Session>.self)
    var sess = sess_ptr.pointee
    
    sess.currentFrame!.startSubmission()
    return XR_SUCCESS
}
struct Vertex {
    var position: SIMD2<Float>
    var texCoord: SIMD2<Float>
}

func renderSwapchainTextureToDrawable(sess: Session) {
    // Ensure we have a valid drawable.
    guard let drawable = sess.currentFrame?.queryDrawable() else {
        fatalError("Drawable not available")
    }
    
    // Ensure device and command queue are available.
    let device = sess.metalDevice
    let commandQueue = sess.commandQueue
    
    // Create a full-screen quad covering NDC (-1..1)
    let vertices: [Vertex] = [
        Vertex(position: SIMD2(-1,  1), texCoord: SIMD2(0, 0)),
        Vertex(position: SIMD2(-1, -1), texCoord: SIMD2(0, 1)),
        Vertex(position: SIMD2( 1, -1), texCoord: SIMD2(1, 1)),
        
        Vertex(position: SIMD2(-1,  1), texCoord: SIMD2(0, 0)),
        Vertex(position: SIMD2( 1, -1), texCoord: SIMD2(1, 1)),
        Vertex(position: SIMD2( 1,  1), texCoord: SIMD2(1, 0))
    ]
    
    // Create a vertex buffer.
    guard let vertexBuffer = device.makeBuffer(bytes: vertices,
                                               length: MemoryLayout<Vertex>.stride * vertices.count,
                                               options: []) else {
        fatalError("Could not create vertex buffer")
    }
    
    var library: MTLLibrary?
    // Embedded shader source to compile at runtime.
    let shaderSource = """
    #include <metal_stdlib>
    using namespace metal;
    
    struct Vertex {
        float2 position [[attribute(0)]];
        float2 texCoord [[attribute(1)]];
    };
    
    struct VertexOut {
        float4 position [[position]];
        float2 texCoord;
    };
    
    vertex VertexOut vertexShader(uint vertexID [[vertex_id]],
                                  const device Vertex* vertices [[buffer(0)]]) {
        VertexOut out;
        out.position = float4(vertices[vertexID].position, 0.0, 1.0);
        out.texCoord = vertices[vertexID].texCoord;
        return out;
    }
    
    fragment float4 fragmentShader(VertexOut in [[stage_in]],
                                   texture2d<float> colorTexture [[texture(0)]],
                                   sampler samplr [[sampler(0)]]) {
        return colorTexture.sample(samplr, in.texCoord);
    }
    """
    do {
        library = try device.makeLibrary(source: shaderSource, options: nil)
    } catch {
        fatalError("Failed to create library from source: \(error)")
    }
    
    // Get the vertex and fragment functions.
    guard let vertexFunction = library!.makeFunction(name: "vertexShader"),
          let fragmentFunction = library!.makeFunction(name: "fragmentShader") else {
        fatalError("Could not load shader functions")
    }
    
    // Set up the render pipeline.
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    // colorattachments is given the output pixel format
    pipelineDescriptor.colorAttachments[0].pixelFormat = drawable.colorTextures[0].pixelFormat
    
    let pipelineState: MTLRenderPipelineState
    do {
        pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    } catch {
        fatalError("Failed to create pipeline state: \(error)")
    }
    
    // Create a command buffer.
    guard let commandBuffer = commandQueue.makeCommandBuffer() else {
        fatalError("Could not create command buffer")
    }
    // Create a render pass descriptor targeting the drawable's texture.
    let renderPassDescriptor = MTLRenderPassDescriptor()
    // renderpassdescriptor is given the output texture
    renderPassDescriptor.colorAttachments[0].texture = drawable.colorTextures[0]
    renderPassDescriptor.colorAttachments[0].loadAction = .clear
    renderPassDescriptor.colorAttachments[0].storeAction = .store
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1)
    
    // Create a render encoder.
    guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
        fatalError("Could not create render encoder")
    }
    // convert our swapchain texture to a type2d
    guard let singleTexture = sess.swapchain!.textures[0].__newTextureView(with: sess.swapchain!.textures[0].pixelFormat,
                                                                            textureType: .type2D,
                                                                            levels: NSRange(location: 0, length: 1),
                                                                            slices: NSRange(location: 0, length: 1))
    else {
        fatalError("Failed to create texture view")
    }
    
    // Set pipeline state, vertex buffer, and bind the swapchain texture.
    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    // fragment texture is given the swapchain texture (the input i guess)
    renderEncoder.setFragmentTexture(singleTexture, index: 0)
    
    // setup a texture sampler for when in and out are different sizes?
    let samplerDescriptor = MTLSamplerDescriptor()
    samplerDescriptor.minFilter = .linear
    samplerDescriptor.magFilter = .linear
    samplerDescriptor.sAddressMode = .clampToEdge
    samplerDescriptor.tAddressMode = .clampToEdge

    guard let samplerState = device.makeSamplerState(descriptor: samplerDescriptor) else {
        fatalError("Failed to create sampler state")
    }

    renderEncoder.setFragmentSamplerState(samplerState, index: 0)
    
    // do it command
    renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
    
    renderEncoder.endEncoding()
    
    // submit and present?
    drawable.encodePresent(commandBuffer: commandBuffer)
    commandBuffer.commit()
}

@_cdecl("xrEndFrame")
public func xrEndFrame(_ session: XrSession,
                       _ frameEndInfo: UnsafePointer<XrFrameEndInfo>?) -> XrResult {
    print("xrEndFrame called")
    
    let sess_ptr = unsafeBitCast(session, to: UnsafeMutablePointer<Session>.self)
    var sess = sess_ptr.pointee
    
    guard let info = frameEndInfo?.pointee else {
        print("No frame end info provided")
        return XR_SUCCESS
    }
    
    renderSwapchainTextureToDrawable(sess: sess)
    
    sess.currentFrame!.endSubmission()
    sess.currentFrame = nil
    
    sess_ptr.pointee = sess
    
    // here we need to submit everything
    
//    XR_DEFINE_HANDLE(XrSpace)
    
//    typedef XrFlags64 XrCompositionLayerFlags;
//
//    // Flag bits for XrCompositionLayerFlags
//    static const XrCompositionLayerFlags XR_COMPOSITION_LAYER_CORRECT_CHROMATIC_ABERRATION_BIT = 0x00000001;
//    static const XrCompositionLayerFlags XR_COMPOSITION_LAYER_BLEND_TEXTURE_SOURCE_ALPHA_BIT = 0x00000002;
//    static const XrCompositionLayerFlags XR_COMPOSITION_LAYER_UNPREMULTIPLIED_ALPHA_BIT = 0x00000004;
//    static const XrCompositionLayerFlags XR_COMPOSITION_LAYER_INVERTED_ALPHA_BIT_EXT = 0x00000008;
    
//    typedef struct XR_MAY_ALIAS XrCompositionLayerBaseHeader {
//        XrStructureType             type;
//        const void* XR_MAY_ALIAS    next;
//        XrCompositionLayerFlags     layerFlags;
//        XrSpace                     space;
//    } XrCompositionLayerBaseHeader;
//
//    typedef struct XrFrameEndInfo {
//        XrStructureType                               type;
//        const void* XR_MAY_ALIAS                      next;
//        XrTime                                        displayTime;
//        XrEnvironmentBlendMode                        environmentBlendMode;
//        uint32_t                                      layerCount;
//        const XrCompositionLayerBaseHeader* const*    layers;
//    } XrFrameEndInfo;
    
//    print("Frame display time: \(info.displayTime)")
//    print("Environment blend mode: \(info.environmentBlendMode)")
//    print("Layer count: \(info.layerCount)")
//
//    if info.layerCount > 0, let layersPtr = info.layers {
//        let layersBuffer = UnsafeBufferPointer(start: layersPtr, count: Int(info.layerCount))
//        for (i, layerHeaderOpt) in layersBuffer.enumerated() {
//            if let layerHeaderPtr = layerHeaderOpt {
//                let layerHeader = layerHeaderPtr.pointee
//                print("Layer \(i):")
//                print("  Type: \(layerHeader.type)")
//                print("  Next: \(String(describing: layerHeader.next))")
//                print("  Layer flags: \(layerHeader.layerFlags)")
//                print("  Space: \(layerHeader.space)")
//            } else {
//                print("Layer \(i) is nil")
//            }
//        }
//    } else {
//        print("No layers provided")
//    }
    
    return XR_SUCCESS
}
@_cdecl("xrEnumerateApiLayerProperties")
public func xrEnumerateApiLayerProperties(_ propertyCapacityInput: UInt32,
                                          _ propertyCountOutput: UnsafeMutablePointer<UInt32>?,
                                          _ properties: UnsafeMutablePointer<XrApiLayerProperties>?) -> XrResult {
    propertyCountOutput?.pointee = 0
    return XR_SUCCESS
}

@_cdecl("xrEnumerateInstanceExtensionProperties")
public func xrEnumerateInstanceExtensionProperties(_ layerName: UnsafePointer<CChar>?,
                                                   _ propertyCapacityInput: UInt32,
                                                   _ propertyCountOutput: UnsafeMutablePointer<UInt32>?,
                                                   _ properties: UnsafeMutablePointer<XrExtensionProperties>?) -> XrResult {
    propertyCountOutput?.pointee = 1
    if propertyCapacityInput < 1 {
        return XR_SUCCESS
    }
    if let properties = properties {
        properties.pointee.type = XR_TYPE_EXTENSION_PROPERTIES
        withUnsafeMutablePointer(to: &properties.pointee.extensionName) { ptr in
            ptr.withMemoryRebound(to: CChar.self, capacity: MemoryLayout.size(ofValue: properties.pointee.extensionName)) { cPtr in
                strncpy(cPtr, "XR_KHR_metal_enable", MemoryLayout.size(ofValue: properties.pointee.extensionName))
            }
        }
        properties.pointee.extensionVersion = 1
    }
    return XR_SUCCESS
}

@_cdecl("xrGetInstanceProperties")
public func xrGetInstanceProperties(_ instance: XrInstance,
                                    _ instanceProperties: UnsafeMutablePointer<XrInstanceProperties>?) -> XrResult {
    guard let instanceProperties = instanceProperties else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    instanceProperties.pointee.type = XR_TYPE_INSTANCE_PROPERTIES
    instanceProperties.pointee.next = nil
    withUnsafeMutablePointer(to: &instanceProperties.pointee.runtimeName) { ptr in
        ptr.withMemoryRebound(to: CChar.self, capacity: MemoryLayout.size(ofValue: instanceProperties.pointee.runtimeName)) { cPtr in
            strncpy(cPtr, "VisionOS OpenXR", MemoryLayout.size(ofValue: instanceProperties.pointee.runtimeName))
        }
    }
    instanceProperties.pointee.runtimeVersion = 1
    return XR_SUCCESS
}

@_cdecl("xrGetMetalGraphicsRequirementsKHR")
public func xrGetMetalGraphicsRequirementsKHR(_ instance: XrInstance,
                                              _ systemId: XrSystemId,
                                              _ metalRequirements: UnsafeMutablePointer<XrGraphicsRequirementsMetalKHR>?) -> XrResult {
    guard let metalRequirements = metalRequirements else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    let inst_ptr = unsafeBitCast(instance, to: UnsafeMutablePointer<Instance>.self)
    let inst = inst_ptr.pointee
    
    metalRequirements.pointee.type = XR_TYPE_GRAPHICS_REQUIREMENTS_METAL_KHR
    metalRequirements.pointee.next = nil
    
    metalRequirements.pointee.metalDevice = Unmanaged.passUnretained(inst.metalDevice).toOpaque()
    
    return XR_SUCCESS
}

@_cdecl("xrApplyHapticFeedback")
public func xrApplyHapticFeedback(_ session: XrSession,
                                  _ hapticActionInfo: UnsafePointer<XrHapticActionInfo>?,
                                  _ hapticFeedback: UnsafePointer<XrHapticBaseHeader>?) -> XrResult {
    return XR_SUCCESS
}

@_cdecl("xrAttachSessionActionSets")
public func xrAttachSessionActionSets(_ session: XrSession,
                                      _ attachInfo: UnsafePointer<XrSessionActionSetsAttachInfo>?) -> XrResult {
    print("xrAttachSessionActionSets called")
    return XR_SUCCESS
}

@_cdecl("xrBeginSession")
public func xrBeginSession(_ session: XrSession,
                           _ beginInfo: UnsafePointer<XrSessionBeginInfo>?) -> XrResult {
    print("xrBeginSession called")
    return XR_SUCCESS
}

@_cdecl("xrCreateAction")
public func xrCreateAction(_ actionSet: XrActionSet,
                           _ createInfo: UnsafePointer<XrActionCreateInfo>?,
                           _ action: UnsafeMutablePointer<XrAction>?) -> XrResult {
    print("xrCreateAction called")
    guard let actionOut = action else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    let dummyActionPtr = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<Int>.size,
                                                          alignment: MemoryLayout<Int>.alignment)
    dummyActionPtr.initializeMemory(as: Int.self, to: 42) // dummy value
    actionOut.pointee = OpaquePointer(dummyActionPtr)
    return XR_SUCCESS
}

@_cdecl("xrCreateActionSet")
public func xrCreateActionSet(_ instance: XrInstance,
                              _ createInfo: UnsafePointer<XrActionSetCreateInfo>?,
                              _ actionSet: UnsafeMutablePointer<XrActionSet>?) -> XrResult {
    print("xrCreateActionSet called")
    guard let actionSetOut = actionSet else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    let dummyActionSetPtr = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<Int>.size,
                                                             alignment: MemoryLayout<Int>.alignment)
    dummyActionSetPtr.initializeMemory(as: Int.self, to: 84) // dummy value for action set
    actionSetOut.pointee = OpaquePointer(dummyActionSetPtr)
    return XR_SUCCESS
}

@_cdecl("xrCreateActionSpace")
public func xrCreateActionSpace(_ session: XrSession,
                                _ createInfo: UnsafePointer<XrActionSpaceCreateInfo>?,
                                _ space: UnsafeMutablePointer<XrSpace>?) -> XrResult {
    print("xrCreateActionSpace called")
    guard let spaceOut = space else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    let dummySpacePtr = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<Int>.size,
                                                         alignment: MemoryLayout<Int>.alignment)
    dummySpacePtr.initializeMemory(as: Int.self, to: 128) // dummy value for action space
    spaceOut.pointee = OpaquePointer(dummySpacePtr)
    return XR_SUCCESS
}

@_cdecl("xrCreateReferenceSpace")
public func xrCreateReferenceSpace(_ session: XrSession,
                                   _ createInfo: UnsafePointer<XrReferenceSpaceCreateInfo>?,
                                   _ space: UnsafeMutablePointer<XrSpace>?) -> XrResult {
    print("xrCreateReferenceSpace called")
    guard let spaceOut = space else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    let dummySpacePtr = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<Int>.size,
                                                         alignment: MemoryLayout<Int>.alignment)
    dummySpacePtr.initializeMemory(as: Int.self, to: 256) // dummy value for reference space
    spaceOut.pointee = OpaquePointer(dummySpacePtr)
    return XR_SUCCESS
}

@_cdecl("xrEnumerateEnvironmentBlendModes")
public func xrEnumerateEnvironmentBlendModes(_ instance: XrInstance,
                                             _ systemId: XrSystemId,
                                             _ viewConfigurationType: XrViewConfigurationType,
                                             _ environmentBlendModeCapacityInput: UInt32,
                                             _ environmentBlendModeCountOutput: UnsafeMutablePointer<UInt32>?,
                                             _ environmentBlendModes: UnsafeMutablePointer<XrEnvironmentBlendMode>?) -> XrResult {
    environmentBlendModeCountOutput?.pointee = 1
    
    if environmentBlendModeCapacityInput < 1 {
        return XR_SUCCESS
    }
    
    if let environmentBlendModes = environmentBlendModes {
        environmentBlendModes.pointee = XR_ENVIRONMENT_BLEND_MODE_OPAQUE
    }
    return XR_SUCCESS
}

@_cdecl("xrDestroyAction")
public func xrDestroyAction(_ action: XrAction) -> XrResult {
    print("xrDestroyAction called")
    let rawPtr = unsafeBitCast(action, to: UnsafeMutableRawPointer.self)
    rawPtr.deallocate()
    return XR_SUCCESS
}

@_cdecl("xrDestroyActionSet")
public func xrDestroyActionSet(_ actionSet: XrActionSet) -> XrResult {
    print("xrDestroyActionSet called")
    let rawPtr = unsafeBitCast(actionSet, to: UnsafeMutableRawPointer.self)
    rawPtr.deallocate()
    return XR_SUCCESS
}

@_cdecl("xrDestroyInstance")
public func xrDestroyInstance(_ instance: XrInstance) -> XrResult {
    print("xrDestroyInstance called")
    let rawPtr = unsafeBitCast(instance, to: UnsafeMutableRawPointer.self)
    rawPtr.deallocate()
    return XR_SUCCESS
}

@_cdecl("xrDestroySession")
public func xrDestroySession(_ session: XrSession) -> XrResult {
    print("xrDestroySession called")
    let rawPtr = unsafeBitCast(session, to: UnsafeMutableRawPointer.self)
    rawPtr.deallocate()
    return XR_SUCCESS
}

@_cdecl("xrDestroySpace")
public func xrDestroySpace(_ space: XrSpace) -> XrResult {
    print("xrDestroySpace called")
    let rawPtr = unsafeBitCast(space, to: UnsafeMutableRawPointer.self)
    rawPtr.deallocate()
    return XR_SUCCESS
}

@_cdecl("xrEndSession")
public func xrEndSession(_ session: XrSession) -> XrResult {
    print("xrEndSession called")
    return XR_SUCCESS
}

@_cdecl("xrEnumerateReferenceSpaces")
public func xrEnumerateReferenceSpaces(_ session: XrSession,
                                         _ referenceSpaceTypeCapacityInput: UInt32,
                                         _ referenceSpaceTypeCountOutput: UnsafeMutablePointer<UInt32>?,
                                         _ referenceSpaceTypes: UnsafeMutablePointer<XrReferenceSpaceType>?) -> XrResult {
    print("xrEnumerateReferenceSpaces called")
    let availableReferenceSpaces: [XrReferenceSpaceType] = [
        XR_REFERENCE_SPACE_TYPE_STAGE,
        XR_REFERENCE_SPACE_TYPE_LOCAL,
        XR_REFERENCE_SPACE_TYPE_VIEW
    ]
    referenceSpaceTypeCountOutput?.pointee = UInt32(availableReferenceSpaces.count)
    if referenceSpaceTypeCapacityInput < availableReferenceSpaces.count {
        return XR_SUCCESS
    }
    if let referenceSpaceTypes = referenceSpaceTypes {
        referenceSpaceTypes.update(from: availableReferenceSpaces, count: availableReferenceSpaces.count)
    }
    return XR_SUCCESS
}

@_cdecl("xrEnumerateViewConfigurations")
public func xrEnumerateViewConfigurations(_ instance: XrInstance,
                                          _ systemId: XrSystemId,
                                          _ viewConfigurationTypeCapacityInput: UInt32,
                                          _ viewConfigurationTypeCountOutput: UnsafeMutablePointer<UInt32>?,
                                          _ viewConfigurationTypes: UnsafeMutablePointer<XrViewConfigurationType>?) -> XrResult {
    viewConfigurationTypeCountOutput?.pointee = 1
    if viewConfigurationTypeCapacityInput < 1 {
        return XR_SUCCESS
    }
    if let viewConfigurationTypes = viewConfigurationTypes {
        viewConfigurationTypes.pointee = XR_VIEW_CONFIGURATION_TYPE_PRIMARY_MONO
    }
    return XR_SUCCESS
}

@_cdecl("xrEnumerateViewConfigurationViews")
public func xrEnumerateViewConfigurationViews(_ instance: XrInstance,
                                              _ systemId: XrSystemId,
                                              _ viewConfigurationType: XrViewConfigurationType,
                                              _ viewCapacityInput: UInt32,
                                              _ viewCountOutput: UnsafeMutablePointer<UInt32>?,
                                              _ views: UnsafeMutablePointer<XrViewConfigurationView>?) -> XrResult {
    viewCountOutput?.pointee = 1
    if viewCapacityInput < 1 {
        return XR_SUCCESS
    }
    if let views = views {
        views.pointee.type = XR_TYPE_VIEW_CONFIGURATION_VIEW
        views.pointee.next = nil
        views.pointee.recommendedImageRectWidth = 1024
        views.pointee.recommendedImageRectHeight = 768
        views.pointee.recommendedSwapchainSampleCount = 4
    }
    return XR_SUCCESS
}

@_cdecl("xrGetActionStateBoolean")
public func xrGetActionStateBoolean(_ session: XrSession,
                                    _ getInfo: UnsafePointer<XrActionStateGetInfo>?,
                                    _ state: UnsafeMutablePointer<XrActionStateBoolean>?) -> XrResult {
    guard let state = state else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    state.pointee.type = XR_TYPE_ACTION_STATE_BOOLEAN
    state.pointee.next = nil
    state.pointee.currentState = 0  // false
    state.pointee.changedSinceLastSync = 0
    return XR_SUCCESS
}

@_cdecl("xrGetActionStateFloat")
public func xrGetActionStateFloat(_ session: XrSession,
                                  _ getInfo: UnsafePointer<XrActionStateGetInfo>?,
                                  _ state: UnsafeMutablePointer<XrActionStateFloat>?) -> XrResult {
    guard let state = state else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    state.pointee.type = XR_TYPE_ACTION_STATE_FLOAT
    state.pointee.next = nil
    state.pointee.currentState = 0.0
    state.pointee.changedSinceLastSync = 0 // false
    return XR_SUCCESS
}

@_cdecl("xrGetActionStateVector2f")
public func xrGetActionStateVector2f(_ session: XrSession,
                                     _ getInfo: UnsafePointer<XrActionStateGetInfo>?,
                                     _ state: UnsafeMutablePointer<XrActionStateVector2f>?) -> XrResult {
    guard let state = state else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    state.pointee.type = XR_TYPE_ACTION_STATE_VECTOR2F
    state.pointee.next = nil
    state.pointee.currentState.x = 0.0
    state.pointee.currentState.y = 0.0
    state.pointee.changedSinceLastSync = 0
    return XR_SUCCESS
}

@_cdecl("xrGetCurrentInteractionProfile")
public func xrGetCurrentInteractionProfile(_ session: XrSession,
                                           _ topLevelUserPath: XrPath,
                                           _ interactionProfile: UnsafeMutablePointer<XrInteractionProfileState>?) -> XrResult {
    guard let interactionProfile = interactionProfile else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    interactionProfile.pointee.type = XR_TYPE_INTERACTION_PROFILE_STATE
    interactionProfile.pointee.next = nil
    interactionProfile.pointee.interactionProfile = 0
    return XR_SUCCESS
}

@_cdecl("xrGetReferenceSpaceBoundsRect")
public func xrGetReferenceSpaceBoundsRect(_ session: XrSession,
                                          _ referenceSpaceType: XrReferenceSpaceType,
                                          _ bounds: UnsafeMutablePointer<XrExtent2Df>?) -> XrResult {
    if referenceSpaceType == XR_REFERENCE_SPACE_TYPE_STAGE {
        if let bounds = bounds {
            bounds.pointee.width = 2.0
            bounds.pointee.height = 2.0
        }
    } else {
        if let bounds = bounds {
            bounds.pointee.width = 0.0
            bounds.pointee.height = 0.0
        }
    }
    return XR_SUCCESS
}

@_cdecl("xrGetSystem")
public func xrGetSystem(_ instance: XrInstance,
                        _ getInfo: UnsafePointer<XrSystemGetInfo>?,
                        _ systemId: UnsafeMutablePointer<XrSystemId>?) -> XrResult {
    guard let systemId = systemId else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    systemId.pointee = 1
    return XR_SUCCESS
}

@_cdecl("xrGetSystemProperties")
public func xrGetSystemProperties(_ instance: XrInstance,
                                  _ systemId: XrSystemId,
                                  _ properties: UnsafeMutablePointer<XrSystemProperties>?) -> XrResult {
    guard let properties = properties else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    properties.pointee.type = XR_TYPE_SYSTEM_PROPERTIES
    properties.pointee.next = nil
    properties.pointee.systemId = systemId
    properties.pointee.vendorId = 0  // Dummy vendor ID
    
    withUnsafeMutablePointer(to: &properties.pointee.systemName) { ptr in
        ptr.withMemoryRebound(to: CChar.self, capacity: MemoryLayout.size(ofValue: properties.pointee.systemName)) { cPtr in
            strncpy(cPtr, "TODO", MemoryLayout.size(ofValue: properties.pointee.systemName))
        }
    }
    
    return XR_SUCCESS
}

@_cdecl("xrLocateSpace")
public func xrLocateSpace(_ space: XrSpace,
                          _ baseSpace: XrSpace,
                          _ time: XrTime,
                          _ location: UnsafeMutablePointer<XrSpaceLocation>?) -> XrResult {
    guard let location = location else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    location.pointee.type = XR_TYPE_SPACE_LOCATION
    location.pointee.next = nil
    
    location.pointee.pose.orientation.x = 0.0
    location.pointee.pose.orientation.y = 0.0
    location.pointee.pose.orientation.z = 0.0
    location.pointee.pose.orientation.w = 1.0
    location.pointee.pose.position.x = 0.0
    location.pointee.pose.position.y = 0.0
    location.pointee.pose.position.z = 0.0
    
    location.pointee.locationFlags = XR_SPACE_LOCATION_POSITION_VALID_BIT | XR_SPACE_LOCATION_ORIENTATION_VALID_BIT
    return XR_SUCCESS
}

@_cdecl("xrPathToString")
public func xrPathToString(_ instance: XrInstance,
                           _ path: XrPath,
                           _ bufferCapacityInput: UInt32,
                           _ bufferCountOutput: UnsafeMutablePointer<UInt32>?,
                           _ buffer: UnsafeMutablePointer<CChar>?) -> XrResult {
    let dummyPathString = "dummy_path"
    let requiredSize = UInt32(dummyPathString.utf8.count + 1)
    
    bufferCountOutput?.pointee = requiredSize
    
    if bufferCapacityInput >= requiredSize, let buffer = buffer {
        dummyPathString.withCString { src in
            strncpy(buffer, src, Int(bufferCapacityInput))
        }
    }
    
    return XR_SUCCESS
}

@_cdecl("xrPollEvent")
public func xrPollEvent(_ instance: XrInstance,
                        _ eventDataBuffer: UnsafeMutablePointer<XrEventDataBuffer>?) -> XrResult {
//    print("xrPollEvent called")
    let inst_ptr = unsafeBitCast(instance, to: UnsafeMutablePointer<Instance>.self)
    var inst = inst_ptr.pointee
    
    if let event = inst.dequeueEvent() {
        print("xrPollEvent passing event")
        if var buffer = eventDataBuffer?.pointee {
            event.fillEventDataBuffer(inst, &buffer)
            eventDataBuffer?.pointee = buffer
        }
        inst_ptr.pointee = inst
        return XR_SUCCESS
    }
    
    inst_ptr.pointee = inst
    
    eventDataBuffer?.pointee.type = XrStructureType(0)
    return XR_EVENT_UNAVAILABLE
}


// MARK: swapchains

@_cdecl("xrEnumerateSwapchainFormats")
public func xrEnumerateSwapchainFormats(_ session: XrSession,
                                        _ formatCapacityInput: UInt32,
                                        _ formatCountOutput: UnsafeMutablePointer<UInt32>?,
                                        _ formats: UnsafeMutablePointer<Int64>?) -> XrResult {
    print("xrEnumerateSwapchainFormats called")
    let availableFormats: [Int64] = [
        Int64(MTLPixelFormat.rgba16Float.rawValue),
        Int64(MTLPixelFormat.depth32Float_stencil8.rawValue),
        Int64(MTLPixelFormat.depth32Float.rawValue),
    ]
    formatCountOutput?.pointee = UInt32(availableFormats.count)
    if formatCapacityInput < availableFormats.count {
        return XR_SUCCESS
    }
    if let formats = formats {
        formats.update(from: availableFormats, count: availableFormats.count)
    }
    return XR_SUCCESS
}

@_cdecl("xrCreateSwapchain")
public func xrCreateSwapchain(_ session: XrSession,
                              _ createInfo: UnsafePointer<XrSwapchainCreateInfo>?,
                              _ swapchain: UnsafeMutablePointer<XrSwapchain>?) -> XrResult {
    print("xrCreateSwapchain called")
    guard let swapchainOut = swapchain, let ci = createInfo?.pointee else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    let sess_ptr = unsafeBitCast(session, to: UnsafeMutablePointer<Session>.self)
    let sess = sess_ptr.pointee
    
    // here we're just allocating some MTLTexture manually cause thats the correct type. if it was done this way, in endframe you would copy over the texture data into the final texture.
    
    // I think the best way to support this is to get all the queryNextFrame()s, save their texture pointer so we can return an array of textures from enumerate, then release them all
    // then in acquire we call it again and return the index that corresponds to the one we got. hoping that the texture we get from queryNextFrame is always at an address that we enumerated at the beginning
    
    // currently godot only requests one so this could be simpler
    let textureCount = Int(ci.arraySize > 0 ? ci.arraySize : 3)
    print("requested number of textures \(ci.arraySize)")
    
    // we're not doing anything with this texture yet, just returning what i think the correct type is
    let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat(rawValue: UInt(ci.format))!,
                                                              width: Int(ci.width),
                                                              height: Int(ci.height),
                                                              mipmapped: false)
    descriptor.usage = [.renderTarget,
                        .shaderRead, // if we want this texture to get foveated rendering then the user has
                        // to support not reading from the texture, so removing this should work
                        .pixelFormatView]
    descriptor.textureType = .type2DArray
    
    
    var textures: [MTLTexture] = []
    for _ in 0..<textureCount {
        if let texture = sess.metalDevice.makeTexture(descriptor: descriptor) {
            textures.append(texture)
        }
    }
    
    let swapchain = Swapchain(textures: textures)
    sess_ptr.pointee.swapchain = swapchain
    swapchainOut.pointee = OpaquePointer(Unmanaged.passRetained(swapchain).toOpaque())
    return XR_SUCCESS
}

@_cdecl("xrEnumerateSwapchainImages")
public func xrEnumerateSwapchainImages(_ swapchain: XrSwapchain,
                                       _ imageCapacityInput: UInt32,
                                       _ imageCountOutput: UnsafeMutablePointer<UInt32>?,
                                       _ images: UnsafeMutablePointer<XrSwapchainImageMetalKHR>?) -> XrResult {
    print("xrEnumerateSwapchainImages called")
    
    let realitySwapchain = Unmanaged<Swapchain>.fromOpaque(UnsafeRawPointer(swapchain)).takeUnretainedValue()
    let availableTextures = realitySwapchain.textures
    let count = UInt32(availableTextures.count)
    
    imageCountOutput?.pointee = count
    
    if imageCapacityInput < count {
        return XR_SUCCESS
    }
    
    var metalImages: [XrSwapchainImageMetalKHR] = []
    for texture in availableTextures {
        let image = XrSwapchainImageMetalKHR(
            type: XR_TYPE_SWAPCHAIN_IMAGE_METAL_KHR,
            next: nil,
            texture: Unmanaged.passUnretained(texture).toOpaque()
        )
        metalImages.append(image)
    }
    
    if let images = images {
        images.update(from: metalImages, count: metalImages.count)
    }
    
    return XR_SUCCESS
}

@_cdecl("xrDestroySwapchain")
public func xrDestroySwapchain(_ swapchain: XrSwapchain) -> XrResult {
    print("xrDestroySwapchain called")
    
    return XR_SUCCESS
}


@_cdecl("xrAcquireSwapchainImage")
public func xrAcquireSwapchainImage(_ swapchain: XrSwapchain,
                                    _ acquireInfo: UnsafePointer<XrSwapchainImageAcquireInfo>?,
                                    _ index: UnsafeMutablePointer<UInt32>?) -> XrResult {
    print("xrAcquireSwapchainImage called")

    // an ask for a swapchain image, with output param index into ones allocated by enumerate,

    // godot metal extension does data->texture_rids[p_image_index]; where texture_rids has a reference to whatever is returned by enumerate
    index?.pointee = 0
    return XR_SUCCESS
}

@_cdecl("xrReleaseSwapchainImage")
public func xrReleaseSwapchainImage(_ swapchain: XrSwapchain,
                                    _ releaseInfo: UnsafePointer<XrSwapchainImageReleaseInfo>?) -> XrResult {
    print("xrReleaseSwapchainImage called")
    
    return XR_SUCCESS
}

@_cdecl("xrWaitSwapchainImage")
public func xrWaitSwapchainImage(_ swapchain: XrSwapchain,
                                 _ waitInfo: UnsafePointer<XrSwapchainImageWaitInfo>?) -> XrResult {
    print("xrWaitSwapchainImage called")
    // syncronisation for waiting until the user is allowed to render to the image
    return XR_SUCCESS
}

// MARK: other

@_cdecl("xrResultToString")
public func xrResultToString(_ instance: XrInstance,
                             _ result: XrResult,
                             _ buffer: UnsafeMutablePointer<CChar>?) -> XrResult {
    // Map known result codes to strings.
    let resultString: String
    switch result {
    case XR_SUCCESS:
        resultString = "XR_SUCCESS"
    case XR_ERROR_FUNCTION_UNSUPPORTED:
        resultString = "XR_ERROR_FUNCTION_UNSUPPORTED"
    default:
        resultString = "XR_UNKNOWN_RESULT"
    }
    
    let requiredSize = UInt32(resultString.utf8.count + 1)

    if XR_MAX_RESULT_STRING_SIZE >= requiredSize, let buffer = buffer {
        resultString.withCString { src in
            strncpy(buffer, src, Int(XR_MAX_RESULT_STRING_SIZE))
        }
    }
    
    return XR_SUCCESS
}

@_cdecl("xrStringToPath")
public func xrStringToPath(_ instance: XrInstance,
                           _ pathString: UnsafePointer<CChar>?,
                           _ path: UnsafeMutablePointer<XrPath>?) -> XrResult {
    guard let _ = pathString, let path = path else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    path.pointee = 1234
    return XR_SUCCESS
}

@_cdecl("xrSuggestInteractionProfileBindings")
public func xrSuggestInteractionProfileBindings(_ instance: XrInstance,
                                                _ suggestedBindings: UnsafePointer<XrInteractionProfileSuggestedBinding>?) -> XrResult {
    print("xrSuggestInteractionProfileBindings called")
    return XR_SUCCESS
}

@_cdecl("xrSyncActions")
public func xrSyncActions(_ session: XrSession, _ syncInfo: UnsafePointer<XrActionsSyncInfo>?) -> XrResult {
//    print("xrSyncActions called")
    return XR_SUCCESS
}

@_cdecl("xrWaitFrame")
public func xrWaitFrame(_ session: XrSession,
                        _ frameWaitInfo: UnsafePointer<XrFrameWaitInfo>?,
                        _ frameState: UnsafeMutablePointer<XrFrameState>?) -> XrResult {
    print("xrWaitFrame")
    guard let frameState = frameState else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    frameState.pointee.type = XR_TYPE_FRAME_STATE
    frameState.pointee.next = nil
    
    frameState.pointee.predictedDisplayTime = 0
    frameState.pointee.predictedDisplayPeriod = Int64(1e9/90)
    frameState.pointee.shouldRender = 1
    return XR_SUCCESS
}
