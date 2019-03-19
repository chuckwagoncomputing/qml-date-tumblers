import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.0

Rectangle {
	id: dayPicker

	height: 42
	width: parent.width

	property int indicatorHeight: 2
	property string indicatorColor: "#e91e63"
	property int day
	property string textEntered
	property int daysInMonth

	signal submit()
	signal abort()

	activeFocusOnTab: true

	onActiveFocusChanged: {
		textEntered = ""
	}

	Tumbler {
		id: dayPickerTumbler
		height: parent.width
		width: parent.height - parent.indicatorHeight
		activeFocusOnTab: false
		transform: Rotation {
			angle: -90
			origin.x: dayPickerTumbler.width / 2
			origin.y: dayPickerTumbler.width / 2
		}
		model: dayPicker.daysInMonth
		delegate: Text {
			transform: Rotation {
				angle: 90
				origin.x: width / 2
				origin.y: width / 2
			}
			anchors.right: parent.horizontalCenter
			text: modelData + 1
			opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
			font.pixelSize: 15 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 3
		}
		onCurrentIndexChanged: {
			var d = dayPickerTumbler.currentIndex + 1
			if (dayPicker.day != d) {
				dayPicker.day = d
			}
		}
	}
	Rectangle	{
		id: dayPickerIndicator
		width: parent.width
		height: dayPicker.indicatorHeight
		color: parent.activeFocus ? parent.indicatorColor : parent.color
		anchors.bottom: parent.bottom
		activeFocusOnTab: false
	}

	onDaysInMonthChanged: {
		var i = dayPickerTumbler.currentIndex
		dayPickerTumbler.model = dayPicker.daysInMonth
		// Restore the index after changing the model reset it.
		dayPickerTumbler.currentIndex = Math.min(i, daysInMonth - 1)
	}
	onDayChanged: {
		if (dayPickerTumbler.currentIndex != dayPicker.day - 1) {
			dayPickerTumbler.currentIndex = dayPicker.day - 1
		}
	}

	Keys.onPressed: {
		if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
			event.accepted = true
			dayPicker.submit()
		}
		else if (event.key == Qt.Key_Escape) {
			event.accepted = true
			dayPicker.abort()
		}
		else if (event.text.replace(/[^A-Z0-9]/gi, "").length > 0) {
			var foundIndex = searchIndex(event.text)
			if (foundIndex > -1)	{
				dayPickerTumbler.currentIndex = foundIndex
			}
		}
	}

	// Search for Index. If nothing is found, starts over with the last entered key
	function searchIndex(t) {
		dayPicker.textEntered += t
		var foundIndex = findIndex(dayPicker.textEntered)
		if (foundIndex > -1) {
			return foundIndex
		}
		// If more than one key has been entered, take just the last one and try again
		else if (dayPicker.textEntered.length > t.length) {
			dayPicker.textEntered = ""
			return searchIndex(t)
		}
	}

	// return Index of the first item that contains the given string.
	function findIndex(t) {
		if (parseInt(t) <= dayPicker.daysInMonth) {
			return parseInt(t) - 1
		}
		return -1
	}
}
