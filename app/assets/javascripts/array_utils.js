(function(namespace) {
  var ArrayUtils = namespace.ArrayUtils;

  ArrayUtils.splice = function(array, index, qntToDelete, elementsToInsert) {
    var params = [index, qntToDelete];
    var elementsToInsert = ArrayUtils.forceArray(elementsToInsert);
    Array.prototype.push.apply(params, elementsToInsert);
    return Array.prototype.splice.apply(array, params);
  };

  ArrayUtils.deleteAt = function(array, index) {
    var removedElements =  array.splice(index, 1);
    return removedElements[0]
  };

  ArrayUtils.forceArray = function(arrayOrJQuery) {
    if (arrayOrJQuery.jquery) {
      return arrayOrJQuery.get();
    }
    return arrayOrJQuery;
  }
}(LNX_UTILS));
