import QtQuick 2.15

Canvas {
    id: control

    width: 200
    height: 80

    property var data: Array()
    property var strokeColor: "lime"
    property int maximumValues: 60

    property real calculatedMin
    property real calculatedMax

    property real average
    property real min: calculatedMin
    property real max: calculatedMax

    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0, 0, control.width, control.height);
        ctx.strokeStyle = control.strokeColor

        var x_range = control.data.length;

        if(x_range == 0)
            return;

        var y_range = max - min;

        if(x_range == 1 || y_range == 0) {
            var y_pos = control.height / 2;
            ctx.beginPath();
            ctx.moveTo(0, y_pos);
            ctx.lineTo(control.width, y_pos);
            ctx.stroke();

            return;
        }

        var x_pos = 0;
        var y_pos = yPos(control.data[0]);

        ctx.beginPath(x_pos, y_pos);
        for(var d in control.data) {
            y_pos = yPos(control.data[d]);
            x_pos = (d / (x_range-1)) * control.width
            ctx.lineTo(x_pos, y_pos);
        }
        ctx.stroke();

        function yPos(value) {
            return (1 - ((value - min) / y_range)) * control.height;
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
        var analyzed = minMaxSum(control.data)
        if (analyzed.values > 0) {
            average = analyzed.sum / analyzed.values
            calculatedMin = analyzed.min
            calculatedMax = analyzed.max
        } else {
            average = undefined
            calculatedMin = undefined
            calculatedMax = undefined
        }
    }

    function minMaxSum(items) {
        if (items.length == 0)
            return {min:undefined, max:undefined, sum:undefined}
        return items.reduce((acc, val) => {
            if(val == undefined) {
                return acc;
            }
            acc.min = ( val < acc.min ) ? val : acc.min;
            acc.max = ( val > acc.max ) ? val : acc.max;
            acc.sum += val;
            acc.values++;

            return acc;
        }, {min: items[0], max: items[0], sum:0, values: 0});
    }
}