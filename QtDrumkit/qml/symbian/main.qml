import QtQuick 1.0
import com.nokia.symbian 1.0
import DrumEngine 1.0

import "../common"

// Main screen for Symbian^3 devices with 640x360 resolution, 
// eg. N8, E7.
Item {
    // This property is used to find the graphics in all components.
    property string gfxPath:  "../symbian/gfx/"

    width: 640
    height: 360

    // DrumEngine instance for sample playing and drum track recording and playback.
    DrumEngine {
        id: engine
    }

    // UI components

    // This flipable contains the 2d and 3d drum pad views.

    Flipable {
        id: flipable
        anchors.fill:  parent

        property bool flipped: false

        front: Pads2d {}
        back: Pads3d {
            // Mirror the back side so that after flipping the orientation ends up straight.
            transform: Rotation {
                origin.x: flipable.width/2
                origin.y: flipable.height/2
                axis.x: 0; axis.y: 1; axis.z: 0
                angle: 180
            }
        }

        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis.x: 0; axis.y: 1; axis.z: 0
            angle: 0
        }

        states: State {
            PropertyChanges { target: rotation; angle: 180 }
            when: flipable.flipped
        }

        transitions: Transition {
            PropertyAnimation { target: rotation; property: "angle"; duration: 1000; easing.type: Easing.OutBack }
        }
    }

    // Buttons

    Button {
        id: infoButton
        anchors.top:  parent.top
        anchors.left:  parent.left
        image: "info.png"
        imagePressed: "info_pressed.png"
        onPressed: info.show = true
    }

    Button {
        id: padButton
        anchors.top:  infoButton.bottom
        anchors.left:  parent.left
        image: flipable.flipped ? "pads.png" : "drumset.png"
        imagePressed: flipable.flipped ? "pads_pressed.png" : "drumset_pressed.png"
        onPressed: flipable.flipped = !flipable.flipped
    }

    // Play and recording related buttons are placed according to the background
    // graphics, which is either the 2d or the 3d one.

    Button {
        anchors.top:  parent.top
        x: flipable.flipped ? 270*0.75 : 310*0.75
        id: recButton
        image: "record.png"
        imagePressed: "record_pressed.png"
        enabled: engine.canRecord && !engine.isPlaying
        toggled: engine.isRecording
        visible: !engine.isRecording
        onReleased: engine.record()
        Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
    }

    AnimButton {
        anchors.centerIn: recButton
        animation: "recording.png"
        imagePressed: "record_pressed.png"
        frameCount: 18
        width: 77
        height: 77
        visible: !recButton.visible
        onReleased: engine.stop()
        Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
    }

    Button {
        anchors.top:  parent.top
        x: flipable.flipped ? 445*0.75 : 460*0.75
        id: playButton
        image: "play.png"
        imagePressed: "play_pressed.png"
        enabled: engine.canPlay && !engine.isRecording
        toggled: engine.isPlaying
        visible: !engine.isPlaying
        onReleased: engine.play()
        Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
    }
    Button {
        id: stopButton
        anchors.centerIn:  playButton
        image: "stop.png"
        imagePressed: "stop_pressed.png"
        visible: !playButton.visible
        onReleased: engine.stop()
        Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
    }


    Button {
        id: exitButton
        anchors.top:  parent.top
        anchors.right:  parent.right
        image: "exit.png"
        imagePressed: "exit_pressed.png"
        onReleased: Qt.quit()
    }

    // Volume slider

    Slider {
        anchors {
            horizontalCenter: padButton.horizontalCenter
            top: padButton.bottom
        }
        minimumValue: 1
        maximumValue: 10
        value: 5
        stepSize: 1
        valueIndicatorVisible: false
        inverted: true
        orientation: Qt.Vertical
        onValueChanged: engine.setVolume(value)
    }

    // These components will be drawn over the view when they are activated.

    InstrumentSelector {
        id: selector
        anchors.fill: parent
        radius: parent.height * 0.4
        show: false
        onSelected: show = false
    }

    Info {
        id: info
        anchors.fill: parent
        textPointSize: 8
        show: true
    }
}

