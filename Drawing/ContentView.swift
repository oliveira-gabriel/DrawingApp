
import SwiftUI
import CoreData



struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Drawing.entity(), sortDescriptors: [])
    var drawings: FetchedResults<Drawing>
    
    
        
    var body: some View {
        NavigationView {
            VStack{
                
                List {
                    
                    ForEach(drawings) { drawing in
                        NavigationLink {
                            DrawingView(textValue: drawing.title ?? "Untitled Masterpiece", drawing: drawing)
                        } label: {
                            Text(drawing.title ?? "Untitled Masterpiece")
                        }
                    }
                    .onDelete(perform: deleteDrawings)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Drawing with my personalities")
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addDrawing) {
                            Label("Add Drawing", systemImage: "plus")
                        }
                    }
                }
            }
            
            
        }
    }

    private func addDrawing() {
        withAnimation {
            let newDrawing = Drawing(context: viewContext)
            newDrawing.title = "A true masterpiece"
            newDrawing.id = UUID()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteDrawings(offsets: IndexSet) {
        withAnimation {
            offsets.map { drawings[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let drawingFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct DrawingView: View {
    @Environment(\.managedObjectContext) var viewContext

    @State var textValue: String

    @State var drawing: Drawing
    
    var body: some View {
        VStack {
            TextField("Text",text: $textValue)
                .onChange(of: textValue, perform: { newValue in
                    let editedDrawing = drawing
                    editedDrawing.title = newValue

                    do {
                        try viewContext.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                })
                .font(.title.bold())
                .multilineTextAlignment(.center)
            
            
            Canvas(data: drawing.canvasData ?? Data(), id: drawing.id ?? UUID()).environment(\.managedObjectContext, viewContext)
        }
    }
}
