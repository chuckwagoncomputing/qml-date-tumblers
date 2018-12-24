import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.0

Rectangle {
	id: yearPicker

	height: 42
	width: parent.width

	property int indicatorHeight: 2
	property string indicatorColor: "#e91e63"
 property int year
	property string textEntered: ""
	property int startYear
	property int endYear

	signal submit()
	signal abort()

	activeFocusOnTab: true

	Tumbler {
		id: yearPickerTumbler
		height: parent.width
		width: parent.height - parent.indicatorHeight
		activeFocusOnTab: false
		transform: Rotation {
			angle: -90
			origin.x: yearPickerTumbler.width / 2
			origin.y: yearPickerTumbler.width / 2
		}
		model: getYears(parent.startYear, parent.endYear)
		delegate: Text {
			transform: Rotation {
				angle: 90
				origin.x: width / 2
				origin.y: width / 2
			}
			anchors.right: parent.horizontalCenter
			text: modelData
			opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
			font.pixelSize: 15 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 3
		}
		onCurrentIndexChanged: {
			var y = parseInt(yearPickerTumbler.currentItem.text)
		 if (yearPicker.year != y) {
				yearPicker.year = y
			}
		}
		function getYears(start, end) {
			var y = [];
   while (end >= start) {
    y.push(end--)
   }
			return y;
		}
	}

	Rectangle	{
		id: yearPickerIndicator
		width: parent.width
		height: parent.indicatorHeight
		color: parent.activeFocus ? parent.indicatorColor : parent.color
		anchors.bottom: parent.bottom
		activeFocusOnTab: false
	}

	onYearChanged: {
		var i =	yearPicker.findIndex(yearPicker.year)
		if (yearPickerTumbler.currentIndex != i) {
			yearPickerTumbler.currentIndex = i
		}
	}

	Keys.onPressed: {
		if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
			event.accepted = true
			yearPicker.submit()
		}
		else if (event.key == Qt.Key_Escape) {
			event.accepted = true
			yearPicker.abort()
		}
		else if (event.text.replace(/[^A-Z0-9]/gi, "").length > 0) {
			event.accepted = true
			var foundIndex = searchIndex(event.text)
			if (foundIndex > -1)	{
				yearPickerTumbler.currentIndex = foundIndex
			}
		}
	}

	// Search for Index. If nothing is found, starts over with the last entered key
	function searchIndex(t) {
		yearPicker.textEntered += t
		var foundIndex = findIndex(yearPicker.textEntered)
		if (foundIndex > -1) {
			return foundIndex
		}
		// If more than one key has been entered, take just the last one and try again
		else if (yearPicker.textEntered.length > t.length) {
			yearPicker.textEntered = ""
			return searchIndex(t)
		}
	}


	// return Index of the first item that contains the given string.
	function findIndex(t) {
	 for (var i = yearPicker.startYear; i <= yearPicker.endYear; i++) {
			if (("" + i).includes(t)) {
				return yearPicker.endYear - i
			}
		}
		return -1
	}
}
