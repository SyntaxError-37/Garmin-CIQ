import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.System;



import Debug;
import Bars;

class bartestView extends WatchUi.DataField {

    var prg = 0;


    function initialize() {
        DataField.initialize();
        Debug.log("datafield initialized");

    }



    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {

        
        }


        
    

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        
        


        drawBars(dc, prg);
                prg = prg + 0.02;





    }

    function drawBars(dc as Dc, prg as Float) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.clear();


                
        var Colors = [
            Graphics.COLOR_BLACK,
            Graphics.COLOR_BLUE,
            Graphics.COLOR_DK_BLUE,
            Graphics.COLOR_DK_GRAY,
            Graphics.COLOR_DK_GREEN,
            Graphics.COLOR_DK_RED,
            Graphics.COLOR_GREEN,
            Graphics.COLOR_DK_GRAY,
            Graphics.COLOR_RED,
            Graphics.COLOR_YELLOW,
            Graphics.COLOR_PINK,
            Graphics.COLOR_PURPLE,
            Graphics.COLOR_ORANGE,
            Graphics.COLOR_LT_GRAY
        ];
        var _height = dc.getHeight();
        var _width = dc.getWidth();
        var _arcStart = (Math.rand().toFloat() / 2147483647.0) * 360.0;
        var _arcEnd = (Math.rand().toFloat() / 2147483647.0) * 180.0 + 30 ;
        var _direction = Math.rand() > 1073741823  ? Graphics.ARC_CLOCKWISE : Graphics.ARC_COUNTER_CLOCKWISE;
        var _colorvalue = Math.floor((Math.rand().toFloat() / 2147483647.0) * 13);
        var _color = Colors[_colorvalue.toNumber()];
        var font = Graphics.getVectorFont({ :face => "RobotoCondensedRegular", :size => 20, :scale => 1.0 });

        
        Bars.drawProgressBarArcRounded(
            dc,
            Math.round(_width * 0.5),
            Math.round(_height * 0.5),
            130,
            2,
            Math.round(_arcStart),
            Math.round(_arcStart+_arcEnd),
            _direction,
            prg,
            20,
            _color,
            Graphics.COLOR_BLACK,
            false,
            true,
            font
        );
        
        _arcStart = (Math.rand().toFloat() / 2147483647.0) * 360.0;
        _arcEnd = _arcStart + (Math.rand().toFloat() / 2147483647.0) * 100 + 30;
        _arcEnd = _arcEnd > 360 ? _arcEnd - 360 : _arcEnd;
        _direction = Math.rand() > 1073741823  ? Graphics.ARC_CLOCKWISE : Graphics.ARC_COUNTER_CLOCKWISE;
        _colorvalue = Math.floor((Math.rand().toFloat() / 2147483647.0) * 13);
        _color = Colors[_colorvalue.toNumber()];

        Bars.drawProgressBarArc(
            dc,
            Math.round(_width * 0.5),
            Math.round(_height * 0.5),
            105,
            0,
            Math.round(_arcStart),
            Math.round(_arcStart+_arcEnd),
            _direction,
            prg,
            20,
            _color,
            Graphics.COLOR_BLACK,
            false,
            true,
            font
        );

        _arcStart = (Math.rand().toFloat() / 2147483647.0) * 360.0;
        _arcEnd = (Math.rand().toFloat() / 2147483647.0) * 180.0 + 30;
        _direction = Math.rand() > 1073741823  ? Graphics.ARC_CLOCKWISE : Graphics.ARC_COUNTER_CLOCKWISE;
        _colorvalue = Math.floor((Math.rand().toFloat() / 2147483647.0) * 13);
        _color = Colors[_colorvalue.toNumber()];


        Bars.drawProgressBarArcRounded(
            dc,
            Math.round(_width * 0.5),
            Math.round(_height * 0.5),
            75,
            0,
            Math.round(_arcStart),
            Math.round(_arcStart+_arcEnd),
            _direction,
            prg,
            20,
            _color,
            Graphics.COLOR_BLACK,
            false,
            true,
            font
        );
        

        

    }
}
 