(function(namespace) {
  var ArrayUtils = namespace.ArrayUtils;

  ArrayUtils.splice = function(array, index, qntToDelete, elementsToInsert) {
    var params = [index, qntToDelete];
    Array.prototype.push.apply(params, elementsToInsert);
    return Array.prototype.splice.apply(array, params);
  };

  ArrayUtils.deleteAt = function(array, index) {
    var removedElements =  array.splice(index, 1);
    return removedElements[0]
  };
}(LNX_UTILS));
