//
//  OWNetworkProtocol.h
//  OWRuntimeData
//
//  Created by Rango on 2019/2/18.
//  Copyright © 2019 Rango. All rights reserved.
//

#ifndef OWNetworkProtocol_h
#define OWNetworkProtocol_h

@protocol OWNetworkHandlerProtocol <NSObject>

@required
- (id)fetch;

@end

#endif /* OWNetworkProtocol_h */
