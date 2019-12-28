// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

(function() {
  // document.querySelector("#user_cancel_bus").on
  $("#user_cancel_bus").on("click", function() {
    var checked = $("#user_cancel_bus").is(":checked");

    $("#user_departure_location").prop("disabled", checked);
    $("#user_departure_time").prop("disabled", checked);
    $("#user_return_time").prop("disabled", checked);
  });
})();
