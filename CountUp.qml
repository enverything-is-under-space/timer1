import QtQuick
import "theScripts/updateCountUp.js" as UCUP
import "theControls"
import QtQuick.Controls


Item
{
    clip:true;
    property int theDay: 999 ;
    property int theHour: 999;
    property int theMinute: 999;
    property int theSecond: 999;
    property int theLapIndex:0;

    property color colorButtons: "orange";
    property color colorButtonTexts: "white";

    property color setColorBG: "white";
    property color colorButtonSecond: "pink";
    property color  colorButtonSecondTexts: "black";

    anchors.fill: parent;
    Rectangle
    {
        id:root;
        anchors.fill: parent;
        color:setColorBG;
    }

    Timer
    {
        id:theCountUpTimer;
        interval: 1000; running: false; repeat: true
        onTriggered:
        {
            var allObject = JSON.parse(UCUP.updateCountUp(theDay,theHour,theMinute,theSecond));
            theDay = allObject.d;
            theHour = allObject.h;
            theMinute = allObject.m;
            theSecond = allObject.s;

            if(theMinute<10 || theHour<10 || theSecond<10 || theDay<10)
            {
                if(theDay<10)
                    txtNumbers.text = "0"+theDay;
                else
                    txtNumbers.text = theDay;

                if(theHour<10)
                    txtNumbers.text += ":0"+theHour;
                else
                    txtNumbers.text += ":"+theHour;


                if(theMinute<10)
                    txtNumbers.text += ":0" + theMinute;
                else
                    txtNumbers.text += ":"+theMinute;


                if(theSecond<10)
                    txtNumbers.text += ":0" + theSecond;
                else
                    txtNumbers.text += ":" + theSecond;
            }
            else
                txtNumbers.text = theDay+ ":" + theHour + ":" + theMinute + ":" +theSecond;

        }
    }

    Rectangle
    {
        id:baseCountUp;
        width: root.width/1.2;
        height:root.height/5.5;
//        anchors.verticalCenter: root.verticalCenter;
        anchors.top: root.top;
        anchors.topMargin: parent.height/2.7;
        anchors.horizontalCenter: root.horizontalCenter;
        color:"transparent";
        Text
        {
            id:txtNumbers;
            text:"00:00:00:00";
            font.pointSize: 40;
            anchors
            {
                verticalCenter:parent.verticalCenter;
                horizontalCenter:parent.horizontalCenter;
            }
        }

        Text
        {
            text:" Day   Hour   Min    Sec";
            font.pointSize: 20;
            anchors
            {
                verticalCenter:parent.verticalCenter;
                horizontalCenter:parent.horizontalCenter;
                left:txtNumbers.left;
                top:txtNumbers.bottom;
            }
        }

    }//end of baseCountup

    Rectangle
    {
        id:baseLapList;
        width: baseCountUp.width;
        height:parent.height/2.1;
        visible: false;
        color:"transparent";
        anchors
        {
            top:baseCountUp.bottom;
            topMargin:baseCountUp.height/2.7;
            horizontalCenter:parent.horizontalCenter;
        }

        Rectangle
        {
            id:titleLapList;
            width: parent.width;
            height:50;
            color:"transparent";
            Rectangle
            {
                id:laplabell;
                width: parent.width/3;
                height: parent.height;
                anchors.left: parent.left;
                color:"transparent";
                Text
                {

                    text:"Lap No.";
                    font.pointSize: 12;
                    anchors.centerIn:parent;
                }
            }
            Rectangle
            {
                id:laptimeslabel;
                width: parent.width/3;
                height: parent.height;
                anchors.horizontalCenter: parent.horizontalCenter;
                color:"transparent";
                Text
                {

                    text:"Lap times";
                    font.pointSize: 12;
                    anchors.centerIn:parent;
                }
            }
            Rectangle
            {
                id:overalltimelabel;
                width: parent.width/3;
                height: parent.height;
                anchors.right: parent.right;
                color:"transparent";
                Text
                {
                    text:"Overall time";
                    font.pointSize: 12;
                    anchors.centerIn:parent;
                }
            }

        }







        ListView
        {
            id:listviewLaps
            anchors
            {
                top:titleLapList.bottom;
                left:parent.left;
                right:parent.right;
                bottom:parent.bottom;
            }
            clip:true;
            model: ListModel
            {
                id:listModelData;
            }
            delegate: Item
            {
                id:something
                width: 100;
                height: 50;
                Rectangle
                {
                    id:some1;
                    width: laplabell.width;
                    height: laplabell.height;
//                    anchors.left:laplabell.left;
                    color:"transparent";
                    Text
                    {
                        anchors.centerIn: some1;
                        text:lapId;
                    }
                }
                Rectangle
                {
                    id:some2;
                    width: some1.width;
                    height: laplabell.height;
                    anchors.left:some1.right;
                    color:"transparent";
                    Text
                    {
                        anchors.centerIn: some2;
                        text:timee;
                    }
                }
                Rectangle
                {
                    id:some3;
                    width: some2.width;
                    height: laplabell.height;
                    anchors.left:some2.right;
                    color:"transparent";
                    Text
                    {
                        anchors.centerIn: some3;
                        text:timee;
                    }
                }


            }

//            Component.onCompleted:
//            {
//                listModelData.append({
//                    timee: "1010",
//                    lapId: 4
//                });
//            }
        }

    }




    MyThreeBottomButtons
    {
        id:idMyThreeBottomButtons;
        width: root.width;
        height:root.height/10.5;
        setCenterButtonText: "Start";
        setLeftButtonText: "Reset";
        setRightButtonText: "Lap";
        anchors
        {
            bottom:root.bottom;
            bottomMargin:15;
        }
        onCenterButtonPressed:
        {
            if(!theCountUpTimer.running && (setCenterButtonText == "Start"||setCenterButtonText=="Resume"))
            {
                theCountUpTimer.start();
                setCenterButtonText= "Pause";
            }
            else
            {
                setCenterButtonText= "Resume";
                theCountUpTimer.stop();
            }
        }
        onLeftButtonPressed:
        {
            if(theCountUpTimer.running)
                theCountUpTimer.stop();

            setCenterButtonText= "Start";
            theDay = theHour = theMinute = theSecond = 0;
            txtNumbers.text = "00:00:00:00";
            baseCountUp.anchors.topMargin= parent.height/2.7;
            if(baseLapList.visible)
                baseLapList.visible=false;
            while(theLapIndex>0)
            {
                theLapIndex--;
                listModelData.remove(theLapIndex);
            }


        }
        onRightButtonPressed:
        {
            if(idMyThreeBottomButtons.setCenterButtonText != "Start") //&& idMyThreeBottomButtons.setCenterButtonText != "Resume"
            {
                baseCountUp.anchors.topMargin = parent.height/8;
                baseLapList.visible=true;
                var temp_value;
                if(theDay<=0 && theHour<=0)
                     temp_value = txtNumbers.text.slice(6);
                else if(theDay<=0)
                    temp_value = txtNumbers.text.slice(3);
                else
                    temp_value = txtNumbers.text;


                listModelData.append
                ({
                    timee: temp_value,
                    lapId: ++theLapIndex
                }); //error QML Rectangle: Cannot anchor to an item that isn't a parent or sibling.
            }
        }
    }



}
