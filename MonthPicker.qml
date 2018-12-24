import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.0

Rectangle {
	id: monthPicker

	height: 42
	width: parent.width

	property int indicatorHeight: 2
	property string indicatorColor: "#e91e63"
	property int month
	property string textEntered

	signal submit()
	signal abort()

	activeFocusOnTab: true

	ListModel {
		id: monthModel
		ListElement {
			month: "Jan"
			days: 31
		}
		ListElement {
			month: "Feb"
			days: 28
		}
		ListElement {
			month: "Mar"
			days: 31
		}
		ListElement {
			month: "Apr"
			days: 30
		}
		ListElement {
			month: "May"
			days: 31
		}
		ListElement {
			month: "Jun"
			days: 30
		}
		ListElement {
			month: "Jul"
			days: 31
		}
		ListElement {
			month: "Aug"
			days: 31
		}
		ListElement {
			month: "Sep"
			days: 30
		}
		ListElement {
			month: "Oct"
			days: 31
		}
		ListElement {
			month: "Nov"
			days: 30
		}
		ListElement {
			month: "Dec"
			days: 31
		}
	}

	Tumbler {
		id: monthPickerTumbler
		height: parent.width
		width: parent.height - parent.indicatorHeight
		activeFocusOnTab: false
		transform: Rotation {
			angle: -90
			origin.x: monthPickerTumbler.width / 2
			origin.y: monthPickerTumbler.width / 2
		}
		model: monthModel
		delegate: Text {
			transform: Rotation {
				angle: 90
				origin.x: width / 2
				origin.y: width / 2
			}
			anchors.right: parent.horizontalCenter
			text: month
			opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
			font.pixelSize: 15 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 3
		}
		onCurrentIndexChanged: {
			var m = monthPickerTumbler.currentIndex
			if (monthPicker.month != m) {
				monthPicker.month = m
			}
		}
	}
	Rectangle	{
		id: monthPickerIndicator
		width: parent.width
		height: parent.indicatorHeight
		color: parent.activeFocus ? parent.indicatorColor : parent.color
		anchors.bottom: parent.bottom
		activeFocusOnTab: false
	}

	onMonthChanged: {
		if (monthPickerTumbler.currentIndex != monthPicker.month) {
			monthPickerTumbler.currentIndex = monthPicker.month
		}
	}

	Keys.onPressed: {
		if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
			event.accepted = true
			monthPicker.submit()
		}
		else if (event.key == Qt.Key_Escape) {
			event.accepted = true
			monthPicker.abort()
		}
		else if (event.text.replace(/[^A-Z0-9]/gi, "").length > 0) {
			var foundIndex = searchIndex(event.text)
			if (foundIndex > -1)	{
				monthPickerTumbler.currentIndex = foundIndex
			}
		}
	}

	// Search for Index. If nothing is found, starts over with the last entered key
	function searchIndex(t) {
		monthPicker.textEntered += t
		var foundIndex = findIndex(monthPicker.textEntered)
		if (foundIndex > -1) {
			return foundIndex
		}
		// If more than one key has been entered, take just the last one and try again
		else if (monthPicker.textEntered.length > t.length) {
			monthPicker.textEntered = ""
			return searchIndex(t)
		}
	}

	// return Index of the first item that contains the given string.
	function findIndex(t) {
		for (var i = 0; i < monthModel.count; i++) {
			if (monthModel.get(i).month.toLowerCase().startsWith(monthPicker.textEntered.toLowerCase())) {
				return i
			}
			else if (parseInt(monthPicker.textEntered) > 0 && parseInt(monthPicker.textEntered) < 13) {
				return parseInt(monthPicker.textEntered) - 1
			}
		}
		return -1
	}
}
