//
//  W3WTheme+.swift
//
//
//  Created by Dave Duprey on 16/01/2025.
//

import W3WSwiftThemes



public extension W3WTheme {
  
  func mapScheme() -> W3WScheme {
    
    return W3WScheme(
      colors: W3WColors(    
        foreground: labelsPrimary,
        background: fillsSecondary,
        tint:       brandBase,
        secondary:  separatorNonOpaque,
        line:       labelsQuaternary
      ),
      styles: W3WStyles()
    )
    
  }
  
}
