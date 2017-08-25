//
//  atomics-fence.swift
//  Atomics
//
//  Created by Guillaume Lessard on 09/02/2017.
//  Copyright © 2017 Guillaume Lessard. All rights reserved.
//

import CAtomics

public func threadFence(order: MemoryOrder = .sequential)
{
  CAtomicsThreadFence(order)
}
