//
//  ContentView.swift
//  LessExpense
//
//  Created by Никита Галкин on 10.11.2020.
//

import SwiftUI

public struct ExpenseItem: Identifiable, Codable {
	public var id = UUID()
	let name: String
	let type: String
	let amount: Int
}

public class Expenses: ObservableObject {
	
	@Published var items = [ExpenseItem](){
		didSet {
			let encoder = JSONEncoder()
			
			if let encoded = try? encoder.encode(items){
				UserDefaults.standard.set(encoded, forKey: "Items")
			}
		}
	}
	init(){
		if let data = UserDefaults.standard.data(forKey: "Items"){
			let decoder = JSONDecoder()
			
			if let decoded = try? decoder.decode([ExpenseItem].self, from: data){
				self.items = decoded
				return
			}
			
		}
		self.items = []
	}
	func add(_ newElement: ExpenseItem){
		items.append(newElement)
	}
}


struct ContentView: View {
	@ObservedObject public var expenses = Expenses()
	@State public var addExpenseIsShown = false
    var body: some View {
		NavigationView{
			List{
				ForEach(expenses.items, id: \.name){item in
					HStack{
						VStack(alignment: .leading) {
							Text(item.name).font(.headline)
							Text(item.type)
							
						}
						Spacer()
						VStack(alignment: .trailing){
							Text("\(String(item.amount))₽").font(.title3)
						}
					}
					
				}
				.onDelete(perform: removeItems)
			}.navigationTitle(Text(verbatim: "LessExpense"))
			.navigationBarItems(trailing:
									Button(action:{
										addExpenseIsShown = true
									}) {
										Image(systemName: "plus")
			})
			.sheet(isPresented: $addExpenseIsShown) {
				AddExpense(expenses: self.expenses)
			}
		}
		
	}
	func removeItems(at offsets: IndexSet){
		expenses.items.remove(atOffsets: offsets)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.previewDevice("iPhone SE (2nd generation)")
    }
}
