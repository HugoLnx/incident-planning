//= require jquery
//= require jquery_ujs

$(function() {
  var MAX_LINE_SIZE = 899;
  var BORDER_SIZE = 1;
  var $form_template = $("#form-template");
  $form_template.remove();

  var $form = createNewForm();
  var $matrixLines = $form.find(".matrix-lines");

  var totalSize = 0;
  $(".matrix-cells.line").each(function() {
    var $line = $(this);
    var idealSize = getIdealSize($line);

    if (totalSize + idealSize + BORDER_SIZE > MAX_LINE_SIZE) {
      var $lastLine = $matrixLines.find(".matrix-cells.line").last();
      $lastLine.height($lastLine.height() + MAX_LINE_SIZE - totalSize);

      $form = createNewForm();
      $matrixLines = $form.find(".matrix-lines");
      totalSize = 0;
    }

    $line.appendTo($matrixLines);
    $line.height(idealSize);
    totalSize += idealSize + BORDER_SIZE;
  });

  function getIdealSize($line) {
    var greaterHeight = 0;
    $line.find(".matrix-cell").each(function() {
      var $cell = $(this);
      var height = $cell.height();
      if (height > greaterHeight) {
        greaterHeight = height;
      }
    });
    return greaterHeight;
  }

  function createNewForm() {
    return $form_template.clone().show().appendTo(document.body);
  }
});
