//
//  IndicatorType.swift
//  CustomLoadingBtnTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit
import MHLoadingButton

// 사용할 때 아래와 같이
// IndicatorType.getIndicator()

enum IndicatorType: String, CaseIterable {
    case sysDefault = "System Default"
    case material = "Material Design"
    case ballPulseSync = "Ball Pulse Sync"
    case ballSpinFade = "Ball Spin"
    case ballPulse = "Ball Pulse"
    case lineScalePulse = "Line Scale Pulse"
    case lineScale = "Line Scale"
    case ballBeat = "Ball Beat"
    case lineSpin = "Line Spin"
    
    // 색을 지정하고 싶을 때 함수를 만들어서 커스텀한다.
    func getIndicator(_ color: UIColor = UIColor.gray) -> UIView & IndicatorProtocol {
        switch self {
        case .sysDefault:
            let indicator = UIActivityIndicatorView()
            indicator.color = color
            return indicator
        case .material:
            return MaterialLoadingIndicator(color: color)
        case .ballPulseSync:
            return BallPulseSyncIndicator(color: color)
        case .ballSpinFade:
            return BallSpinFadeIndicator(color: color)
        case .lineScalePulse:
            return LineScalePulseIndicator(color: color)
        case .lineScale:
            return LineScaleIndicator(color: color)
        case .ballPulse:
            return BallPulseIndicator(color: color)
        case .ballBeat:
            return BallBeatIndicator(color: color)
        case .lineSpin:
            return LineSpinFadeLoader(color: color)
        }
    }
}

