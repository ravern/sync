// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket")
socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("session:" + window.sessionSlug, {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("page", payload => {
  $('#images').children('img').each(function(i) {
    if (payload.value == i) {
      this.style = "";
    } else {
      this.style = "display:none";
    }
  })
});

$(document).on("keydown", function(e) {
  switch (e.which) {
    case 37:
      channel.push("decrement", {});
      break;
    case 39:
      channel.push("increment", {});
      break;
  }
});

export default socket
