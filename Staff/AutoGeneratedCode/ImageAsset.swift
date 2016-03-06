// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

extension UIImage {
  enum Asset : String {
    case Annular_button_wrapper = "annular_button_wrapper"
    case Annular_progress_background = "annular_progress_background"
    case Biaopen = "biaopen"
    case Button_shadow = "button_shadow"
    case Clock_marker = "clock_marker"
    case Clock_marker_shadow = "clock_marker_shadow"
    case Ic_sun = "ic_sun"
    case Oval_button_bg = "oval_button_bg"
    case Oval_button_pressed = "oval_button_pressed"

    var image: UIImage {
      return UIImage(asset: self)
    }
  }

  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}

