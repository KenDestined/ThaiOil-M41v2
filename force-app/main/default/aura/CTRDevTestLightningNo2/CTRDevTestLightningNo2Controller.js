({
	doInit: function (component, event, helper) 
	{
		if(component.get('v.selectedValue'))
		{
			component.set("v.currentText", component.get('v.selectedValue'));
		}
	},
	//when clicking on field
	getPickListValues : function(component, event, helper) 
	{
		var newList=[];
		var list = component.get('v.picklistOptions');
		//const list = ['Apples','Apricots','Avocados','Bananas','Blueberries','Cherries','Grapefruit','Jackfruit','Kiwi','Lime','Mango','Oranges','Peach','Raspberries','Tomato','Watermelon'];
		//component.set("v.picklistValues", list);

		var resultBox = component.find('resultBox');
		if(component.get("v.currentText")) 
		{
			for(var i=0;i<list.length;i++)
			{
				var iterator= list[i].label;
				if(iterator.toLowerCase().includes(component.get("v.currentText").toLowerCase()))
				{
					newList.push(list[i]);
				}
			}
			component.set("v.picklistValues", newList);
			
			if(component.get("v.picklistValues").length == 0) 
			{
				$A.util.removeClass(resultBox, 'slds-is-open');
			}
			else
			{
				$A.util.addClass(resultBox, 'slds-is-open');
			}
		}
		else
		{
			for(var i=0;i<list.length;i++)
			{
				var iterator= list[i].label;
				newList.push(list[i]);
			}
			component.set("v.picklistValues", newList);
			$A.util.addClass(resultBox, 'slds-is-open');
		}
	},

	// When user types the value in field
	searchField : function(component, event, helper) {
		var list = component.get('v.picklistOptions');
		//const list = ['Apples','Apricots','Avocados','Bananas','Blueberries','Cherries','Grapefruit','Jackfruit','Kiwi','Lime','Mango','Oranges','Peach','Raspberries','Tomato','Watermelon'];
		//component.set("v.picklistValues", list);
		var resultBox = component.find('resultBox');
		var currentText =event.getSource().get("v.value");
		component.set("v.currentText", currentText);
		component.set("v.selectedValue", currentText);
		helper.fireEventChangeValuewithAPI(component);
		var newList=[];
		if(currentText.length > 0) 
		{
			for(var i=0;i<list.length;i++)
			{
				var iterator= list[i].label;
				if(iterator.toLowerCase().includes(currentText.toLowerCase()))
				{
					newList.push(list[i]);
				}
			}
			component.set("v.picklistValues", newList);
			
			if(component.get("v.picklistValues").length == 0) 
			{
				$A.util.removeClass(resultBox, 'slds-is-open');
			}
			else
			{
				$A.util.addClass(resultBox, 'slds-is-open');
			}
		}
		else 
		{
			$A.util.addClass(resultBox, 'slds-is-open');
		}
	},

	//When user selects a record, set it as selected
	setSelectedRecord : function(component, event, helper) 
	{
		component.set("v.currentText", event.currentTarget.dataset.name);
		component.set("v.selectedValue", event.currentTarget.dataset.value);
		helper.fireEventChangeValuewithAPI(component);
		var resultBox = component.find('resultBox');
		$A.util.removeClass(resultBox, 'slds-is-open');
	}, 

	//Function when user clicks outside Component to close the dropdown list
	closeDropDown : function(component, event, helper) 
	{
		var resultBox = component.find('resultBox');
		$A.util.removeClass(resultBox, 'slds-is-open');
	},
})