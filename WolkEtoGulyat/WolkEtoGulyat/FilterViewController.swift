import UIKit
import SwiftUI


final class FilterViewController: UIHostingController<FilterView> {
		
		init() {
				super.init(rootView: FilterView())
		}
		
		@MainActor required dynamic init?(coder aDecoder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
}


struct FilterView: View {
		var body: some View {
				VStack {
						
				}
		}
}
