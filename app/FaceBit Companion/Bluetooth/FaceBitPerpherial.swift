//
//  Perpherial.swift
//  FaceBit Companion
//
//  Created by blaine on 1/14/21.
//

import Foundation
import CoreBluetooth
import Combine

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

enum PeripheralState: String {
    case notFound = "not found"
    case connected = "connected"
    case disconnected = "disconnected"
}

protocol Peripheral {
    var name: String { get }
    var mainServiceUUID: CBUUID { get }
    
    var peripheral: CBPeripheral? { get set }
    var state: PeripheralState { get }
    
    func didUpdateState()
}

class FaceBitPeripheral: NSObject, Peripheral, ObservableObject  {
    var mainServiceUUID = CBUUID(string: "6243FABC-23E9-4B79-BD30-1DC57B8005D6")
    var name = "SMARTPPE"
    
    @Published var state: PeripheralState = .notFound
    @Published var lastContact: Date?
    
    var publishRate: Int = 60
    
    var peripheral: CBPeripheral? {
        didSet {
            peripheral?.delegate = self
            didUpdateState()
        }
    }
    
    private let TemperatureCharacteristicUUID = CBUUID(string: "0F1F34A3-4567-484C-ACA2-CC8F662E8782")
    private let PressureCharacteristicUUID = CBUUID(string: "0F1F34A3-4567-484C-ACA2-CC8F662E8781")
    private let IsDataReadyCharacteristicUUID = CBUUID(string: "0F1F34A3-4567-484C-ACA2-CC8F662E8783")
    
    private var currentEvent: SmartPPEEvent?
    private var readStart: Date?
    
    
    required override init() {
        super.init()
    }
    
    func didUpdateState() {
        guard let peripheral = self.peripheral else { state = .notFound; return }
        switch peripheral.state {
        case .connected:
            state = .connected
            lastContact = Date()
            BLELogger.info("Connected")
            peripheral.discoverServices([mainServiceUUID])
        case .connecting, .disconnected, .disconnecting:
            state = .disconnected
        @unknown default:
            state = .notFound
        }
    }
    
    func setEvent(_ event: SmartPPEEvent?=nil) {
        self.currentEvent = event
    }
}

extension FaceBitPeripheral: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            print(service)
            peripheral.discoverCharacteristics([TemperatureCharacteristicUUID, PressureCharacteristicUUID, IsDataReadyCharacteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            // print(characteristic)
            if characteristic.properties.contains(.notify) {
                readStart = nil
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case TemperatureCharacteristicUUID, PressureCharacteristicUUID:
            if let value = characteristic.value {
                recordTimeSeriesData(value, uuid: characteristic.uuid)
            }
            
        case IsDataReadyCharacteristicUUID:
            if let value = characteristic.value, let raw = UInt64(value.hexEncodedString(), radix: 16) {
                if raw == 1 {
                    if readStart == nil {
                        readStart = Date()
                    }
                    if let characteristics = peripheral.services?.first(where: { $0.uuid == self.mainServiceUUID })?.characteristics {
                        for characteristic in characteristics {
                            if characteristic.properties.contains(.read) {
                                peripheral.readValue(for: characteristic)
                            }
                        }
                    }
                }
            }
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    func recordTimeSeriesData(_ value: Data, uuid: CBUUID) {
        let bytes = [UInt8](value)
        var values: [UInt16] = []
        
        let millisecondBytes = Array(bytes[0..<8])
        var millisecondOffset: UInt64 = 0
        for byte in millisecondBytes.reversed() {
            millisecondOffset = millisecondOffset << 8
            millisecondOffset = millisecondOffset | UInt64(byte)
        }
        
        let freqBytes = Array(bytes[8..<12])
        var freqRaw: UInt32 = 0
        for byte in freqBytes.reversed() {
            freqRaw = freqRaw << 8
            freqRaw = freqRaw | UInt32(byte)
        }
        let freq: Double = Double(freqRaw) / 100.0
        
        let numSamples = Int(bytes[12])
        
        let payload = Array(bytes[13..<13+(numSamples*2)])

        for i in stride(from: 0, to: payload.count, by: 2) {
            values.append((UInt16(payload[i]) << 8 | UInt16(payload[i+1])))
        }
        
        let start = readStart?.addingTimeInterval(Double(millisecondOffset) / 1000.0) ?? Date()
        let period: Double = 1.0 / Double(freq)
        
        var measurements: [TimeSeriesMeasurement] = []

        for (i, rawVal) in values.reversed().enumerated() {
            
            var valType: TimeSeriesMeasurement.DataType
            var val: Double
            
            if uuid == self.TemperatureCharacteristicUUID {
                valType = .temperature
                val = Double(rawVal) / 10.0
            } else if uuid == self.PressureCharacteristicUUID {
                valType = .pressure
                val = (Double(rawVal) + 80000) / 100
            } else {
                valType = .none
                val = Double(rawVal)
            }
            
            let measurement = TimeSeriesMeasurement(
                value: val,
                date: start.addingTimeInterval(-(period*Double(i))),
                type: valType,
                event: nil
            )
            measurements.append(measurement)
        }
        
//        print("\(uuid == self.TemperatureCharacteristicUUID ? "temp" : "pressure")")
//        print("inserting: \(measurements.count) records")
//
//        let startDate = SQLiteDatabase.dateFormatter.string(from: measurements.max(by: { $0.date > $1.date })!.date)
//        print("startDate: \(startDate) records")
//
//        let endDate = SQLiteDatabase.dateFormatter.string(from: measurements.min(by: { $0.date > $1.date })!.date)
//        print("endDate: \(endDate) records")
//        print()
        BLELogger.info("Inserting \(measurements.count) records. Freq: \(period)")
        SQLiteDatabase.main?.executeSQL(sql: measurements.insertSQL())
    }
}
