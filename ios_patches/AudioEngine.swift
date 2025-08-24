import AVFoundation; import Flutter
class HBAudioEngine: NSObject, FlutterStreamHandler {
  let engine = AVAudioEngine(); var sink: FlutterEventSink?
  func start(sampleRate:Int, bufferSize:Int, ready:@escaping ([Int16])->Void){
    let session = AVAudioSession.sharedInstance()
    try? session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
    try? session.setPreferredSampleRate(Double(sampleRate)); try? session.setActive(true, options: [])
    let input = engine.inputNode
    let format = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: Double(sampleRate), channels: 1, interleaved: true)!
    input.removeTap(onBus: 0)
    input.installTap(onBus: 0, bufferSize: AVAudioFrameCount(bufferSize), format: format) { buffer, _ in
      let ch = buffer.int16ChannelData![0]; let count = Int(buffer.frameLength); var arr=[Int16](repeating:0,count:count)
      for i in 0..<count { arr[i]=ch[i] }; self.sink?(arr)
    }
    engine.prepare(); try? engine.start(); ready([])
  }
  func stop(){ engine.stop(); engine.inputNode.removeTap(onBus: 0) }
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? { sink=events; return nil }
  func onCancel(withArguments arguments: Any?) -> FlutterError? { sink=nil; return nil }
}
