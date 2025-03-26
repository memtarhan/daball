//
//  NetworkWrapper.swift
//  Daball
//
//  Created by Mehmet Tarhan on 26.03.2025.
//  Copyright © 2025 MEMTARHAN. All rights reserved.
//

import Foundation
import Networkable

class NetworkWrapper {
    private(set) var client: NetworkableClient

    init(client: NetworkableClient) {
        self.client = client
    }
}
