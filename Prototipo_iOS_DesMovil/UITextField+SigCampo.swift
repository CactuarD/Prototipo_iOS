//
//  UITextField+SigCampo.swift
//  Prototipo_iOS_DesMovil
//
//  Created by MacBookPro on 19/01/17.
//  Copyright © 2017 Integra IT. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extensiòn que implementa la funcion que permite avanzar al siguiente campo de texto al presionar el boton RETURN
private var kAssociationKeyNextField: UInt8 = 0

extension UITextField {
    var sigCampo: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
