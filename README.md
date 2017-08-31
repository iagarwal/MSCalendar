# MSCalendar

This calendar app uses Page control to show month view.

-Turn Left to right for next month.

-Turn Right to Left for previous month.

-Scroll to top for expanding Agenda list.

-Click on minimize button [down arrow] to expand month view.

-Select a date in month view to see event in Agenda List.

-Weather information is shown when agenda list is expanded on scroll &  month view is minimized to have space in right corner.

NOTE : Reading events from dummyEventData.plist for static data

MSCalendarViewController - Home controller which has AgendaList table & Month view page controller.

 MSMonthViewController - Page container to show month view & pan gesure to navigate months in year.
 
 MSMonthContentViewController - Collection view to show month data in Month View which can be expanded on minimized on agenda list scroll.
 
 
 ViewModels:
 MSMonthViewModel : Provides data to Month view with pagination.
 
 MSAgendaViewModel - Provides data to Agenda View which is infinite scroll.
 
 MSCalendarSourceModel - Interacts with MSMonthViewModel & MSAgendaViewModel .Delegate events between both view models.
 
- Using Forcast API for showing weather info of current location.
 
