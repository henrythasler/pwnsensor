import QtQuick 2.0


Rectangle{
     id: root
     color: "pink"
     border.width: 0
     property var points: []
     property var sensors: null
     property var current_item: 0
     property var chart_canvas: canvas



     Canvas {
         id: canvas
         width: parent.width
         height: parent.height
//         renderTarget: Canvas.FramebufferObject
//         renderTarget: Canvas.Image
//         renderStrategy: Canvas.Threaded
//         antialiasing: false

         function drawBackground(ctx) {
             ctx.save();
             ctx.fillStyle = "#252b31";
             ctx.fillRect(0, 0, canvas.width, canvas.height);
             ctx.strokeStyle = "#424a51";
             ctx.lineWidth = 1;
             ctx.beginPath();
             for (var i = 0; i <= 8; i++) {
                 ctx.moveTo(0, i * (canvas.height/8.0));
                 ctx.lineTo(canvas.width, i * (canvas.height/8.0));
             }

             for (i = 0; i <= 12; i++) {
                 ctx.moveTo(i * (canvas.width/12.0), 0);
                 ctx.lineTo(i * (canvas.width/12.0), canvas.height);
             }
             ctx.stroke();

             ctx.restore();
         }


         function drawGraph(ctx, item)
         {
             ctx.save();
             //ctx.globalAlpha = 0.7;
             ctx.strokeStyle = sensors.items[item].color;
             ctx.lineWidth = 2;
             ctx.lineCap = "round";
             ctx.lineJoin = "bevel";
             ctx.shadowColor = sensors.items[item].color;
             ctx.shadowBlur = 3;
             ctx.beginPath();

             var current_timestamp = sensors.timestamp;
             var tmin = sensors.items[item].tmin
             var scale_y = canvas.height / (sensors.items[item].ymax - sensors.items[item].ymin);
             var scale_x = -canvas.width / tmin;

             for (var i = 0, count=0; i < sensors.items[item].samples.length; i++)
                 {
                 if(sensors.items[item].samples[i].time >= (current_timestamp-tmin))
                    {
                     if (count == 0)
                         {
                         ctx.moveTo( (current_timestamp - sensors.items[item].samples[i].time - tmin) * scale_x,
                                    canvas.height-(sensors.items[item].samples[i].value - sensors.items[item].ymin) * scale_y);
                         }
                     else
                         {
                         ctx.lineTo( (current_timestamp - sensors.items[item].samples[i].time - tmin) * scale_x,
                                     canvas.height-(sensors.items[item].samples[i].value - sensors.items[item].ymin) * scale_y);
                         }
                    count++;
                    }
                 }
             ctx.stroke();
             ctx.restore();
         }

         onPaint: {
             var ctx = canvas.getContext("2d");
//             ctx.globalCompositeOperation = "source-over";  // default anyway
             drawBackground(ctx);

             for(var i=0; i<sensors.items.length; i++)
                {
                 if(sensors.items[i].checked)
                    {
                    drawGraph(ctx, i);
                    }
                }

//             drawGraph(ctx, current_item);

//             console.log(current_item);
         }
     }

}
