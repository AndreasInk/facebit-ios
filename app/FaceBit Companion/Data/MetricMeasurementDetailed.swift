//
//  MetricMeasurementInfo.swift
//  FaceBit Companion
//
//  Created by blaine on 3/17/21.
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

import Foundation
import GRDB


struct MetricMeasurementDetailed: FetchableRecord, MutablePersistableRecord, Codable, Identifiable {
    let metric: MetricMeasurement
    let event: Event?
    
    var id: Int64? { return metric.id }
    
    enum CodingKeys: String, CodingKey {
        case metric = "metric_measurement"
        case event = "event"
    }
}
