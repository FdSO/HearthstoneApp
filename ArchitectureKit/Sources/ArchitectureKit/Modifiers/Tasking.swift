import SwiftUI

public typealias AsyncCompletion = @Sendable () async -> Void

fileprivate struct TaskModifier: ViewModifier {
    let priority: TaskPriority
    let action: AsyncCompletion
    
    @State var task: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if task != nil {
                    task?.cancel()
                }
                
                task = .init(
                    priority: priority, operation: action
                )
            }
            .onDisappear {
                task?.cancel()
                task = nil
            }
    }
}

public extension View {
    @available(iOS, deprecated: 15.0)
    func tasking(
        priority: TaskPriority = .userInitiated, _ action: @escaping AsyncCompletion
    ) -> some View {
        if #available(iOS 15, *) {
            return task(priority: priority, action)
        }
        
        return modifier(TaskModifier(priority: priority, action: action))
    }
}
