import Foundation
import SwiftUI
import CoreData
import PencilKit

struct Canvas: UIViewControllerRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    
    func updateUIViewController(_ uiViewController: DrawingCanvasViewController,context: Context) { uiViewController.drawingData = data
    }
    
    typealias UIViewControllerType = DrawingCanvasViewController
    var data: Data
    var id: UUID
    
    func makeUIViewController(context: Context) -> DrawingCanvasViewController {
        let viewController = DrawingCanvasViewController()
        viewController.drawingData = data
        viewController.drawingChanged = { data in
            let request: NSFetchRequest<Drawing> = Drawing.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
            do {
                let result = try
                viewContext.fetch(request)
                let obj = result.first
                obj?.setValue(data, forKey: "canvasData")
                do {
                    try viewContext.save()
                    
                } catch { print(error) }
                
            }
            catch { print(error) }
            
        }
        return viewController
    }
}

class DrawingCanvasViewController: UIViewController {
    lazy var canvas: PKCanvasView = {
        let view = PKCanvasView()
        view.drawingPolicy = .anyInput
        view.minimumZoomScale = 1
        view.maximumZoomScale = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view    }()
    lazy var toolPicker: PKToolPicker = {
        let toolPicker = PKToolPicker()
        toolPicker.addObserver(self)
        return toolPicker    }()
    var drawingData = Data()
    var drawingChanged: (Data) -> Void = {_ in}
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvas)
        NSLayoutConstraint.activate([                                        canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),                                    canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),                                  canvas.topAnchor.constraint(equalTo: view.topAnchor),                                        canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.delegate = self
        canvas.becomeFirstResponder()
        if let drawing = try? PKDrawing(data: drawingData) {
            canvas.drawing = drawing
        }
    }
}

extension DrawingCanvasViewController: PKToolPickerObserver, PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {        drawingChanged(canvasView.drawing.dataRepresentation())
    }
}
