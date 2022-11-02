//
//  CanvasViewModel.swift
//  swift-drawingapp
//
//  Created by taehyeon.lee on 2022/10/29.
//

import Foundation
import Combine

final class CanvasViewModel  {
    private weak var uiPort: DrawUIOutPort?
    private let useCase: DrawUseCase & TouchUseCase

    private var pictureViewModels: [any PictureViewModel] = []

    init(useCase: DrawUseCase & TouchUseCase) {
        self.useCase = useCase
    }

    func setUIPort(_ uiPort: DrawUIOutPort) {
        self.uiPort = uiPort
    }
}

// MARK: - DrawPresenterInPort
extension CanvasViewModel: DrawPresenterInPort {
    func drawRectangle(inside area: Area) {
        useCase.drawRectangle(inside: area)
    }

    func readyDrawingCanvas() {
        useCase.readyDrawingCanvas()
    }
}

// MARK: - DrawPresenterOutPort
extension CanvasViewModel: DrawPresenterOutPort {
    func drawRectangle(with rectangle: Rectangle) {
        let rectangleViewModel = RectangleViewModel(color: rectangle.color, points: rectangle.points, lineWidth: rectangle.lineWidth)
        pictureViewModels.append(rectangleViewModel)
        uiPort?.drawRectangle(with: rectangleViewModel)
    }
    func readyDrawingCanvas(with drawing: Drawing) {
        let drawingViewModel = DrawingViewModel.init(color: drawing.color, points: drawing.points, lineWidth: drawing.lineWidth)
        pictureViewModels.append(drawingViewModel)
        uiPort?.readyDrawingCanvas(with: drawingViewModel)
    }
}

// MARK: - TouchPresenterInPort
extension CanvasViewModel: TouchPresenterInPort {
    func touch(index: Int, coordinate: Point?) {
        useCase.touch(index: index, coordinate: coordinate)
    }
}

// MARK: - TouchPresenterOutPort
extension CanvasViewModel: TouchPresenterOutPort {
    func touch(index: Int, at location: Point?) {
        let pictureViewModel = pictureViewModels[index]
        pictureViewModel.selected(at: location)
    }
}
