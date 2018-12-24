# qml-date-tumblers
QML horizontal date and time tumblers, with keyboard support

## Usage

### Common to All
#### Properties
indicatorColor - The color of the keyboard active focus indicator
indicatorHeight - The vertical thickness of the keyboard active focus indicator
#### Signals
onSubmit - Emitted if the user presses return on their keyboard
onAbort - Emitted if the user presses Esc on their keyboard

### YearPicker
#### Properties
startYear - The first year to list
endYear - The end year to list
year - The currently selected year. This can be set externally.

### MonthPicker
#### Properties
month - The currently selected month. This can be set externally.

### DayPicker
#### Properties
daysInMonth - The number of days to show.
day - The currently selected month. This can be set externally.

### HourPicker
#### Properties
hour - The currently selected hour. This can be set externally.

### MinutePicker
#### Properties
minute - The currently selected minute. This can be set externally.


## Example
```qml
YearPicker {
	id: yearPicker
	anchors.top: parent.top
	endYear: (new Date()).getFullYear()
	startYear: endYear - 10
	onSubmit: {
		dateTimePage.forward()
	}
	onAbort: {
		stack.pop()
	}
	Component.onCompleted: {
		if (currentJob.date)	{
			yearPicker.year = (new Date(currentJob.date)).getFullYear()
		}
		else {
			yearPicker.year = (new Date).getFullYear()
		}
	}
}

MonthPicker {
	id: monthPicker
	anchors.top: yearPicker.bottom
	onSubmit: {
		dateTimePage.forward()
	}
	onAbort: {
		stack.pop()
	}
	Component.onCompleted: {
		if (currentJob.date)	{
			monthPicker.month = (new Date(currentJob.date)).getMonth()
		}
		else {
			monthPicker.month = (new Date).getMonth()
		}
	}
}

DayPicker {
	id: dayPicker
	anchors.top: monthPicker.bottom
	daysInMonth: (new Date(yearPicker.year, monthPicker.month + 1, 0)).getDate()
	onSubmit: {
		dateTimePage.forward()
	}
	onAbort: {
		stack.pop()
	}
	Component.onCompleted: {
		if (currentJob.date)	{
			dayPicker.day = (new Date(currentJob.date)).getDate()
		}
		else {
			dayPicker.day = (new Date).getDate()
		}
	}
}

HourPicker {
	id: hourPicker
	anchors.top: dayPicker.bottom
	onSubmit: {
		dateTimePage.forward()
	}
	onAbort: {
		stack.pop()
	}
	Component.onCompleted: {
		if (currentJob.date)	{
			hourPicker.hour = (new Date(currentJob.date)).getHours()
		}
		else {
			hourPicker.hour = (new Date).getHours()
		}
	}
}

MinutePicker {
	id: minutePicker
	anchors.top: hourPicker.bottom
	onSubmit: {
		dateTimePage.forward()
	}
	onAbort: {
		stack.pop()
	}
	Component.onCompleted: {
		if (currentJob.date)	{
			minutePicker.minute = (new Date(currentJob.date)).getMinutes()
		}
		else {
			minutePicker.minute = (new Date).getMinutes()
		}
	}
}
```
