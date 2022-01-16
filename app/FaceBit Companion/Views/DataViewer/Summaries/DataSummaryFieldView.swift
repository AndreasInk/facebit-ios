//
//  DataSummaryFieldView.swift
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

import SwiftUI

struct DataSummaryFieldView: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text("\(title): ")
                .bold()
            Text(value)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.body)
        }
    }
}

struct DataSummaryFieldView_Previews: PreviewProvider {
    static var previews: some View {
        DataSummaryFieldView(title: "Title", value: "\(1.23)")
    }
}
