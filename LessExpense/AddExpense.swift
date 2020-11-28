//
//  AddExpense.swift
//  LessExpense
//
//  Created by Никита Галкин on 25.11.2020.
//

import SwiftUI


struct AddExpense: View {
	@Environment(\.presentationMode) var presentationMode
	@State private var name = ""
	@State private var type = "Personal"
	@State private var amount = ""
	static let typeChoice = ["Business", "Personal", "Home"]
	@ObservedObject var expenses: Expenses
	
    var body: some View {
		NavigationView{
			Form{
				TextField("Name", text: $name)
				Picker("Type", selection: $type){
					ForEach(Self.typeChoice, id:\.self){
						Text($0)
					}
				}
				TextField("Amount", text: $amount).keyboardType(.numberPad)
				
			}
			.navigationTitle(Text("Add New Expense"))
			.navigationBarItems(trailing:
									Button("Save"){
									 	let item = ExpenseItem(name: self.name, type: self.type, amount: Int(amount) ?? 0)
										self.expenses.add(item)
										self.presentationMode.wrappedValue.dismiss()
									}
			)
		}
    }
}

struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddExpense(expenses: Expenses())
    }
}
