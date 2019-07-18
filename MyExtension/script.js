'use strict';

if (window.top === window) {
    document.addEventListener("DOMContentLoaded", function(event) {
                              const html = document.getElementsByTagName("HTML");
                              console.log("stat to send message by using safari.extension.dispatchMessage:[" + location.href + "]");
                              safari.extension.dispatchMessage("message",
                                                               {BodyRaw: html[0].innerHTML});
                              });
   
    safari.self.addEventListener('message', hanedleReceivedMessage, false);

    function hanedleReceivedMessage(evt) {
        console.log("Message received from Extension handler");
    }
}
