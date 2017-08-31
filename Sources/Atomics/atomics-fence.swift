//
//  atomics-fence.swift
//  Atomics
//
//  Created by Guillaume Lessard on 09/02/2017.
//  Copyright © 2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import CAtomics

public func threadFence(order: MemoryOrder = .sequential)
{
  CAtomicsThreadFence(order)
}
