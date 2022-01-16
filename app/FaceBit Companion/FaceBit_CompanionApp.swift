//
//  FaceBit_CompanionApp.swift
//  FaceBit Companion
//
//  Created by blaine on 1/12/21.
//
//  @copyright Copyright (c) 2022 Ka Moamoa
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3 of the license.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import GRDB

@main
struct FaceBit_CompanionApp: App {
    let facebit = FaceBitPeripheral(readChars: [
        TemperatureCharacteristic(),
        PressureCharacteristic(),
        RespiratoryRateCharacteristic(),
        HeartRateCharacteristic(),
        MaskOnOffCharacteristic()
    ])
        
    let appDatabase = AppDatabase.shared
    let maskVM: MaskViewModel = MaskViewModel(db: AppDatabase.shared)
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(facebit)
                .environmentObject(maskVM)
        }
    }
}
