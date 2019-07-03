App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  connected: function () {
    console.log("connected");
    // Called when the subscription is ready for use on the server
  },

  disconnected: function () {
    console.log("disconnected");
    // Called when the subscription has been terminated by the server
  },

  received: function (data) {
    // Called when there's incoming data on the websocket for this channel
    $("#counter_notifications").text(data.counter);
    $("#notifications").text('');
    data.notifications.forEach(element => {
      $("#notifications").append(element);
    });
    $("#notifications").append("<a class=\"message\" href=\"/notifications\">See all</a>\n");
  }
});
