package com.bunkerfit.bunkerfit_run

import io.flutter.embedding.android.FlutterActivity

import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import android.content.Context
import android.content.SharedPreferences

class MainActivity: FlutterActivity() {
    
    private lateinit var methodChannel : MethodChannel
    lateinit var shared : SharedPreferences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.v("Started Back","Started")

        methodChannel= MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger,"com.example.messages")
       methodChannel.setMethodCallHandler{call,result->

            if(call.method=="startService")
            {
                startServices()
            }
            else if(call.method=="stopService")
            {
                stopServices()
            }
            else if(call.method=="statusService")
            {
                statusServices()
                
            }
            else if(call.method=="isDataAvailable")
            {
                isDataAvailable()
                
            }
            
        }

        shared = getSharedPreferences("GeoDataHelp" , Context.MODE_PRIVATE)

    }
      lateinit var intent:Any
   fun startServices()
    {
        
        val editor:SharedPreferences.Editor =  shared.edit()  
        editor.putString("geoStats","start")  
        editor.apply() 

        intent=Intent(this,LocationService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent as Intent)
        }else
        {
            startService(intent as Intent)
        }
    }

    fun stopServices()
    {

        val editor:SharedPreferences.Editor =  shared.edit()  
        editor.putString("geoStats","stop")  
        editor.apply() 

        intent=Intent(this,LocationService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            stopService(intent as Intent)
        }else
        {
            stopService(intent as Intent)
        }

        
    }
    
    fun statusServices()
    {
        
        val geoCoordinates = shared.getString("geoCoordinates","[]")  

        var hashMap : HashMap<String, String?> = HashMap<String, String?> ()
        hashMap.put("geoCoordinates" , geoCoordinates)

        Log.v("hashMap","hashMap")
        // invoke dart method
        methodChannel.invokeMethod("fetchLatestGeo", hashMap)
        Log.v("hashMap2","hashMap2")
    }

    fun isDataAvailable()
    {
        
        val geoCoordinates = shared.getString("geoStats","status")  

        var hashMap : HashMap<String, String?> = HashMap<String, String?> ()
        hashMap.put("geoStats" , geoCoordinates)

        Log.v("hashMap","hashMap")
        // invoke dart method
        methodChannel.invokeMethod("isDataAvailable", hashMap)
        Log.v("hashMap2","hashMap2")
    }
    
    override fun onDestroy() {
        super.onDestroy()
        //stopService(intent as Intent)
    }
}
