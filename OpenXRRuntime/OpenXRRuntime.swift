import ARKit
// contains "openxr.h+" from the official sdk
import OpenXRRuntime.OpenXR
import Darwin
import SwiftUI
import CompositorServices
import OpenXRRuntime.runtime
import GameController
internal import OrderedCollections

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

public typealias PFN_xrCreateHandTrackerEXT = @convention(c) (XrSession, UnsafePointer<XrHandTrackerCreateInfoEXT>?, UnsafeMutablePointer<XrHandTrackerEXT>?) -> XrResult
public typealias PFN_xrDestroyHandTrackerEXT = @convention(c) (XrHandTrackerEXT) -> XrResult
public typealias PFN_xrLocateHandJointsEXT = @convention(c) (XrHandTrackerEXT,
                                                               UnsafePointer<XrHandJointsLocateInfoEXT>?,
                                                               UnsafeMutablePointer<XrHandJointLocationsEXT>?) -> XrResult

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
    case "xrCreateHandTrackerEXT":
        function?.pointee = unsafeBitCast(xrCreateHandTrackerEXT as PFN_xrCreateHandTrackerEXT,
                                          to: UnsafeMutableRawPointer.self)
    case "xrDestroyHandTrackerEXT":
        function?.pointee = unsafeBitCast(xrDestroyHandTrackerEXT as PFN_xrDestroyHandTrackerEXT,
                                          to: UnsafeMutableRawPointer.self)
    case "xrLocateHandJointsEXT":
        function?.pointee = unsafeBitCast(xrLocateHandJointsEXT as PFN_xrLocateHandJointsEXT,
                                          to: UnsafeMutableRawPointer.self)
    default:
        print("asked for \(funcName) but unsupported")
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
        
        configuration.layout = supportedLayouts.contains(.layered) ? .layered : .dedicated
        print("layout: \(configuration.layout)")
        
        // although we copy the user texture to the final texture, there is still benefit for foveation
        // when the user texture is bigger than the layer renderer one
        configuration.isFoveationEnabled = false//supportsFoveation
        
        print("supportsFoveation: \(supportsFoveation)")
        configuration.colorFormat = .rgba16Float
    }
}

public struct OpenXRScene: Scene {
    @State  var immersionStyle: ImmersionStyle = MixedImmersionStyle.mixed
    let onInit: ((LayerRenderer) -> Void)?
    let onAppear: (() -> Void)?
    @Binding var setImmersiveSpace: Bool
    @Binding var isLoading: Bool
    
    @State private var controllers: [GCController] = GCController.controllers()

    public init(onInit: ((LayerRenderer) -> Void)?, onAppear: (() -> Void)?, setImmersiveSpace: Binding<Bool>, isLoading: Binding<Bool>) {
        self.onInit = onInit
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
                    controllers = GCController.controllers()

                    // Register for notifications to update the list when controllers connect/disconnect
                    NotificationCenter.default.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) { _ in
                        controllers = GCController.controllers()
                        print("controller connected \(controllers)")
                    }
                    NotificationCenter.default.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: .main) { _ in
                        controllers = GCController.controllers()
                        print("controller disconnected \(controllers)")

                    }
                }
        }
        .windowResizability(.contentSize)
        ImmersiveSpace(id: "OpenXR") {
            CompositorLayer(configuration: MetalLayerConfiguration()) { layerRenderer in
                onInit?(layerRenderer)
                globalLayerRenderer = layerRenderer
                print("entered immersive space")
            }
        }
        .immersionStyle(selection: $immersionStyle, in: .full, .mixed)
        .upperLimbVisibility(.hidden)
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

class Instance {
    var eventQueue: EventQueue
    var session: Session? // just one session for now
    let metalDevice: MTLDevice = MTLCreateSystemDefaultDevice()!
    
    init() {
        self.eventQueue = EventQueue()
    }
}


class Session {
    let metalDevice: MTLDevice
    let arSession: ARKitSession
    var worldTrackingProvider: WorldTrackingProvider
    var handTrackingProvider: HandTrackingProvider
    var commandQueue : MTLCommandQueue
    var renderer: Renderer
    var eventQueue: EventQueue
    var swapchain: [Swapchain]
    var actionSets : OrderedDictionary<Int, ActionSet>
    
    init(
        metalDevice: MTLDevice,
        arSession: ARKitSession,
        worldTrackingProvider: WorldTrackingProvider,
        commandQueue: MTLCommandQueue,
        renderer: Renderer,
        eventQueue: EventQueue,
        handtrackingProvider: HandTrackingProvider ) {
            self.metalDevice = metalDevice
            self.arSession = arSession
            self.worldTrackingProvider = worldTrackingProvider
            self.commandQueue = commandQueue
            self.swapchain = []
            self.renderer = renderer
            self.eventQueue = eventQueue
            self.handTrackingProvider = handtrackingProvider
            self.actionSets = [:]
            self.handTrackers = [:]
        }
    
    var timing: LayerRenderer.Frame.Timing?
    var currentFrame: LayerRenderer.Frame?
    var lastGoodDeviceAnchor : DeviceAnchor?
    var handTrackers : [XrHandEXT:HandTracker]
    
    func print_() {
        print("Session")
        print("ActionSets")
        for (priority, set) in self.actionSets {
            print("   prio \(priority): \(set)")
        }
    }
}

extension XrSession {
    func getSession() -> Session? {
        return unsafeBitCast(self, to: Session?.self)
    }
}

extension Session {
    func getXrSession() -> XrSession? {
        return unsafeBitCast(self, to: XrSession?.self)
    }
}

// MARK: rendering

extension Instance {
    func createSession() -> Session? {
        if self.session != nil { // only support one session at the moment
            return nil
        }
        
        let session = Session(
            metalDevice: self.metalDevice,
            arSession: ARKitSession(),
            worldTrackingProvider: WorldTrackingProvider(),
            commandQueue: self.metalDevice.makeCommandQueue()!,
            renderer: setupRenderer(device: self.metalDevice),
            eventQueue: self.eventQueue,
            handtrackingProvider: HandTrackingProvider()
        )
        session.commandQueue.label = "openxr command queue"
        return session
    }
}

@_cdecl("xrCreateInstance")
public func xrCreateInstance(_ createInfo: UnsafePointer<XrInstanceCreateInfo>?,
                             _ instance: UnsafeMutablePointer<XrInstance>?) -> XrResult {
    print("xrCreateInstance called")
    guard let instanceOut = instance else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    let instance = Instance()
//    instanceOut.pointee = instance.getXrInstance()!
    instanceOut.pointee = OpaquePointer(Unmanaged.passRetained(instance).toOpaque())
    return XR_SUCCESS
}

extension XrInstance {
    func getInstance() -> Instance? {
        return unsafeBitCast(self, to: Instance?.self)
    }
}

extension Instance {
    func getXrInstance() -> XrInstance? {
        return unsafeBitCast(self, to: XrInstance?.self)
    }
}

@_cdecl("xrDestroyInstance")
public func xrDestroyInstance(_ instance: XrInstance) -> XrResult {
    print("xrDestroyInstance")
    let rawPtr = unsafeBitCast(instance, to: UnsafeMutableRawPointer.self)
    rawPtr.deallocate()
    return XR_SUCCESS
}

extension Session {
    func setupSession() {
        Task {
            do {
                globalLayerRenderer!.waitUntilRunning()
                
                var dataProviders: [DataProvider] = [self.worldTrackingProvider]
                
                if HandTrackingProvider.isSupported {
                    dataProviders.append(self.handTrackingProvider)
                }
                try await self.arSession.run(dataProviders)
                while (true) {
                    guard self.worldTrackingProvider.state != .running else { break }
                    try await Task.sleep(nanoseconds: 10_000_000)
                }
                
                // querydeviceanchor doesn't seem to return a result for a little while, lets not tell
                // openxr we're ready until we start getting headset locations
                while(true) {
                    let timestamp = CACurrentMediaTime()
                    guard self.worldTrackingProvider.queryDeviceAnchor(atTimestamp: timestamp) != nil else {
                        try await Task.sleep(nanoseconds: 10_000_000)
                        continue
                    }
                    break
                }
                
                self.eventQueue.newEvent(Event.sessionStateChanged(state:XR_SESSION_STATE_READY))
            } catch {
                fatalError("Failed to init")
            }
        }
    }
}

@_cdecl("xrCreateSession")
public func xrCreateSession(_ instance: XrInstance,
                            _ createInfo: UnsafePointer<XrSessionCreateInfo>?,
                            _ session: UnsafeMutablePointer<XrSession>?) -> XrResult {
    print("xrCreateSession called")
    guard let sessionOut = session else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    let inst = instance.getInstance()!
    
    let session = inst.createSession()
    guard let session = session else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    session.setupSession()
    
    sessionOut.pointee = OpaquePointer(Unmanaged.passRetained(session).toOpaque())
    return XR_SUCCESS
}

@_cdecl("xrDestroySession")
public func xrDestroySession(_ session: XrSession) -> XrResult {
    print("xrDestroySession")
    let rawPtr = unsafeBitCast(session, to: UnsafeMutableRawPointer.self)
    rawPtr.deallocate()
    return XR_SUCCESS
}

var globalLayerRenderer: LayerRenderer? = nil
class EventQueue {
    var queue: [Event] = []
    
    func newEvent(_ event: Event) {
        // TODO locking?
        queue.append(event)
    }
    
    func getEvent() -> Event? {
        if queue.isEmpty {
            return nil
        }
        return queue.removeFirst()
    }
}

enum Event {
    case sessionStateChanged(state: XrSessionState)
    
    func fillEventDataBuffer(_ instance: Instance,  _ buffer: inout XrEventDataBuffer) {
        switch self {
        case .sessionStateChanged(let state):
            buffer.type = XR_TYPE_EVENT_DATA_SESSION_STATE_CHANGED
            
            print("new state: \(state)")
            withUnsafeMutablePointer(to: &buffer) { ptr in
                let sessionStateChangedPtr = UnsafeMutableRawPointer(ptr)
                    .assumingMemoryBound(to: XrEventDataSessionStateChanged.self)
                sessionStateChangedPtr.pointee.type = XR_TYPE_EVENT_DATA_SESSION_STATE_CHANGED
                sessionStateChangedPtr.pointee.session = unsafeBitCast(instance.session, to: OpaquePointer.self)
                sessionStateChangedPtr.pointee.state = state
                sessionStateChangedPtr.pointee.time = Int64(Date().timeIntervalSince1970)
            }
        }
    }
}

@_cdecl("xrPollEvent")
public func xrPollEvent(_ instance: XrInstance,
                        _ eventDataBuffer: UnsafeMutablePointer<XrEventDataBuffer>?) -> XrResult {
    
//    print("xrPollEvent")
    let inst = instance.getInstance()!
    
    if let event = inst.eventQueue.getEvent() {
        print("xrPollEvent returning event")
        if var buffer = eventDataBuffer?.pointee {
            event.fillEventDataBuffer(inst, &buffer)
            eventDataBuffer?.pointee = buffer
        }
        return XR_SUCCESS
    }
    
    eventDataBuffer?.pointee.type = XrStructureType(0)
    return XR_EVENT_UNAVAILABLE
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

// called before game update
@_cdecl("xrWaitFrame")
public func xrWaitFrame(_ session: XrSession,
                        _ frameWaitInfo: UnsafePointer<XrFrameWaitInfo>?,
                        _ frameState: UnsafeMutablePointer<XrFrameState>?) -> XrResult {
    
    guard let frameState = frameState else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
//    print("xrWaitFrame")
    let sess = session.getSession()!
//    print("\tpaused: \(globalLayerRenderer!.state == .paused), running: \(globalLayerRenderer!.state == .running), invalidated: \(globalLayerRenderer!.state == .invalidated)")
    
    var frame : LayerRenderer.Frame?
    if sess.currentFrame != nil {
        print("currentframe shouldn't be non nil")
        frame = sess.currentFrame
        return XR_ERROR_RUNTIME_FAILURE
    } else {
        frame = globalLayerRenderer!.queryNextFrame()
        sess.currentFrame = frame
    }
    
    sess.timing = frame!.predictTiming()!
    let deadline = sess.timing!.presentationTime

    let (seconds, attoseconds) = LayerRenderer.Clock.Instant.epoch.duration(to: deadline).components
    let deadlineNanos: Int64 = Int64(seconds) * 1_000_000_000 + Int64(attoseconds / 1_000_000_000)
//    print("deadline \(Double(deadlineNanos)/1e9)")
    frameState.pointee.type = XR_TYPE_FRAME_STATE
    frameState.pointee.next = nil

    frameState.pointee.predictedDisplayTime = deadlineNanos
    frameState.pointee.predictedDisplayPeriod = Int64(1e9/90) // TODO get from somewhere?
    frameState.pointee.shouldRender = 1 // TODO would be set to 0 if window is minimised or something

    // although godot seems to call xrwaitframe before doing update(), i don't think its supposed to
    // sess.currentFrame!.startUpdate()
    
    LayerRenderer.Clock().wait(until:sess.timing!.optimalInputTime)
    
    return XR_SUCCESS
}

// basic sequence of events seem to be:
//xrBeginSession called
//xrCreateReferenceSpace called
//xrCreateSwapchain called
//requested number of textures 1
//xrEnumerateSwapchainImages called
//xrEnumerateSwapchainImages called

// then in a loop
//xrWaitFrame
//xrLocateViews
//xrBeginFrame
//xrAcquireSwapchainImage
//xrWaitSwapchainImage
//xrReleaseSwapchainImage
//xrEndFrame

func extractFOVs(from metalProjection: simd_float4x4) -> (angleLeft: Float, angleRight: Float, angleUp: Float, angleDown: Float) {
    let m00 = metalProjection.columns.0.x
    let m11 = metalProjection.columns.1.y
    let m02 = metalProjection.columns.2.x
    let m12 = metalProjection.columns.2.y
    
    // Compute the tangents for each edge.
    let tanRight = (1 + m02) / m00
    let tanLeft  = (1 - m02) / m00
    let tanUp    = (1 + m12) / m11
    let tanDown  = (1 - m12) / m11
    
    let angleRight = atan(tanRight)
    let angleLeft  = atan(tanLeft)
    let angleUp    = atan(tanUp)
    let angleDown  = atan(tanDown)
    
    return (angleLeft, angleRight, angleUp, angleDown)
}

@_cdecl("xrLocateViews")
public func xrLocateViews(_ session: XrSession,
                          _ viewLocateInfo: UnsafePointer<XrViewLocateInfo>?,
                          _ viewState: UnsafeMutablePointer<XrViewState>?,
                          _ viewCapacityInput: UInt32,
                          _ viewCountOutput: UnsafeMutablePointer<UInt32>?,
                          _ views: UnsafeMutablePointer<XrView>?) -> XrResult {
//    print("xrLocateViews")
    let sess = session.getSession()!

    // TODO returns nil if minimised
    let drawable = sess.currentFrame!.queryDrawable()!
//    print("drawable size: (\(drawable.colorTextures[0].width),\(drawable.colorTextures[0].height))")
    
    let (seconds, attoseconds) = LayerRenderer.Clock.Instant.epoch.duration(to: drawable.frameTiming.presentationTime).components
    let presentationTime: Double = Double(seconds) + Double(attoseconds) * 1e-18
    var deviceAnchor = sess.worldTrackingProvider.queryDeviceAnchor(atTimestamp: presentationTime)
    if deviceAnchor == nil {
        print("No device anchor available at \(presentationTime)")
        drawable.deviceAnchor = sess.lastGoodDeviceAnchor
        deviceAnchor = sess.lastGoodDeviceAnchor
    } else if !deviceAnchor!.isTracked {
        print("Device anchor is not tracked")
        drawable.deviceAnchor = sess.lastGoodDeviceAnchor
        deviceAnchor = sess.lastGoodDeviceAnchor
    } else {
        drawable.deviceAnchor = deviceAnchor
        sess.lastGoodDeviceAnchor = deviceAnchor
    }
    
    let viewCount = drawable.views.count
    viewCountOutput?.pointee = UInt32(viewCount)

    if let viewState = viewState {
        viewState.pointee.type = XR_TYPE_VIEW_STATE
        viewState.pointee.next = nil
        viewState.pointee.viewStateFlags = XR_VIEW_STATE_POSITION_VALID_BIT | XR_VIEW_STATE_ORIENTATION_VALID_BIT
    }
    
    if viewCapacityInput < viewCount {
        print("xrLocateViews not enough input capacity: required \(viewCount), got \(viewCapacityInput)")
        return XR_ERROR_RUNTIME_FAILURE
    }
    
    if let views = views {
        for i in 0..<viewCount {
            let view = drawable.views[i]
            let viewMatrix = (deviceAnchor!.originFromAnchorTransform*view.transform)
            
            let translation = viewMatrix.translation
            let orientation = viewMatrix.orientation
            
            views[i].type = XR_TYPE_VIEW
            views[i].next = nil
            views[i].pose.position.x = translation.x
            views[i].pose.position.y = translation.y
            views[i].pose.position.z = translation.z
            views[i].pose.orientation.x = orientation.vector.x
            views[i].pose.orientation.y = orientation.vector.y
            views[i].pose.orientation.z = orientation.vector.z
            views[i].pose.orientation.w = orientation.vector.w
            
            let angles = extractFOVs(from: drawable.computeProjection(viewIndex: i))
            views[i].fov.angleLeft  = Float(-angles.angleLeft)
            views[i].fov.angleRight = Float(angles.angleRight)
            views[i].fov.angleUp    = Float(angles.angleUp)
            views[i].fov.angleDown  = Float(-angles.angleDown)
        }
    }
    return XR_SUCCESS
}

// called after game update, before rendering
@_cdecl("xrBeginFrame")
public func xrBeginFrame(_ session: XrSession,
                         _ frameBeginInfo: UnsafePointer<XrFrameBeginInfo>?) -> XrResult {
//    print("xrBeginFrame")
    let sess = session.getSession()!
    
    if let currentFrame = sess.currentFrame {
        currentFrame.startSubmission()
    } else {
        print("null currentframe eh")
    }
    
    return XR_SUCCESS
}
struct Vertex {
    var position: SIMD2<Float>
    var texCoord: SIMD2<Float>
}
struct Renderer {
    let vertexBuffer: MTLBuffer
    let vertexCount: Int
    let pipelineState: MTLRenderPipelineState
    let samplerState: MTLSamplerState
    let commandQueue: MTLCommandQueue
}
func setupRenderer(device: MTLDevice) -> Renderer {
    let vertices: [Vertex] = [
        Vertex(position: SIMD2(-1,  1), texCoord: SIMD2(0, 0)),
        Vertex(position: SIMD2(-1, -1), texCoord: SIMD2(0, 1)),
        Vertex(position: SIMD2( 1, -1), texCoord: SIMD2(1, 1)),
        
        Vertex(position: SIMD2(-1,  1), texCoord: SIMD2(0, 0)),
        Vertex(position: SIMD2( 1, -1), texCoord: SIMD2(1, 1)),
        Vertex(position: SIMD2( 1,  1), texCoord: SIMD2(1, 0))
    ]
    let vertexCount = vertices.count
    
    guard let vertexBuffer = device.makeBuffer(bytes: vertices,
                                               length: MemoryLayout<Vertex>.stride * vertices.count,
                                               options: []) else {
        fatalError("Could not create vertex buffer")
    }
    
    let shader = """
    #include <metal_stdlib>
    using namespace metal;
    
    struct Vertex {
        float2 position [[attribute(0)]];
        float2 texCoord [[attribute(1)]];
    };
    
    struct VertexOut {
        float4 position [[position]];
        float2 texCoord;
        uint layer [[render_target_array_index]];
    };
    
    struct FragmentOut {
        float4 color [[color(0)]];
        float depth [[depth(any)]];
    };
    
    vertex VertexOut vertexShader(uint vertexID [[vertex_id]],
                                  uint instanceID [[instance_id]],
                                  const device Vertex* vertices [[buffer(0)]]) {
        VertexOut out;
        out.position = float4(vertices[vertexID].position, 0.0, 1.0);
        out.texCoord = vertices[vertexID].texCoord;
        out.layer = instanceID;
        return out;
    }
    
    fragment FragmentOut fragmentShader(VertexOut in [[stage_in]],
                                          texture2d_array<float> colorTexture [[texture(0)]],
                                          texture2d_array<float> depthTexture [[texture(1)]],
                                          sampler samplr [[sampler(0)]]) {
        FragmentOut out;
        out.color = colorTexture.sample(samplr, in.texCoord, in.layer);
        float sample = depthTexture.sample(samplr, in.texCoord, in.layer).r;
        
        // avoid 0 for now as it is rendered black
        out.depth = sample > 0.0001 ? sample : 0.0001;
        return out;
    }
    """
    
    let library: MTLLibrary
    do {
        library = try device.makeLibrary(source: shader, options: nil)
    } catch {
        fatalError("Failed to create library from source: \(error)")
    }
    
    guard let vertexFunction = library.makeFunction(name: "vertexShader"),
          let fragmentFunction = library.makeFunction(name: "fragmentShader") else {
        fatalError("Could not load shader functions")
    }
    
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormat.rgba16Float
    pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
    pipelineDescriptor.inputPrimitiveTopology = .triangle
    
    let pipelineState: MTLRenderPipelineState
    do {
        pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    } catch {
        fatalError("Failed to create pipeline state: \(error)")
    }
    
    let samplerDescriptor = MTLSamplerDescriptor()
    samplerDescriptor.minFilter = .linear
    samplerDescriptor.magFilter = .linear
    samplerDescriptor.sAddressMode = .clampToEdge
    samplerDescriptor.tAddressMode = .clampToEdge
    guard let samplerState = device.makeSamplerState(descriptor: samplerDescriptor) else {
        fatalError("Failed to create sampler state")
    }
    
    return Renderer(vertexBuffer: vertexBuffer,
                    vertexCount: vertexCount,
                    pipelineState: pipelineState,
                    samplerState: samplerState,
                    commandQueue: device.makeCommandQueue()!)
}

func drawSwapchainTextureToDrawable(renderer: Renderer,
                                    inputColour: MTLTexture,
                                    inputDepth: MTLTexture,
                                    output: LayerRenderer.Drawable) {
    guard let commandBuffer = renderer.commandQueue.makeCommandBuffer() else {
        fatalError("Could not create command buffer")
    }
    commandBuffer.label = "openxr texture array copy to drawable"
    
    let renderPassDescriptor = MTLRenderPassDescriptor()
    renderPassDescriptor.colorAttachments[0].texture = output.colorTextures[0]
    renderPassDescriptor.colorAttachments[0].loadAction = .clear
    renderPassDescriptor.colorAttachments[0].storeAction = .store
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1)
    
    renderPassDescriptor.depthAttachment.texture = output.depthTextures[0]
    renderPassDescriptor.depthAttachment.loadAction = .clear
    renderPassDescriptor.depthAttachment.storeAction = .store
    renderPassDescriptor.depthAttachment.clearDepth = 1.0
    
    renderPassDescriptor.rasterizationRateMap = output.rasterizationRateMaps.first
    /*
      "By default, a render pass doesn’t have a rasterization rate map, and the viewport coordinate system maps exactly to physical pixels in the targeted textures. If you apply a rasterization rate map to a render pass, the viewport coordinate system becomes a logical coordinate system, and the rate map describes how to map logical coordinates to physical pixels in the render pass’s targets. You can specify different rasterization rates in different regions of the logical coordinate system. When you do, those logical units map to fewer physical pixels, which means you can use smaller render targets and render fewer pixels, saving both memory and processing time. For more information, see Rendering at Different Rasterization Rates."

     rasterizationRateMap {
        ScreenSizeWidth: 4065,
        ScreenSizeHeight: 3263
     }
     */
    
#if targetEnvironment(simulator)
    renderPassDescriptor.renderTargetArrayLength = 1
#else
    renderPassDescriptor.renderTargetArrayLength = 2
#endif
    
    guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
        fatalError("Could not create render encoder")
    }
    
    let depthStencilDescriptor = MTLDepthStencilDescriptor()
    depthStencilDescriptor.depthCompareFunction = .always
    depthStencilDescriptor.isDepthWriteEnabled = true
    let device = inputColour.device
    guard let depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor) else {
        fatalError("Could not create depth stencil state")
    }
    renderEncoder.setDepthStencilState(depthStencilState)
    
    renderEncoder.setRenderPipelineState(renderer.pipelineState)
    renderEncoder.setVertexBuffer(renderer.vertexBuffer, offset: 0, index: 0)
    
    renderEncoder.setFragmentTexture(inputColour, index: 0)
    renderEncoder.setFragmentTexture(inputDepth, index: 1)
    renderEncoder.setFragmentSamplerState(renderer.samplerState, index: 0)
    
    let instanceCount = inputColour.arrayLength
    renderEncoder.drawPrimitives(type: .triangle,
                                 vertexStart: 0,
                                 vertexCount: renderer.vertexCount,
                                 instanceCount: instanceCount)
    
    renderEncoder.endEncoding()
    
    output.encodePresent(commandBuffer: commandBuffer)
    commandBuffer.commit()
}

func degrees(_ radians: Float) -> Float {
    return (radians / (2*Float.pi)) * 360
}
func rads(_ degrees: Float) -> Float {
    return (degrees / 360) * 2*Float.pi
}

@_cdecl("xrBeginSession")
public func xrBeginSession(_ xrsession: XrSession,
                           _ beginInfo: UnsafePointer<XrSessionBeginInfo>?) -> XrResult {
    print("xrBeginSession")
    let session = xrsession.getSession()!
    session.eventQueue.newEvent(Event.sessionStateChanged(state:XR_SESSION_STATE_SYNCHRONIZED))
    session.eventQueue.newEvent(Event.sessionStateChanged(state:XR_SESSION_STATE_VISIBLE))
    session.eventQueue.newEvent(Event.sessionStateChanged(state:XR_SESSION_STATE_FOCUSED))
    return XR_SUCCESS
}

@_cdecl("xrEndSession")
public func xrEndSession(_ session: XrSession) -> XrResult {
    print("xrEndSession")
    return XR_SUCCESS
}
@_cdecl("xrEndFrame")
public func xrEndFrame(_ session: XrSession,
                       _ frameEndInfo: UnsafePointer<XrFrameEndInfo>?) -> XrResult {
//    print("xrEndFrame")
    let sess = session.getSession()!
    
    guard let info = frameEndInfo?.pointee else {
        print("No frame end info provided")
        return XR_ERROR_RUNTIME_FAILURE
    }
    
    if sess.currentFrame!.queryDrawable()!.deviceAnchor == nil {
        print("failed to get device anchor")
        return XR_ERROR_RUNTIME_FAILURE
    }
    
    //    print("Frame display time: \(info.displayTime)")
    //    print("Environment blend mode: \(info.environmentBlendMode)")
    //    print("Layer count: \(info.layerCount)")
    
    var colourSwapchain : Swapchain?
    var colourSwapchainIndex : Int = 0
    var depthSwapchain : Swapchain?
    var depthSwapchainIndex : Int = 0
    
    if info.layerCount > 0, let layersPtr = info.layers {
        let layersBuffer = UnsafeBufferPointer(start: layersPtr, count: Int(info.layerCount))
        for (i, layerHeaderOpt) in layersBuffer.enumerated() {
            if let layerHeaderPtr = layerHeaderOpt {
                let layerHeader = layerHeaderPtr.pointee
//                print("Layer \(i):")
//                print("  Type: \(layerHeader.type)")
//                print("  Next: \(String(describing: layerHeader.next))")
//                print("  Layer flags: \(layerHeader.layerFlags)")
//                print("  Space: \(layerHeader.space)")
                
                switch layerHeader.type {
                case XR_TYPE_COMPOSITION_LAYER_PROJECTION:
                    let projectionLayer = layerHeaderPtr.withMemoryRebound(to: XrCompositionLayerProjection.self, capacity: 1) { $0.pointee }
//                         print("  Projection layer info:")
//                         print("    Space: \(projectionLayer.space)")
//                         print("    View count: \(projectionLayer.viewCount)")
                    
                    if projectionLayer.viewCount > 0, let viewsPtr = projectionLayer.views {
                        let viewsBuffer = UnsafeBufferPointer(start: viewsPtr, count: Int(projectionLayer.viewCount))
                        for (viewIndex, view) in viewsBuffer.enumerated() {
//                             print("      View \(viewIndex):")
//                             print("        Pose: \(view.pose)")
//                             print("        Field of View: left: \(degrees(view.fov.angleLeft)), right: \(degrees(view.fov.angleRight)), up: \(degrees(view.fov.angleUp)), down: \(degrees(view.fov.angleDown))")
//                             print("        Swapchain SubImage:")
//                             print("          Swapchain: \(view.subImage.swapchain)")
//                             print("          ImageRect offset: \(view.subImage.imageRect.offset)")
//                             print("          ImageRect extent: \(view.subImage.imageRect.extent)")
//                             print("          Image array index: \(view.subImage.imageArrayIndex)")
                            colourSwapchain = Unmanaged<Swapchain>.fromOpaque(UnsafeRawPointer(view.subImage.swapchain)).takeUnretainedValue()
                            colourSwapchainIndex = Int(view.subImage.imageArrayIndex)
                        }
                        
                        var nextStruct: UnsafeRawPointer? = viewsPtr.pointee.next
                        while let next = nextStruct {
                            let base = next.assumingMemoryBound(to: XrBaseInStructure.self).pointee
                            if base.type == XR_TYPE_COMPOSITION_LAYER_DEPTH_INFO_KHR {
                                let depthInfo = next.assumingMemoryBound(to: XrCompositionLayerDepthInfoKHR.self).pointee
//                                     print("        Depth Info:")
//                                     print("          Min Depth: \(depthInfo.minDepth)")
//                                     print("          Max Depth: \(depthInfo.maxDepth)")
//                                     print("          Near Z: \(depthInfo.nearZ)")
//                                     print("          Far Z: \(depthInfo.farZ)")
//                                     print("          Depth Swapchain SubImage:")
//                                     print("              Swapchain: \(depthInfo.subImage.swapchain)")
//                                     print("              ImageRect:")
//                                     print("                Offset - x: \(depthInfo.subImage.imageRect.offset.x), y: \(depthInfo.subImage.imageRect.offset.y)")
//                                     print("                Extent - width: \(depthInfo.subImage.imageRect.extent.width), height: \(depthInfo.subImage.imageRect.extent.height)")
//                                     print("              Image Array Index: \(depthInfo.subImage.imageArrayIndex)")
                                depthSwapchain = Unmanaged<Swapchain>.fromOpaque(UnsafeRawPointer(depthInfo.subImage.swapchain)).takeUnretainedValue()
                                depthSwapchainIndex = Int(depthInfo.subImage.imageArrayIndex)
                            } else {
                                print("unknown base.type \(base.type)")
                            }
                            nextStruct = base.next.map { UnsafeRawPointer($0) }
                        }
                    } else {
                        print("    No views available")
                    }
                    
                default:
                    print("  Unknown or unsupported layer type \(layerHeader.type)")
                }
            } else {
                print("Layer \(i) is nil")
            }
        }
    } else {
        print("No layers provided")
    }
    
    if colourSwapchain == nil || depthSwapchain == nil {
        print("couldn't find swapchains")
        return XR_ERROR_RUNTIME_FAILURE
    } else {
        // TODO indexes of swapchain image
        sess.Draw(colourSwapchain: colourSwapchain!, depthSwapchain: depthSwapchain!)
    }
    
    return XR_SUCCESS
}

extension Session {
    func Draw(colourSwapchain : Swapchain, depthSwapchain : Swapchain) {
        guard let drawable = self.currentFrame?.queryDrawable() else {
            fatalError("Drawable not available")
        }
        drawSwapchainTextureToDrawable(
            renderer: self.renderer,
            inputColour: colourSwapchain.textures[0],
            inputDepth: depthSwapchain.textures[0],
            output: drawable)
        
        self.currentFrame!.endSubmission()
        self.currentFrame = nil
    }
}

@_cdecl("xrEnumerateViewConfigurations")
public func xrEnumerateViewConfigurations(_ instance: XrInstance,
                                          _ systemId: XrSystemId,
                                          _ viewConfigurationTypeCapacityInput: UInt32,
                                          _ viewConfigurationTypeCountOutput: UnsafeMutablePointer<UInt32>?,
                                          _ viewConfigurationTypes: UnsafeMutablePointer<XrViewConfigurationType>?) -> XrResult {
    print("xrEnumerateViewConfigurations")
    // TODO
#if targetEnvironment(simulator)
    viewConfigurationTypeCountOutput?.pointee = 1
#else
    viewConfigurationTypeCountOutput?.pointee = 2
#endif
    if viewConfigurationTypeCapacityInput < 1 {
        return XR_SUCCESS
    }
    if let viewConfigurationTypes = viewConfigurationTypes {
        for i in 0..<Int(viewConfigurationTypeCountOutput!.pointee) {
            viewConfigurationTypes[i] = XR_VIEW_CONFIGURATION_TYPE_PRIMARY_STEREO
        }
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
    // TODO
#if targetEnvironment(simulator)
    viewCountOutput?.pointee = 1
#else
    viewCountOutput?.pointee = 2
#endif
    
    if viewCapacityInput < 1 {
        return XR_SUCCESS
    }
    
    if let views = views {
        for i in 0..<Int(viewCountOutput!.pointee) {
            views[i].type = XR_TYPE_VIEW_CONFIGURATION_VIEW
            views[i].next = nil

            // TODO calculate these better
            views[i].recommendedImageRectWidth = 1920
            views[i].recommendedImageRectHeight = 1824
            
//            views[i].recommendedImageRectWidth = 2880
//            views[i].recommendedImageRectHeight = 2736
            
            views[i].maxImageRectWidth = 4065
            views[i].maxImageRectHeight = 3263
            
            // sim: drawable size: (2732,2048)
            // dev: drawable size: (1920,1824)
            // screen: 4065x3263

            // TODO maxs
            views[i].recommendedSwapchainSampleCount = 1
        }
    }
    return XR_SUCCESS
}

@_cdecl("xrEnumerateEnvironmentBlendModes")
public func xrEnumerateEnvironmentBlendModes(_ instance: XrInstance,
                                             _ systemId: XrSystemId,
                                             _ viewConfigurationType: XrViewConfigurationType,
                                             _ environmentBlendModeCapacityInput: UInt32,
                                             _ environmentBlendModeCountOutput: UnsafeMutablePointer<UInt32>?,
                                             _ environmentBlendModes: UnsafeMutablePointer<XrEnvironmentBlendMode>?) -> XrResult {
    environmentBlendModeCountOutput?.pointee = 2
    
    if environmentBlendModeCapacityInput < 2 {
        return XR_SUCCESS
    }
    
    if let environmentBlendModes = environmentBlendModes {
        environmentBlendModes[0] = XR_ENVIRONMENT_BLEND_MODE_ALPHA_BLEND
        environmentBlendModes[1] = XR_ENVIRONMENT_BLEND_MODE_OPAQUE
    }
    return XR_SUCCESS
}

@_cdecl("xrGetMetalGraphicsRequirementsKHR")
public func xrGetMetalGraphicsRequirementsKHR(_ instance: XrInstance,
                                              _ systemId: XrSystemId,
                                              _ metalRequirements: UnsafeMutablePointer<XrGraphicsRequirementsMetalKHR>?) -> XrResult {
    guard let metalRequirements = metalRequirements else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    let inst = instance.getInstance()!
    
    metalRequirements.pointee.type = XR_TYPE_GRAPHICS_REQUIREMENTS_METAL_KHR
    metalRequirements.pointee.next = nil
    
    metalRequirements.pointee.metalDevice = Unmanaged.passUnretained(inst.metalDevice).toOpaque()
    
    return XR_SUCCESS
}

// MARK: hand tracking

class HandTracker {
    var chirality : XrHandEXT
    var provider : HandTrackingProvider
    
    var grasp : Float
    
    init(chirality: XrHandEXT, provider : HandTrackingProvider) {
        self.chirality = chirality
        self.provider = provider
        self.grasp = 1.0
    }
}

@_cdecl("xrCreateHandTrackerEXT")
public func xrCreateHandTrackerEXT(_ xrSession: XrSession,
                                   _ createInfo: UnsafePointer<XrHandTrackerCreateInfoEXT>?,
                                   _ handTracker: UnsafeMutablePointer<XrHandTrackerEXT>?) -> XrResult {
    print("xrCreateHandTrackerEXT")
    let session = xrSession.getSession()!
    
//    print("XrHandTrackerCreateInfoEXT:")
//    print("  type: \(createInfo!.pointee.type)")
//    print("  next: \(String(describing: createInfo!.pointee.next))")
//    print("  hand: \(createInfo!.pointee.hand)")

    let ht = HandTracker(chirality: createInfo!.pointee.hand,
                         provider: session.handTrackingProvider)
    session.handTrackers[createInfo!.pointee.hand] = ht
    
    handTracker!.pointee = OpaquePointer(Unmanaged.passRetained(ht).toOpaque())
    return XR_SUCCESS
}

extension simd_float4x4 {
    var translation: simd_float3 {
        return simd_float3(columns.3.x, columns.3.y, columns.3.z)
    }
    
    var orientation: simd_quatf {
        return simd_quaternion(self)
    }
    
    func distance(to other: simd_float4x4) -> Float {
        return simd_distance(self.translation, other.translation)
    }
}

@_cdecl("xrLocateHandJointsEXT")
public func xrLocateHandJointsEXT(_ handTracker: XrHandTrackerEXT,
                                  _ locateInfo: UnsafePointer<XrHandJointsLocateInfoEXT>?,
                                  _ locations: UnsafeMutablePointer<XrHandJointLocationsEXT>?) -> XrResult {
//    print("xrLocateHandJointsEXT called")
    
    // TODO getter for handtracker
    guard let ht = unsafeBitCast(handTracker, to: HandTracker?.self) else {
        return XR_ERROR_RUNTIME_FAILURE
    }
    
    guard let locateInfo = locateInfo, let locations = locations else {
        return XR_ERROR_RUNTIME_FAILURE
    }
    
    let info = locateInfo.pointee
//    print("XrHandJointsLocateInfoEXT:")
//    print("  type: \(info.type)")
//    print("  baseSpace: \(info.baseSpace)")
//    print("  time: \(info.time)")
    
    let deadlineSeconds: Double = Double(info.time) / 1_000_000_000.0
    
    let (leftAnchor, rightAnchor) = ht.provider.handAnchors(at: deadlineSeconds)
    var handAnchor: HandAnchor?
    var jointRotationAdjustment : simd_quatf?
    if ht.chirality == XR_HAND_LEFT_EXT {
        handAnchor = leftAnchor
        jointRotationAdjustment = simd_quatf(angle: .pi / 2, axis: simd_float3(0, -1, 0))
        // i dunno how to get this right
        jointRotationAdjustment =  jointRotationAdjustment! *
            simd_quatf(angle: .pi / 2, axis: simd_float3(0, 0, -2))

    } else if ht.chirality == XR_HAND_RIGHT_EXT {
        handAnchor = rightAnchor
        jointRotationAdjustment = simd_quatf(angle: .pi / 2, axis: simd_float3(0, 1, 0))

    } else {
        print("Unknown hand chirality")
        return XR_ERROR_RUNTIME_FAILURE
    }
    
    let openxrJointCount = locations.pointee.jointCount
    locations.pointee.isActive = XrBool32(handAnchor != nil ? XR_TRUE : XR_FALSE)
//    print("joint count: \(openxrJointCount)")
    
    // Ensure the jointLocations pointer is valid.
    guard let jointLocationsPtr = locations.pointee.jointLocations else {
        print("jointLocations pointer is nil")
        return XR_ERROR_RUNTIME_FAILURE
    }
    let jointMapping: [HandSkeleton.JointName] = [
        .wrist,                         // 0: XR_HAND_JOINT_PALM_EXT (use wrist as palm center)
        .wrist,                         // 1: XR_HAND_JOINT_WRIST_EXT
        
        .thumbKnuckle,                  // 2: XR_HAND_JOINT_THUMB_METACARPAL_EXT
        .thumbIntermediateBase,         // 3: XR_HAND_JOINT_THUMB_PROXIMAL_EXT
        .thumbIntermediateTip,          // 4: XR_HAND_JOINT_THUMB_DISTAL_EXT
        .thumbTip,                      // 5: XR_HAND_JOINT_THUMB_TIP_EXT
        
        .indexFingerMetacarpal,         // 6: XR_HAND_JOINT_INDEX_METACARPAL_EXT
        .indexFingerKnuckle,            // 7: XR_HAND_JOINT_INDEX_PROXIMAL_EXT
        .indexFingerIntermediateBase,   // 8: XR_HAND_JOINT_INDEX_INTERMEDIATE_EXT
        .indexFingerIntermediateTip,    // 9: XR_HAND_JOINT_INDEX_DISTAL_EXT
        .indexFingerTip,                // 10: XR_HAND_JOINT_INDEX_TIP_EXT
        
        .middleFingerMetacarpal,        // 11: XR_HAND_JOINT_MIDDLE_METACARPAL_EXT
        .middleFingerKnuckle,           // 12: XR_HAND_JOINT_MIDDLE_PROXIMAL_EXT
        .middleFingerIntermediateBase,  // 13: XR_HAND_JOINT_MIDDLE_INTERMEDIATE_EXT
        .middleFingerIntermediateTip,   // 14: XR_HAND_JOINT_MIDDLE_DISTAL_EXT
        .middleFingerTip,               // 15: XR_HAND_JOINT_MIDDLE_TIP_EXT
        
        .ringFingerMetacarpal,          // 16: XR_HAND_JOINT_RING_METACARPAL_EXT
        .ringFingerKnuckle,             // 17: XR_HAND_JOINT_RING_PROXIMAL_EXT
        .ringFingerIntermediateBase,    // 18: XR_HAND_JOINT_RING_INTERMEDIATE_EXT
        .ringFingerIntermediateTip,     // 19: XR_HAND_JOINT_RING_DISTAL_EXT
        .ringFingerTip,                 // 20: XR_HAND_JOINT_RING_TIP_EXT
        
        .littleFingerMetacarpal,        // 21: XR_HAND_JOINT_LITTLE_METACARPAL_EXT
        .littleFingerKnuckle,           // 22: XR_HAND_JOINT_LITTLE_PROXIMAL_EXT
        .littleFingerIntermediateBase,  // 23: XR_HAND_JOINT_LITTLE_INTERMEDIATE_EXT
        .littleFingerIntermediateTip,   // 24: XR_HAND_JOINT_LITTLE_DISTAL_EXT
        .littleFingerTip                // 25: XR_HAND_JOINT_LITTLE_TIP_EXT
    ]
    
    if let handAnchor = handAnchor, let handSkeleton = handAnchor.handSkeleton {
        let grasp = handSkeleton.joint(.middleFingerTip).anchorFromJointTransform.distance(
            to: handSkeleton.joint(.wrist).anchorFromJointTransform)
        ht.grasp = 1.2-abs(grasp * 5)
//        print("grasp \(ht.chirality): \(ht.grasp)")
        
        for (openxrIndex, joint) in jointMapping.enumerated() {
            var transform : simd_float4x4? = handSkeleton.joint(joint).anchorFromJointTransform
            if transform != nil {
                // handAnchor.originFromAnchorTransform is base of the wrist
                transform = handAnchor.originFromAnchorTransform * transform!

                var orientation = transform!.orientation
                orientation = orientation * jointRotationAdjustment!
                
                jointLocationsPtr[openxrIndex].pose.orientation.x = orientation.vector.x
                jointLocationsPtr[openxrIndex].pose.orientation.y = orientation.vector.y
                jointLocationsPtr[openxrIndex].pose.orientation.z = orientation.vector.z
                jointLocationsPtr[openxrIndex].pose.orientation.w = orientation.vector.w
                
                let translation = transform!.translation
                jointLocationsPtr[openxrIndex].pose.position.x = translation.x
                jointLocationsPtr[openxrIndex].pose.position.y = translation.y
                jointLocationsPtr[openxrIndex].pose.position.z = translation.z
                
                jointLocationsPtr[openxrIndex].radius = 0.05 // not sure what this does
                
                jointLocationsPtr[openxrIndex].locationFlags =
                    XR_SPACE_LOCATION_ORIENTATION_VALID_BIT |
                    XR_SPACE_LOCATION_POSITION_VALID_BIT |
                    XR_SPACE_LOCATION_ORIENTATION_TRACKED_BIT |
                    XR_SPACE_LOCATION_POSITION_TRACKED_BIT
            } else {
                jointLocationsPtr[openxrIndex].locationFlags = 0
            }
        }
    } else {
        // No valid hand data; mark all joints as inactive.
        for i in 0..<openxrJointCount {
            jointLocationsPtr[Int(i)].locationFlags = 0
        }
    }
    
    return XR_SUCCESS
}

@_cdecl("xrDestroyHandTrackerEXT")
public func xrDestroyHandTrackerEXT(_ handTracker: XrHandTrackerEXT) -> XrResult {
    // TODO
    return XR_SUCCESS
}

// MARK: Misc

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
    let extensions = [
        "XR_KHR_metal_enable",
        "XR_KHR_composition_layer_depth",
        "XR_EXT_hand_tracking",
        "XR_EXT_hand_interaction"
    ]
    
    propertyCountOutput?.pointee = UInt32(extensions.count)
    if propertyCapacityInput < UInt32(extensions.count) {
        return XR_SUCCESS
    }
    
    if let properties = properties {
        for (index, ext) in extensions.enumerated() {
            properties[index].type = XR_TYPE_EXTENSION_PROPERTIES
            withUnsafeMutablePointer(to: &properties[index].extensionName) { ptr in
                ptr.withMemoryRebound(to: CChar.self, capacity: MemoryLayout.size(ofValue: properties[index].extensionName)) { cPtr in
                    strncpy(cPtr, ext, MemoryLayout.size(ofValue: properties[index].extensionName))
                }
            }
            properties[index].extensionVersion = 1
        }
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
            strncpy(cPtr, "OpenVision", MemoryLayout.size(ofValue: instanceProperties.pointee.runtimeName))
        }
    }
    instanceProperties.pointee.runtimeVersion = 1
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
    
    // Print the base system properties.
    print("System Properties:")
    print("  System ID: \(properties.pointee.systemId)")
    print("  Vendor ID: \(properties.pointee.vendorId)")
    let systemName = withUnsafePointer(to: &properties.pointee.systemName) {
        $0.withMemoryRebound(to: CChar.self, capacity: MemoryLayout.size(ofValue: properties.pointee.systemName)) {
            String(cString: $0)
        }
    }
    print("  System Name: \(systemName)")
    
    // Traverse the extension chain and print the properties found.
    var currentExtension: UnsafeMutableRawPointer? = properties.pointee.next
    while let extPointer = currentExtension {
        let baseStruct = extPointer.assumingMemoryBound(to: XrBaseInStructure.self)
        print("Found extension structure with type: \(baseStruct.pointee.type)")
        if baseStruct.pointee.type == XR_TYPE_SYSTEM_HAND_TRACKING_PROPERTIES_EXT {
            let handTrackingProps = extPointer.assumingMemoryBound(to: XrSystemHandTrackingPropertiesEXT.self)
            handTrackingProps.pointee.supportsHandTracking = XrBool32(XR_TRUE)
            print("  -> XrSystemHandTrackingPropertiesEXT found, supportsHandTracking set to \(handTrackingProps.pointee.supportsHandTracking)")
        } else {
            print("unknown property \(baseStruct.pointee.type)")
        }
        
        if let next = baseStruct.pointee.next {
            currentExtension = UnsafeMutableRawPointer(mutating: next)
        } else {
            currentExtension = nil
        }
    }
    
    return XR_SUCCESS
}

@_cdecl("xrResultToString")
public func xrResultToString(_ instance: XrInstance,
                             _ result: XrResult,
                             _ buffer: UnsafeMutablePointer<CChar>?) -> XrResult {
    // TODO
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


// MARK: controllers

extension XrActionSetCreateInfo {
    func print_() {
        let actionSetNameStr = withUnsafeBytes(of: actionSetName) { rawBuffer -> String in
            let baseAddress = rawBuffer.baseAddress!.assumingMemoryBound(to: CChar.self)
            return String(cString: baseAddress)
        }
        
        let localizedActionSetNameStr = withUnsafeBytes(of: localizedActionSetName) { rawBuffer -> String in
            let baseAddress = rawBuffer.baseAddress!.assumingMemoryBound(to: CChar.self)
            return String(cString: baseAddress)
        }

        print("XrActionSetCreateInfo:")
        print("  actionSetName: \(actionSetNameStr)")
        print("  localizedActionSetName: \(localizedActionSetNameStr)")
        print("  priority: \(priority)")
    }
}

class ActionSet {
    var name : String
    var priority : Int
    var actions: [String: Action] = [:]
    init(name : String, priority : Int) {
        self.name = name
        self.priority = priority
    }
    func print_() {
        print("ActionSet:")
        print("  Name: \(name)")
        print("  Priority: \(priority)")
        if actions.isEmpty {
            print("  No actions")
        } else {
            print("  Actions:")
            for (key, action) in actions {
                print("    Key: \(key)")
                action.print_()
            }
        }
    }
}

class ActionValue {
    var value : Float
    init(value : Float) {
        self.value = value
    }
}

class Action {
    var name : String
    var subpaths : [String:ActionValue]

    init(name : String, subpaths : [String]) {
        self.name = name
        self.subpaths = [:]
        for path in subpaths {
            self.subpaths[path] = ActionValue(value: 0.0)
        }
    }

    func print_() {
        print("    Action:")
        print("      Name: \(name)")
        if subpaths.isEmpty {
            print("      No subpaths")
        } else {
            print("      Subpaths:")
            for subpath in subpaths {
                print("        \(subpath)")
            }
        }
    }
}

@_cdecl("xrCreateActionSet")
public func xrCreateActionSet(_ instance: XrInstance,
                              _ createInfo: UnsafePointer<XrActionSetCreateInfo>?,
                              _ actionSet: UnsafeMutablePointer<XrActionSet>?) -> XrResult {
    print("xrCreateActionSet")
    guard let actionSetOut = actionSet else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    print("\(createInfo!.pointee.print_())")
    let actionSetNameStr = withUnsafeBytes(of: createInfo!.pointee.actionSetName) { rawBuffer -> String in
        let baseAddress = rawBuffer.baseAddress!.assumingMemoryBound(to: CChar.self)
        return String(cString: baseAddress)
    }
    let actionSet = ActionSet(name: actionSetNameStr, priority: Int(createInfo!.pointee.priority))
    actionSetOut.pointee = OpaquePointer(Unmanaged.passRetained(actionSet).toOpaque())
    return XR_SUCCESS
}

@_cdecl("xrDestroyActionSet")
public func xrDestroyActionSet(_ actionSet: XrActionSet) -> XrResult {
    print("xrDestroyActionSet")
//    let rawPtr = unsafeBitCast(actionSet, to: UnsafeMutableRawPointer.self)
//    rawPtr.deallocate()
    return XR_SUCCESS
}


extension XrSessionActionSetsAttachInfo {
    func print_() {
        print("XrSessionActionSetsAttachInfo:")
//        print("  countActionSets: \(countActionSets)")
        if countActionSets > 0, let actionSets = actionSets {
            print("  actionSets:")
            for i in 0..<Int(countActionSets) {
                print("    actionSet[\(i)]:")
                let actionSet = actionSets[i]!.getActionSet()
                actionSet!.print_()
            }
        } else {
            print("  actionSets: nil or empty")
        }
    }
}
extension Session {

}

@_cdecl("xrAttachSessionActionSets")
public func xrAttachSessionActionSets(_ xrsession: XrSession,
                                      _ attachInfo: UnsafePointer<XrSessionActionSetsAttachInfo>?) -> XrResult {
    print("xrAttachSessionActionSets")
    
    let session = xrsession.getSession()!
    for i in 0..<Int(attachInfo!.pointee.countActionSets) {
        let actionSet = attachInfo!.pointee.actionSets[i]!.getActionSet()!
        session.actionSets[actionSet.priority] = actionSet
    }
    session.print_()
    return XR_SUCCESS
}

extension XrActionCreateInfo {
    func print_() {
        let actionNameStr = withUnsafeBytes(of: actionName) { rawBuffer -> String in
            let baseAddress = rawBuffer.baseAddress!.assumingMemoryBound(to: CChar.self)
            return String(cString: baseAddress)
        }
        
        let localizedActionNameStr = withUnsafeBytes(of: localizedActionName) { rawBuffer -> String in
            let baseAddress = rawBuffer.baseAddress!.assumingMemoryBound(to: CChar.self)
            return String(cString: baseAddress)
        }
        
        print("XrActionCreateInfo:")
        print("  actionName: \(actionNameStr)")
        print("  localizedActionName: \(localizedActionNameStr)")
        print("  countSubactionPaths: \(countSubactionPaths)")
        
        if countSubactionPaths > 0, let subactionPaths = subactionPaths {
            print("  subactionPaths:")
            for i in 0..<Int(countSubactionPaths) {
                let pathValue = subactionPaths[i]
                let pathStr = xrPathToStringDictionary[pathValue] ?? "Unknown"
                print("    [\(i)]: \(pathValue) (\(pathStr))")
            }
        } else {
            print("  subactionPaths: nil or empty")
        }
    }
}

@_cdecl("xrCreateAction")
public func xrCreateAction(_ actionSet: XrActionSet,
                           _ createInfo: UnsafePointer<XrActionCreateInfo>?,
                           _ actionOut: UnsafeMutablePointer<XrAction>?) -> XrResult {
    print("xrCreateAction")
    guard let createInfo = createInfo?.pointee else {
        return XR_ERROR_RUNTIME_FAILURE
    }
//    createInfo.print_()
    
    let actionSet = actionSet.getActionSet()!
    
    let actionNameStr = withUnsafeBytes(of: createInfo.actionName) { rawBuffer -> String in
        let baseAddress = rawBuffer.baseAddress!.assumingMemoryBound(to: CChar.self)
        return String(cString: baseAddress)
    }
    
    var subpaths : [String] = []
    for i in 0..<Int(createInfo.countSubactionPaths) {
        let pathValue = createInfo.subactionPaths[i]
        let pathStr = xrPathToStringDictionary[pathValue] ?? "Unknown" // TODO probably should error
        subpaths.append(pathStr)
    }
    
    let action = Action(name: actionNameStr, subpaths: subpaths)
    
    actionSet.actions[actionNameStr] = action // TODO check if name exists
    
    actionSet.print_()
    
    actionOut!.pointee = OpaquePointer(Unmanaged.passRetained(action).toOpaque())
    return XR_SUCCESS
}

@_cdecl("xrDestroyAction")
public func xrDestroyAction(_ action: XrAction) -> XrResult {
    print("xrDestroyAction")
    // TODO
    return XR_SUCCESS
}

@_cdecl("xrSyncActions")
public func xrSyncActions(_ xrSession: XrSession, _ syncInfo: UnsafePointer<XrActionsSyncInfo>?) -> XrResult {
    print("xrSyncActions")
    let session = xrSession.getSession()!
//    syncInfo?.pointee.print_()
    // TODO more than one active action set
    let actionSet = syncInfo!.pointee.activeActionSets[0].actionSet.getActionSet()
    
    for (actionName, action) in actionSet!.actions {
        if actionName == "pickup" {
//            print("updating grasp \(action.subpaths)")
            action.subpaths["/user/hand/left"]!.value = session.handTrackers[XR_HAND_LEFT_EXT]!.grasp
            action.subpaths["/user/hand/right"]!.value = session.handTrackers[XR_HAND_RIGHT_EXT]!.grasp
        } else {
//            print("unknown action \(actionName)")
        }
    }
    return XR_SUCCESS
}

extension XrActionStateGetInfo {
    func print_() {
        print("XrActionStateGetInfo:")
        let act = action.getAction()!
        act.print_()
    }
}

@_cdecl("xrGetActionStateBoolean")
public func xrGetActionStateBoolean(_ session: XrSession,
                                    _ getInfo: UnsafePointer<XrActionStateGetInfo>?,
                                    _ state: UnsafeMutablePointer<XrActionStateBoolean>?) -> XrResult {
    guard let state = state else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    print("xrGetActionStateBoolean")
    getInfo?.pointee.print_()
    return XR_SUCCESS
}

@_cdecl("xrGetActionStateFloat")
public func xrGetActionStateFloat(_ session: XrSession,
                                  _ getInfo: UnsafePointer<XrActionStateGetInfo>?,
                                  _ state: UnsafeMutablePointer<XrActionStateFloat>?) -> XrResult {
    //    guard let state = state else {
    //        return XR_ERROR_FUNCTION_UNSUPPORTED
    //    }
//    print("xrGetActionStateFloat")
//    getInfo?.pointee.print_()
    // in:
    //    XrAction                    action;
    //    XrPath                      subactionPath;
    let action = getInfo!.pointee.action.getAction()
    let subpath = getInfo!.pointee.subactionPath
    state!.pointee.currentState = action!.subpaths[xrPathToStringDictionary[subpath]!]!.value
    state!.pointee.changedSinceLastSync = 1
    state!.pointee.isActive = 1
    state!.pointee.lastChangeTime // TODO
    
    print("xrGetActionStateFloat \(action!.name):\(xrPathToStringDictionary[subpath])=>\(state!.pointee.currentState)")
    // out:
    //    float                 currentState;
    //    XrBool32              changedSinceLastSync;
    //    XrTime                lastChangeTime;
    //    XrBool32              isActive;
    
    
    
    return XR_SUCCESS
}

@_cdecl("xrGetActionStateVector2f")
public func xrGetActionStateVector2f(_ session: XrSession,
                                     _ getInfo: UnsafePointer<XrActionStateGetInfo>?,
                                     _ state: UnsafeMutablePointer<XrActionStateVector2f>?) -> XrResult {
    guard let state = state else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    print("xrGetActionStateVector2f")
    getInfo?.pointee.print_()
    return XR_SUCCESS
}
extension XrActionsSyncInfo {
    func print_() {
        print("XrActionsSyncInfo:")
        if countActiveActionSets > 0, let activeActionSets = activeActionSets {
            for i in 0..<Int(countActiveActionSets) {
                let activeSet = activeActionSets[i]
                print("  ActiveActionSet[\(i)]: \(activeSet)")
                let subactionPath = activeSet.subactionPath
                let subactionPathStr = xrPathToStringDictionary[subactionPath] ?? "Unknown"
                print("    subactionPath: \(subactionPath) (\(subactionPathStr))")
            }
        } else {
            print("  activeActionSets: nil or empty")
        }
    }
}

extension XrActionSet {
    func getActionSet() -> ActionSet? {
        return unsafeBitCast(self, to: ActionSet?.self)
    }
}

extension XrAction {
    func getAction() -> Action? {
        return unsafeBitCast(self, to: Action?.self)
    }
}

@_cdecl("xrApplyHapticFeedback")
public func xrApplyHapticFeedback(_ session: XrSession,
                                  _ hapticActionInfo: UnsafePointer<XrHapticActionInfo>?,
                                  _ hapticFeedback: UnsafePointer<XrHapticBaseHeader>?) -> XrResult {
    return XR_SUCCESS
}

extension XrInteractionProfileState {
    func print_() {
        print("XrInteractionProfileState:")
        if let profileString = xrPathToStringDictionary[interactionProfile] {
            print("  interactionProfile: \(interactionProfile) (\(profileString))")
        } else {
            print("  interactionProfile: \(interactionProfile)")
        }
    }
}

@_cdecl("xrGetCurrentInteractionProfile")
public func xrGetCurrentInteractionProfile(_ session: XrSession,
                                           _ topLevelUserPath: XrPath,
                                           _ interactionProfile: UnsafeMutablePointer<XrInteractionProfileState>?) -> XrResult {
    // Check that the output pointer is valid.
    guard let interactionProfile = interactionProfile else {
        print("xrGetCurrentInteractionProfile: interactionProfile pointer is nil")
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    let defaultProfile: XrPath = xrStringToPathDictionary["/interaction_profiles/ext/hand_interaction_ext"]!
    
    // Fill in the interaction profile state.
    interactionProfile.pointee.type = XR_TYPE_INTERACTION_PROFILE_STATE
    interactionProfile.pointee.next = nil
    interactionProfile.pointee.interactionProfile = defaultProfile
    
    print("xrGetCurrentInteractionProfile: For topLevelUserPath \(xrPathToStringDictionary[topLevelUserPath]), returning interactionProfile \(defaultProfile)")
    
    return XR_SUCCESS
}
extension XrInteractionProfileSuggestedBinding {
    func print_() {
        print("XrInteractionProfileSuggestedBinding:")
        
        if let profileString = xrPathToStringDictionary[interactionProfile] {
            print("  interactionProfile: \(interactionProfile) (\(profileString))")
        } else {
            print("  interactionProfile: \(interactionProfile)")
        }
        
        if countSuggestedBindings > 0, let suggestedBindings = suggestedBindings {
            for i in 0..<Int(countSuggestedBindings) {
                let bindingEntry = suggestedBindings[i]
                print("  suggestedBindings[\(i)]:")
                
                let actionInstance = bindingEntry.action.getAction()!
                actionInstance.print_()
                
                let bindingPath = bindingEntry.binding
                let bindingPathStr = xrPathToStringDictionary[bindingPath] ?? "Unknown"
                print("    binding: \(bindingPath) (\(bindingPathStr))")
            }
        } else {
            print("  suggestedBindings: nil or empty")
        }
    }
}

@_cdecl("xrSuggestInteractionProfileBindings")
public func xrSuggestInteractionProfileBindings(_ instance: XrInstance,
                                                _ suggestedBindings: UnsafePointer<XrInteractionProfileSuggestedBinding>?) -> XrResult {
    print("xrSuggestInteractionProfileBindings called")
    suggestedBindings?.pointee.print_()
    // TODO we should store some of this?
    return XR_SUCCESS
}


// probs should be inside Instance but this was ezier
var xrStringToPathDictionary: [String: XrPath] = [:]
var xrPathToStringDictionary: [XrPath: String] = [:]
var xrCurrentPathValue: XrPath = UInt64(XR_NULL_PATH+1)

@_cdecl("xrStringToPath")
public func xrStringToPath(_ instance: XrInstance,
                           _ pathString: UnsafePointer<CChar>?,
                           _ path: UnsafeMutablePointer<XrPath>?) -> XrResult {
    guard let pathString = pathString, let pathOut = path else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    let str = String(cString: pathString)
    
    if let existingPath = xrStringToPathDictionary[str] {
        pathOut.pointee = existingPath
        return XR_SUCCESS
    }
    
    let newPath = xrCurrentPathValue
    xrCurrentPathValue += 1
    
    xrStringToPathDictionary[str] = newPath
    xrPathToStringDictionary[newPath] = str
    print("[xrStringToPath] Created new mapping: \"\(str)\" -> \(newPath)")
    
    pathOut.pointee = newPath
    return XR_SUCCESS
}

@_cdecl("xrPathToString")
public func xrPathToString(_ instance: XrInstance,
                           _ path: XrPath,
                           _ bufferCapacityInput: UInt32,
                           _ bufferCountOutput: UnsafeMutablePointer<UInt32>?,
                           _ buffer: UnsafeMutablePointer<CChar>?) -> XrResult {
    guard let str = xrPathToStringDictionary[path] else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    
    let requiredLength = UInt32(str.utf8.count + 1)
    bufferCountOutput?.pointee = requiredLength
    if bufferCapacityInput < requiredLength {
        print("[xrPathToString] Warning: Provided buffer capacity (\(bufferCapacityInput)) is less than required (\(requiredLength)).")
        return XR_ERROR_SIZE_INSUFFICIENT
    }
    
    if let buffer = buffer {
        str.withCString { cStr in
            strncpy(buffer, cStr, Int(bufferCapacityInput))
        }
    }
    
    return XR_SUCCESS
}

@_cdecl("xrCreateActionSpace")
public func xrCreateActionSpace(_ session: XrSession,
                                _ createInfo: UnsafePointer<XrActionSpaceCreateInfo>?,
                                _ space: UnsafeMutablePointer<XrSpace>?) -> XrResult {
    print("xrCreateActionSpace")
    guard let spaceOut = space else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
//    let dummySpacePtr = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<Int>.size,
//                                                         alignment: MemoryLayout<Int>.alignment)
//    dummySpacePtr.initializeMemory(as: Int.self, to: 128) // dummy value for action space
//    spaceOut.pointee = OpaquePointer(dummySpacePtr)
    return XR_SUCCESS
}


// MARK: spaces


@_cdecl("xrCreateReferenceSpace")
public func xrCreateReferenceSpace(_ session: XrSession,
                                   _ createInfo: UnsafePointer<XrReferenceSpaceCreateInfo>?,
                                   _ space: UnsafeMutablePointer<XrSpace>?) -> XrResult {
    print("xrCreateReferenceSpace")
    guard let spaceOut = space else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
//    let dummySpacePtr = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<Int>.size,
//                                                         alignment: MemoryLayout<Int>.alignment)
//    dummySpacePtr.initializeMemory(as: Int.self, to: 256) // dummy value for reference space
//    spaceOut.pointee = OpaquePointer(dummySpacePtr)
    return XR_SUCCESS
}

@_cdecl("xrDestroySpace")
public func xrDestroySpace(_ space: XrSpace) -> XrResult {
    print("xrDestroySpace")
//    let rawPtr = unsafeBitCast(space, to: UnsafeMutableRawPointer.self)
//    rawPtr.deallocate()
    return XR_SUCCESS
}


@_cdecl("xrEnumerateReferenceSpaces")
public func xrEnumerateReferenceSpaces(_ session: XrSession,
                                       _ referenceSpaceTypeCapacityInput: UInt32,
                                       _ referenceSpaceTypeCountOutput: UnsafeMutablePointer<UInt32>?,
                                       _ referenceSpaceTypes: UnsafeMutablePointer<XrReferenceSpaceType>?) -> XrResult {
    print("xrEnumerateReferenceSpaces")
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


// MARK: swapchains

class Swapchain {
    var textures: [MTLTexture]
    
    init(textures: [MTLTexture]) {
        self.textures = textures
    }
}

@_cdecl("xrEnumerateSwapchainFormats")
public func xrEnumerateSwapchainFormats(_ session: XrSession,
                                        _ formatCapacityInput: UInt32,
                                        _ formatCountOutput: UnsafeMutablePointer<UInt32>?,
                                        _ formats: UnsafeMutablePointer<Int64>?) -> XrResult {
    print("xrEnumerateSwapchainFormats called")
    let availableFormats: [Int64] = [
        Int64(MTLPixelFormat.rgba16Float.rawValue),
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
public func xrCreateSwapchain(_ xrSession: XrSession,
                              _ createInfo: UnsafePointer<XrSwapchainCreateInfo>?,
                              _ swapchain: UnsafeMutablePointer<XrSwapchain>?) -> XrResult {
    print("xrCreateSwapchain")
    guard let swapchainOut = swapchain, let ci = createInfo?.pointee else {
        return XR_ERROR_FUNCTION_UNSUPPORTED
    }
    let session = xrSession.getSession()!
    
    let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat(rawValue: UInt(ci.format))!,
                                                              width: Int(ci.width),
                                                              height: Int(ci.height),
                                                              mipmapped: false)
    // if we want this texture to get foveated rendering then the user has
    // to support not reading from the texture, so removing this would have to work
    // (current impl it doesnt work cause we read it to render rip)
    descriptor.usage = [.renderTarget,
                        .shaderRead,
                        .pixelFormatView]
    descriptor.textureType = .type2DArray
    
    if (createInfo!.pointee.usageFlags & XR_SWAPCHAIN_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT) != 0 {
        descriptor.resourceOptions = .storageModePrivate
    }
#if targetEnvironment(simulator)
    descriptor.arrayLength = 1
#else
    descriptor.arrayLength = 2 // TODO based on something
#endif
    
    // one swapchain texture for now
    var textures: [MTLTexture] = []
    if let texture = session.metalDevice.makeTexture(descriptor: descriptor) {
        textures.append(texture)
    }
    
    let swapchain = Swapchain(textures: textures)
    session.swapchain.append(swapchain)
    
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
    print("xrDestroySwapchain")
    
    return XR_SUCCESS
}


@_cdecl("xrAcquireSwapchainImage")
public func xrAcquireSwapchainImage(_ swapchain: XrSwapchain,
                                    _ acquireInfo: UnsafePointer<XrSwapchainImageAcquireInfo>?,
                                    _ index: UnsafeMutablePointer<UInt32>?) -> XrResult {
//    print("xrAcquireSwapchainImage")
    
    // an ask for a swapchain image, with output param index into ones allocated by enumerate,
    
    // godot metal extension does data->texture_rids[p_image_index]; where texture_rids has a reference
    // to whatever is returned from xrEnumerateSwapchainImages
    index?.pointee = 0
    return XR_SUCCESS
}

@_cdecl("xrReleaseSwapchainImage")
public func xrReleaseSwapchainImage(_ swapchain: XrSwapchain,
                                    _ releaseInfo: UnsafePointer<XrSwapchainImageReleaseInfo>?) -> XrResult {
//    print("xrReleaseSwapchainImage")
    
    return XR_SUCCESS
}

@_cdecl("xrWaitSwapchainImage")
public func xrWaitSwapchainImage(_ swapchain: XrSwapchain,
                                 _ waitInfo: UnsafePointer<XrSwapchainImageWaitInfo>?) -> XrResult {
//    print("xrWaitSwapchainImage")
    
    return XR_SUCCESS
}
