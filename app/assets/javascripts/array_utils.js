(function(namespace) {
  var ArrayUtils = namespace.ArrayUtils;

  ArrayUtils.splice = function(array, index, qntToDelete, elementsToInsert) {
    var params = [index, qntToDelete];
    Array.prototype.push.apply(params, elementsToInsert);
    return Array.prototype.splice.apply(array, params);
  };
}(LNX_UTILS));
