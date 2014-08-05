(function(namespace) {
  var BrowserUtils = namespace.BrowserUtils;

  BrowserUtils.reloadPage = function() {
    document.location.href = document.location.href;
  };
}(LNX_UTILS));
