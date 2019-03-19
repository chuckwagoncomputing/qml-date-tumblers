import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.0

Rectangle {
	id: hourPicker

	height: 42
	width: parent.width

	property int indicatorHeight: 2
	property string indicatorColor: "#e91e63"
	property int hour
	property string textEntered

	signal submit()
	signal abort()

	activeFocusOnTab: true

	onActiveFocusChanged: {
		textEntered = ""
	}

	Tumbler {
		id: hourPickerTumbler
		height: parent.width
		width: parent.height - parent.indicatorHeight
		activeFocusOnTab: false
		transform: Rotation {
			angle: -90
			origin.x: hourPickerTumbler.width / 2
			origin.y: hourPickerTumbler.width / 2
		}
		model: 24
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
			var h = hourPickerTumbler.currentIndex
			if (hourPicker.hour != h) {
				hourPicker.hour = h
			}
		}
	}

	Rectangle	{
		id: hourPickerIndicator
		width: parent.width
		height: hourPicker.indicatorHeight
		color: parent.activeFocus ? parent.indicatorColor : parent.color
		anchors.bottom: parent.bottom
		activeFocusOnTab: false
	}

	onHourChanged: {
		if (hourPickerTumbler.currentIndex != hourPicker.hour) {
			hourPickerTumbler.currentIndex = hourPicker.hour
		}
	}

	Keys.onPressed: {
		if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
			event.accepted = true
			hourPicker.submit()
		}
		else if (event.key == Qt.Key_Escape) {
			event.accepted = true
			hourPicker.abort()
		}
		else if (event.text.replace(/[^A-Z0-9]/gi, "").length > 0) {
			var foundIndex = searchIndex(event.text)
			if (foundIndex > -1)	{
				hourPickerTumbler.currentIndex = foundIndex
			}
		}
	}

	// Search for Index. If nothing is found, starts over with the last entered key
	function searchIndex(t) {
		hourPicker.textEntered += t
		var foundIndex = findIndex(hourPicker.textEntered)
		if (foundIndex > -1) {
			return foundIndex
		}
		// If more than one key has been entered, take just the last one and try again
		else if (hourPicker.textEntered.length > t.length) {
			hourPicker.textEntered = ""
			return searchIndex(t)
		}
	}

	// return Index of the first item that contains the given string.
	function findIndex(t) {
		if (parseInt(t) < 24) {
			return parseInt(t)
		}
		return -1
	}
}
