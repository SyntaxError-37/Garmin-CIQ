import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;



class bartestApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
        System.println("App initilized");
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        System.println("App onstart");
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {

    }

    //! Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
       return [ new bartestView() ];
    }

}

function getApp() as bartestApp {
    return Application.getApp() as bartestApp;
}

