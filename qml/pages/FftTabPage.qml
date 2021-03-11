import QtQuick 2.0
import GlobalConfig 1.0
import QtQuick.Controls 2.4
import ZeraTranslation  1.0
import ModuleIntrospection 1.0
import "qrc:/qml/controls/fft_module" as Pages
import "qrc:/qml/pages" as Osc

Item {
    id: root
    readonly property bool hasFft: ModuleIntrospection.hasDependentEntities(["FFTModule1"])
    readonly property bool hasOsci: ModuleIntrospection.hasDependentEntities(["OSCIModule1"])

    SwipeView {
        id: swipeView
        anchors.fill: parent
        anchors.topMargin: harmonicsTabsBar.height
        currentIndex: harmonicsTabsBar.currentIndex
        spacing: 20
    }

    TabBar {
        id: harmonicsTabsBar
        width: parent.width
        contentHeight: 32
        anchors.top: parent.top
        currentIndex: swipeView.currentIndex
        onCurrentIndexChanged: GC.setLastTabSelected(currentIndex)
    }

    // TabButtons
    Component {
        id: tabChart
        TabButton {
            text: Z.tr("Harmonic table")
        }
    }
    Component {
        id: tabEnergy
        TabButton {
            text: Z.tr("Harmonic chart")
        }
    }
    Component {
        id: tabOsc
        TabButton {
            text: Z.tr("Oscilloscope plot")
        }
    }

    // Pages
    Component {
        id: pageTable
        Pages.FftTable {
            SwipeView.onIsCurrentItemChanged: {
                if(SwipeView.isCurrentItem) {
                    GC.currentGuiContext = GC.guiContextEnum.GUI_HARMONIC_TABLE
                }
            }
        }
    }
    Component {
        id: pageChart
        Pages.FftCharts {
            SwipeView.onIsCurrentItemChanged: {
                if(SwipeView.isCurrentItem) {
                    GC.currentGuiContext = GC.guiContextEnum.GUI_HARMONIC_CHART
                }
            }
        }
    }
    Component {
        id: pageOsc
        Osc.OsciModulePage {
            SwipeView.onIsCurrentItemChanged: {
                if(SwipeView.isCurrentItem) {
                    GC.currentGuiContext = GC.guiContextEnum.GUI_CURVE_DISPLAY
                }
            }
        }
    }

    // create tabs/pages dynamic
    Component.onCompleted: {
        let lastTabSelected = GC.lastTabSelected // keep - it is overwritten on page setup
        if(hasFft)
        {
            harmonicsTabsBar.addItem(tabChart.createObject(harmonicsTabsBar))
            swipeView.addItem(pageTable.createObject(swipeView))

            harmonicsTabsBar.addItem(tabEnergy.createObject(harmonicsTabsBar))
            swipeView.addItem(pageChart.createObject(swipeView))
        }
        if(hasOsci)
        {
            harmonicsTabsBar.addItem(tabOsc.createObject(harmonicsTabsBar))
            swipeView.addItem(pageOsc.createObject(swipeView))
        }
        swipeView.currentIndex = lastTabSelected
        swipeView.currentIndex = Qt.binding(() => harmonicsTabsBar.currentIndex);
    }
}
