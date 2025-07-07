import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class tenetView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        // Get and show the current time
        var clockTime = System.getClockTime();
        var hour12 = (clockTime.hour % 12 == 0) ? 12 : clockTime.hour % 12;
        var timeString = Lang.format("$1$:$2$", [hour12.format("%02d"), clockTime.min.format("%02d")]);        
        var view = View.findDrawableById("TimeLabel") as Text;

        var font = Graphics.FONT_SYSTEM_NUMBER_THAI_HOT; 
        view.setFont(font);

        view.setColor(Graphics.COLOR_RED);
        view.setText(timeString);

        // Draw dial bitmap with Arabic numerals
        var dialBmp = WatchUi.loadResource(Rez.Drawables.ArabicDial) as WatchUi.BitmapResource;
      
        // Draw the bitmap centered on the screen
        var bmpX = (dc.getWidth() - dialBmp.getWidth()) / 2;
        var bmpY = (dc.getHeight() - dialBmp.getHeight()) / 2;
        dc.drawBitmap(bmpX, bmpY, dialBmp);
        
        // === ANALOG DISPLAY ===
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2; // shift analog circle lower

        var radius = 130;
        var hourAngle = ((clockTime.hour % 12) + clockTime.min / 60.0) * 30; // degrees
        var minAngle = clockTime.min * 6;

        var hourRad = (hourAngle - 90) * Math.PI / 180;
        var minRad = (minAngle - 90) * Math.PI / 180;

        var hourX = centerX + radius * 0.65 * Math.cos(hourRad);
        var hourY = centerY + radius * 0.65 * Math.sin(hourRad);
        var minX = centerX + radius * Math.cos(minRad);
        var minY = centerY + radius * Math.sin(minRad);

        // Draw clock circle and hands
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawCircle(centerX, centerY, radius);
        dc.fillCircle(centerX, centerY, 2);
        dc.drawLine(centerX, centerY, hourX, hourY); // hour hand
        dc.drawLine(centerX, centerY, minX, minY);   // minute hand

        var secAngle = clockTime.sec * 6;
        var secRad = (secAngle - 90) * Math.PI / 180;
        var secX = centerX + radius * 1.15 * Math.cos(secRad);
        var secY = centerY + radius * 1.15 * Math.sin(secRad);

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.drawLine(centerX, centerY, secX, secY);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    function getUpdateRate() {
        return 1000; // Update every 1 second
    }

}
