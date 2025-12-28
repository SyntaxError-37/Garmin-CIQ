import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;


module Bars {

    function cos(phi as Numeric) as Float {
        return Math.cos(Math.toRadians(phi)) as Float;
    }
    function sin(phi as Numeric) as Float {
        return Math.sin(Math.toRadians(phi)) as Float;
    }

    function getBarEndCords(dim as Array<Numeric or Graphics.ArcDirection>) as Array<Float> {
        var calc = [] as Array<Float>;

        // Calculate the radius to the middle of the bar, accounting for padding and height
        var _rBarMid = dim[2] - dim[3] - dim[4]/2 as Float;
        // Adjust direction for rounded ends based on arc direction
        var _add = dim[7] == Graphics.ARC_CLOCKWISE ? -1 : 1;
        // Calculate the angular adjustment for the rounded end cap
        var _arcAdjust = Math.toDegrees(Math.asin(dim[4]/2/_rBarMid)) as Float;
        // Start angle adjusted for rounded end
        var _deg = dim[5] + _add*_arcAdjust as Float;
        calc.add(dim[0] + cos(_deg) * _rBarMid);
        calc.add(dim[1] - sin(_deg) * _rBarMid);
        calc.add(_deg);
        // End angle adjusted for rounded end
        _deg = dim[6] - _add* _arcAdjust as Float;
        calc.add(dim[0] + cos(_deg) * _rBarMid);
        calc.add(dim[1] - sin(_deg) * _rBarMid);
        calc.add(_deg);
        return calc;
    }

    // draws Progressbar with Border at position X:Y with height/width and percenComp filled/receded Bar, optional show Percent filled/receded 
    // dimension = [x,y,width,height] of Bar as Lang.Array<Lang.Number>
    // sytle = [color of bar, backgroundColor, bordered?, rounded ends?, filling?, showPercent?, font] as Lang.Array<Graphics.ColorType, Graphics.ColorType, Boolean,Boolean, Graphics.FontType>
    function drawProgressbar(
        dc as Dc,
        dim as Array<Number>,
        percComp as Float,
        style as Array<Graphics.ColorType or Boolean or Graphics.FontType>
        ) as Void {

        var x = dim[0] as Number;
        var y =  dim[1] as Number;
        var width = dim[2] as Number;
        var height = dim[3] as Number;

        var clr = style[0] as Graphics.ColorType;
        var bGClr = style[1]as Graphics.ColorType;
        var border = style[2] as Boolean;
        var round = style[3] as Boolean;
        var fill = style[4] as Boolean;
        var showP = style[5] as Boolean;
        var font = style[6] as Graphics.FontType;

        if (width == 0 || height==0 ) {return;}
        var _bGClrOpp = (bGClr == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
        dc.setColor(_bGClrOpp, Graphics.COLOR_TRANSPARENT);
        
        var _borderW = border ? 1 : 0;

        dc.setPenWidth(1);
        if (!border) {dc.drawLine(x, y + 0.5 * height, x + width, y + 0.5 * height); } 
        else if (!round) {dc.setPenWidth(_borderW); dc.drawRectangle(x, y, width, height);} 
        else { dc.setPenWidth(_borderW); dc.drawRoundedRectangle(x, y, width, height, height * 0.5);}

        var _cPerc = percComp > 1.0 ? 0.9999 : percComp;
        _cPerc = percComp < 0.0 ? 0.0 : _cPerc;
        _cPerc = fill ? _cPerc : 1-_cPerc;
        var _fWidth = (width - _borderW * 2) * _cPerc;
        var _barStart = fill ? 0 : (width - _borderW * 2) * _cPerc;
        dc.setColor(clr, Graphics.COLOR_BLACK);        
        if (!round) {dc.fillRectangle( x + _barStart + _borderW, y + _borderW, _fWidth, height -  2 * _borderW);} else {dc.fillRoundedRectangle( x + _barStart + _borderW, y + _borderW, _fWidth, height -  2 * _borderW, height * 0.5);}

        //display percent number in Bar
        if (showP) {
            dc.setColor(_bGClrOpp, Graphics.COLOR_TRANSPARENT);
            var _percDisp = (_cPerc * 100).format("%.1f") + "%";
            var _txtJust = _cPerc <= 0.66 ? Graphics.TEXT_JUSTIFY_LEFT : Graphics.TEXT_JUSTIFY_RIGHT;
            dc.drawText(x + _borderW + _barStart, y - _borderW, font, _percDisp, _txtJust);
        }

    }

    //draws an arced Progressbar
    // dimension = [xCenter ,yCenter ,r ,padding ,height,arcStart,arcEnd,arcDirection] as Lang.Array<Lang.Number or Graphics.ArcDirection>
    // style = [color of bar, backgroundColor,border? , rounded ends?, filling?, showPercent?, font] as Lang.Array<Graphics.ColorType or Boolean or Graphics.FontType>
    function drawProgressbarArc(
        dc as Dc,
        dim as Array<Numeric or Graphics.ArcDirection>,
        percentComp as Float,
        style as Array<Graphics.ColorType or Boolean or Graphics.FontType or Null>
        ) as Void {

        var xC = dim[0] as Float;
        var yC = dim[1] as Float;
        var r = dim[2] as Float;
        var pad = dim[3] as Number;
        var height = dim[4] as Number;
        var arcS = dim[5] as Numeric;
        var arcE = dim[6] as Numeric;
        var dir = dim[7] as Graphics.ArcDirection;

        if (arcS==arcE || r < height) {return;}

        var clr = style[0] as Graphics.ColorType;
        var bGClr = style[1] as Graphics.ColorType;
        var border = style[2] as Boolean;
        var round = style[3] as Boolean;
        var fill = style[4] as Boolean;
        var showP = style[5] as Boolean;
        var font = showP ? style[6] as Graphics.FontType: null ;

        var _borderClr = bGClr == Graphics.COLOR_BLACK ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
        var _borderW = border ? 2 : 0;
        var _rBarMid = r - pad - height/2 ;
        var _inR = r - pad - height - 0.5 * _borderW;
        var _outR = r - pad - 0.5 * _borderW;
        var _cPerc = percentComp > 1 ? 0.995 : percentComp;
        _cPerc = percentComp <= 0.0 ? 0.005 : _cPerc;

        // Calculate arc length, clamping angles to [0, 360] and handling arcs crossing 360°
        while (arcS > 360) {arcS -= 360;}
        while (arcE > 360) {arcE -= 360;}
        while (arcS < 0) {arcS += 360;}
        while (arcE < 0) {arcE += 360;}
        var _arclength = arcE - arcS;

        // Adjust arc length for arcs crossing the 360° boundary based on direction
        if (arcS > arcE && dir == Graphics.ARC_COUNTER_CLOCKWISE)  {_arclength += 360;}
        if (arcS < arcE && dir == Graphics.ARC_CLOCKWISE)          {_arclength -= 360;}

        //calculates bar start and end
        var _barStart = fill ? arcS : arcS + _arclength * _cPerc;
        var _barEnd = fill ? arcS + _arclength * _cPerc : arcE;

        while (_barStart > 360) {_barStart -= 360;}
        while (_barEnd > 360) {_barEnd -= 360;}
        while (_barStart < 0) {_barStart += 360;}
        while (_barEnd < 0) {_barEnd += 360;}

        //draws bar
        dc.setPenWidth(height - _borderW);
        dc.setColor(clr, Graphics.COLOR_TRANSPARENT);
        dc.drawArc( xC, yC, _rBarMid, dir, _barStart, _barEnd);
        System.println(" " + _barStart + " " + _barEnd);
        //draw border or middle line
        dc.setColor(_borderClr, Graphics.COLOR_TRANSPARENT);


        if (border) {
            dc.setPenWidth(_borderW);
            dc.drawArc(xC, yC, _outR+_borderW*0.5, dir, arcS, arcE);
            dc.drawArc(xC, yC, _inR +_borderW*0.5, dir, arcS, arcE);
        } else {
            dc.setPenWidth(1);
            dc.drawArc(xC, yC, _rBarMid, dir, arcS, arcE);
        }        
        //calculate and draw ends 
        if (!round && border) {         
            dc.drawLine(Math.round(xC+cos(arcS)*_inR), Math.round(yC-sin(arcS)*_inR), Math.round(xC+cos(arcS)*_outR), Math.round(yC-sin(arcS)*_outR));
            dc.drawLine(Math.round(xC+cos(arcE)*_inR), Math.round(yC-sin(arcE)*_inR), Math.round(xC+cos(arcE)*_outR), Math.round(yC-sin(arcE)*_outR));
        } else if (round) {
            var _cords = getBarEndCords(dim);
            if (border) {            
            dc.drawArc(_cords[0], _cords[1], height / 2, dir , _cords[2] + 180, _cords[2]);
            dc.drawArc(_cords[3], _cords[4], height / 2, dir , _cords[5], _cords[5] + 180);
            }
            //round Ends
            dc.setColor(bGClr, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(height * 0.24 + 10*height/_rBarMid);
            dc.drawArc(_cords[0], _cords[1], height * 0.62 + 5*height/_rBarMid + _borderW, dir , _cords[2] + 180, _cords[2]);
            dc.drawArc(_cords[3], _cords[4], height * 0.62 + 5*height/_rBarMid + _borderW, dir , _cords[5], _cords[5] + 180);
        }
        if (showP) {
            //display percent Value 
            var _percDisp = (_cPerc * 100).format("%.1f") + "%";
            var _arcDisp = fill ? _barEnd : _barStart;
            //sets text direction to the display percent value correctly 
            var _textdir = _arcDisp < 180 ? Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE : Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE;           
            var _textradius = _textdir == Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE ? _inR + _borderW + 1 : _outR - _borderW - 1;
            var flipJustify = ((_arcDisp > 180 && dir == Graphics.ARC_CLOCKWISE) || (_arcDisp < 180 && dir == Graphics.ARC_COUNTER_CLOCKWISE));
            var _textJustify = _cPerc <= 0.66 ? (flipJustify ? Graphics.TEXT_JUSTIFY_RIGHT : Graphics.TEXT_JUSTIFY_LEFT) : (flipJustify ? Graphics.TEXT_JUSTIFY_LEFT : Graphics.TEXT_JUSTIFY_RIGHT);            
            dc.setColor(_borderClr, Graphics.COLOR_TRANSPARENT);
            dc.drawRadialText(xC, yC, font, _percDisp, _textJustify, _arcDisp, _textradius, _textdir);
        } 
    }

    //draws Bar with value range
    //dimension = [x,y,width,height] as Lang.Array<Lang.Number>
    //style = [backgroundcolor, colorInTarget, colorOutTarget, bordered?, indicator at Top?, indicator at Bottom?] as Lang.Array<Graphics.ColorType>
    function drawTargetBar(
        dc as Dc,
        dimension as Array<Number>,
        style as Array<Graphics.ColorType or Boolean>,
        values as Array<Float>
        ) as Void {

        var x = dimension[0] as Number;
        var y = dimension[1] as Number;
        var width = dimension[2] as Number;
        var height = dimension[3] as Number;

        var backgroundColor = style[0] as Graphics.ColorType;
        var colorInTarget = style[1] as Graphics.ColorType;
        var colorOutTarget = style[2] as Graphics.ColorType;
        var border = style[3] as Boolean;
        var indicatorTop = style[4] as Boolean;
        var indicatorBottom = style[5] as Boolean;


        var value = values[0] as Float;
        var minVal = values[1] as Float;
        var maxVal = values[2] as Float;


        if (width == 0 || height==0 ) {return;}
        var _backgroundColorOpp = (backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
        dc.setColor(_backgroundColorOpp, Graphics.COLOR_TRANSPARENT);

        var _borderW = border ? 1 : 0;
        
        if (border){
            dc.setPenWidth(_borderW);
            dc.drawRectangle(x, y, width, height);
        }
        
        var _barsegment1 = Math.round(3 * (width - 2 * _borderW) / 10);
        var _barsegment2 = Math.round(7 * (width - 2 * _borderW) / 10);

        dc.setColor(colorOutTarget, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x + _borderW, y + _borderW, _barsegment1, height - 2 * _borderW);
        dc.fillRectangle(x + _borderW + _barsegment2, y + _borderW, width - _barsegment2 - 2 * _borderW, height - 2 * _borderW);
        dc.setColor(colorInTarget, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x + _borderW + _barsegment1, y + _borderW, _barsegment2 - _barsegment1, height - 2 * _borderW);

        var _maxDisp = 1.75 * maxVal - 0.75 * minVal;
        var _minDisp = 1.75 * minVal - 0.75 * maxVal;
        var _barV = _maxDisp - _minDisp;

        var _indocatorsize = 8;
        var _percent = (value - _minDisp)  / _barV;
        _percent = _percent < 0.0 ? 0.0 : _percent;
        _percent = _percent > 1.0 ? 1.0 : _percent;
        var x1 = x + width * _percent;
        var x2 = x1 - _indocatorsize * 0.5;
        var x3 = x1 + _indocatorsize * 0.5;
        
        dc.setColor(_backgroundColorOpp, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(3);
        if (indicatorTop) {
            var yTop = y - Math.sqrt(3) * 0.5 * _indocatorsize;
            dc.drawLine(x1, y, x1, y + height);
            dc.fillPolygon([[x1, y], [x2, yTop], [x3, yTop]]);
        }
        if (indicatorBottom) {
            var yBottom = y + height + Math.sqrt(3) * 0.5 * _indocatorsize;
            dc.fillPolygon([[x1, y + height], [x2, yBottom], [x3, yBottom]]);
        }
    }


}