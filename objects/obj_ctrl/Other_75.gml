
if (async_load[? "event_type"] == "post_message_received")
{
    var _origin = async_load[? "origin"];
    
    if (_origin != undefined)
    {
        show_debug_message("Message received from: " + string(_origin));
    }
    
    var _data = async_load[? "data"];    
    
    if (_data != undefined)
    {
        show_debug_message("Message received: " + string(_data));
    }
}
