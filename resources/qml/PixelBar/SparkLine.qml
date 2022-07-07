import QtQuick 2.15

Canvas {
    id: control

    width: 200
    height: 80

    property var data: Array()
    property var strokeColor: "lime"
    property int maximumValues: 60

    property var calculatedMin
    property var calculatedMax

    property var average
    property var min: calculatedMin
    property var max: calculatedMax

    property int validValues: 0

    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0, 0, control.width, control.height);
        ctx.strokeStyle = control.strokeColor;

        var x_range = control.data.length;

        if(x_range == 0 || control.validValues == 0)
            return;

        var y_range = control.max - control.min;

        if(x_range == 1) {
            var y_pos = control.height / 2;
            ctx.beginPath();
            ctx.moveTo(0, y_pos);
            ctx.lineTo(control.width, y_pos);
            ctx.stroke();

            return;
        }

        var x_pos = 0;
        var y_pos = yPos(control.data[0]);

        var pathBegun = false
        for(var d in control.data) {
            var value = control.data[d];
            if(value != undefined) {
                if(!pathBegun) {
                    ctx.beginPath(x_pos, y_pos);
                    pathBegun = true;
                }

                y_pos = yPos(value);
                x_pos = (d / (x_range-1)) * control.width;
                ctx.lineTo(x_pos, y_pos);
            } else {
                if(pathBegun) {
                    ctx.stroke();
                    pathBegun = false;
                }
            }
        }
        if(pathBegun) {
            ctx.stroke();
        }

        function yPos(value) {
            return (1 - ((value - control.min) / y_range)) * control.height;
        }
    }

    function addValue(value) {
        data.push(value);
        while(data.length > control.maximumValues) {
            data.shift();
        }
        control.analyzeData()
        control.requestPaint()
    }

    function analyzeData() {
        var analyzed = minMaxSum(control.data);
        control.validValues = analyzed.values;
        if (analyzed.values > 0) {
            control.average = analyzed.sum / analyzed.values;
            control.calculatedMin = analyzed.min;
            control.calculatedMax = analyzed.max;
        } else {
            control.average = undefined;
            control.calculatedMin = undefined;
            control.calculatedMax = undefined;
        }
    }

    function minMaxSum(items) {
        if (items.length == 0)
            return {min:undefined, max:undefined, sum:undefined, values: 0}
        return items.reduce((acc, val) => {
            if(val == undefined) {
                return acc;
            }
            acc.min = ( val < acc.min || acc.min == undefined ) ? val : acc.min;
            acc.max = ( val > acc.max || acc.max == undefined ) ? val : acc.max;
            if (acc.sum == undefined)
                acc.sum = 0;
            acc.sum += val;
            acc.values++;

            return acc;
        }, {min: undefined, max: undefined, sum: undefined, values: 0});
    }
}