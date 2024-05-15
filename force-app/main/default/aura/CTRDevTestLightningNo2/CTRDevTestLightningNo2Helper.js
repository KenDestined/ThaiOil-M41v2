({
	fireEventChangeValuewithAPI : function(component) 
  {
    if(component.get('v.fieldApi'))
    {
      var compEvents = component.getEvent("OnChangePicklist");
      compEvents.setParams({ "Index" : component.get('v.Index'),
                                "Label" : component.get('v.fieldLabel'),
                                "Api" : component.get('v.fieldApi'),
                                "Value" : component.get('v.selectedValue')
                               });
          compEvents.fire();
		  console.log('fieldLabel :'+component.get('v.fieldLabel'));
		  console.log('fieldApi :'+component.get('v.fieldApi'));
		  console.log('selectedValue :'+component.get('v.selectedValue'));
    }

  }
})